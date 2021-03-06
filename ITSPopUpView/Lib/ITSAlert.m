//
//  ITSAlert.m
//  ITSAlert
//

#import "ITSAlert.h"
#import "ITSCoreAlertView.h"
#import "ITSAlertViewBrandingManager.h"

#import <UIKit/UIKit.h>

const char *InvalidArgumentException = "InvalidArgumentException";

@interface ITSAlertOptionsDataSource : NSObject<UITableViewDataSource, ITSAlertOptionsDelegate>
@property (nonatomic, strong) NSArray *array;
- (instancetype) initWithDataSourceArray: (NSArray *) array;
@end

@implementation ITSAlertOptionsDataSource

- (instancetype) initWithDataSourceArray: (NSArray *) array {
	self = [super init];
	
	if (self) {
		_array = array;
	}
	
	return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([self respondsToSelector:@selector(numberOfOptions)]) {
		return [self numberOfOptions];
	}
	
	return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.array.count < indexPath.row) {
		return nil;
	}
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
	cell.tintColor = [ITSAlertViewBrandingManager sharedManager].headerBackgroundColor;
	cell.textLabel.text = self.array[indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	return cell;
}

- (NSString *) objectAtIndexPath: (NSIndexPath *) indexPath {
	
	if (indexPath.row > self.array.count) {
		[NSException raise:@"Selected object index cannot be more than option count" format:@"Selected index %ld Option count %lu", (long)indexPath.row , (unsigned long)self.array.count];
	}
	
	return self.array[indexPath.row];
}

- (NSInteger) numberOfOptions {
	return self.array.count;
}

- (void) cleanUp {
	self.array = nil;
}

@end

@interface ITSAlert () <UITableViewDelegate>

@property (nonatomic, strong) ITSCoreAlertView *alertView;
@property (nonatomic, strong) NSMutableSet *selectedOptionsSet;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<UITableViewDataSource, ITSAlertOptionsDelegate> alertOptionsDataSource;
@property (nonatomic, strong) SelectedOptionsBlock selectedOptionsBlock;
@property (nonatomic, strong) SelectedOptionBlock tappedOptionBlock;
@property (nonatomic, assign) NSInteger selectionLimit;
@property (nonatomic, assign) BOOL backgroundBlur;
@property (nonatomic, weak) UIView *parentView;

@end

@implementation ITSAlert

// Multi select with no limit
- (instancetype) initMultiSelectWithOptions: (NSArray *) options withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock {
    return [[ITSAlert alloc] initMultiSelectWithOptions:options withTitle:title andDescription:description selectedOptionsBlock:selectedOptionsBlock selectionLimit: (options?options.count:-1)];
}

- (instancetype) initSingleSelectWithOptions: (NSArray *) options withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionBlock) selectedOptionBlock {
    return [[ITSAlert alloc] initMultiSelectWithOptions:options withTitle:title andDescription:description selectedOptionsBlock:^(NSArray *selectedObjects) {
        
        if (selectedObjects && selectedObjects.count > 0 ) {
            (!selectedOptionBlock)?:selectedOptionBlock([selectedObjects firstObject]);
        } else {
            (!selectedOptionBlock)?:selectedOptionBlock(nil);
        }
        
    } selectionLimit:1];
}

/**
 *	Multi select alert view with selection limiter
 */
- (instancetype) initMultiSelectWithOptions: (NSArray *) options
                                  withTitle: (NSString *) title
                             andDescription: (NSString *) description
                       selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock
                             selectionLimit: (NSInteger) selectionLimit {
    
    return [[ITSAlert alloc] initMultiSelectWithDataSource:[[ITSAlertOptionsDataSource alloc] initWithDataSourceArray:options] withTitle:title andDescription:description selectedOptionsBlock:selectedOptionsBlock selectionLimit:selectionLimit];
}

/**
 *	Multi select with external data source
 */
- (instancetype) initMultiSelectWithDataSource: (id<UITableViewDataSource, ITSAlertOptionsDelegate>) dataSource withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock {
	return [[ITSAlert alloc] initMultiSelectWithDataSource:dataSource withTitle:title andDescription:description selectedOptionsBlock:selectedOptionsBlock selectionLimit:-1];
}

- (instancetype) initMultiSelectWithDataSource: (id) dataSource
                                     withTitle: (NSString *) title
                                andDescription: (NSString *) description
                          selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock
                                selectionLimit: (NSInteger) selectionLimit {
	
	self = [super init];
	
	if (self) {
		_alertOptionsDataSource = dataSource;
		_selectedOptionsBlock = selectedOptionsBlock;
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		
		if ([_alertOptionsDataSource respondsToSelector:@selector(registerNibOfOptionsCellForTableView:)]) {
			[_alertOptionsDataSource registerNibOfOptionsCellForTableView:_tableView];
		}
		
		_tableView.dataSource  = _alertOptionsDataSource;
		_tableView.delegate = self;
		_tableView.allowsSelection = YES;
		_tableView.showsVerticalScrollIndicator = NO;
        _selectionLimit = ((selectionLimit <= 0) ? INT32_MIN:selectionLimit);
        
        [_tableView reloadData];
        
        if (!_alertView) {
            
            __weak __typeof__(self) weakSelf = self;
            
            _parentView = [UIApplication sharedApplication].keyWindow;
            
            self.backgroundBlur = NO;
            
            self.frame  = CGRectOffset(_parentView.frame, 0, 0);
            
            _alertView = [[ITSCoreAlertView alloc] initWithTitle: title
                                                        subtitle: description
                                                     headerImage: nil
                                                       tableView: _tableView
                                                    buttonTitles:@[@"Cancel",@"Done"]
                                             negativeButtonIndex:-1
                                             positiveButtonIndex:-1
                                                          hidden:^{
                                                              // Clean up
                                                              [weakSelf hide];
                                                          }
                          
                                              buttonPressedBlock:^(NSInteger buttonIndex) {
                                                  
                                                  if (buttonIndex == 1) {
                                                      
                                                      NSArray *selectedIndicesIndexPath = [weakSelf.selectedOptionsSet allObjects];
                                                      
                                                      if (!selectedIndicesIndexPath || selectedIndicesIndexPath.count == 0) {
                                                          weakSelf.selectedOptionsBlock(nil);
                                                      }
                                                      
                                                      NSMutableArray *selectedObjects= [[NSMutableArray alloc] initWithCapacity:selectedIndicesIndexPath.count];
                                                      
                                                      for (NSIndexPath *idxPath in selectedIndicesIndexPath) {
														  
														  if ([weakSelf.tableView.dataSource respondsToSelector:@selector(objectAtIndexPath:)]) {
															  [selectedObjects addObject:[(id<ITSAlertOptionsDelegate>)weakSelf.tableView.dataSource objectAtIndexPath:idxPath]];
														  } else {
															  [selectedObjects addObject:idxPath];
														  }
                                                      }
                                                      
                                                      weakSelf.selectedOptionsBlock(selectedObjects);
                                                  }
                                              }];
            [self addSubview:_alertView];
        }
	}
	
	return self;
}

// Simple Notification alert having title, message and okay button
- (instancetype) initNotificationAlertWithTitle:(NSString *) title andMessage:(NSString *) message buttonTitle: (NSString *)buttonTitle buttonBlock: (ButtonClickBlock) buttonPressedBlock {

    self = [super init];
    
    if (self) {
        
        __weak __typeof__(self) weakSelf = self;
        
        _parentView = [UIApplication sharedApplication].keyWindow;
        
        self.backgroundBlur = NO;
        
        self.frame  = CGRectOffset(_parentView.frame, 0, 0);
        
        _alertView = [[ITSCoreAlertView alloc] initWithTitle:title
                                                    subtitle:message
                                                 headerImage:nil
                                                 description:nil
                                                buttonTitles:@[buttonTitle]
                                         negativeButtonIndex:-1
                                         positiveButtonIndex:-1
                                                      hidden:^{
                                                          [weakSelf hide];
                                                      } buttonPressedBlock:^(NSInteger buttonIndex) {
                                                          (!buttonPressedBlock)?:buttonPressedBlock();
                                                      }];
        
        [self addSubview:_alertView];
    }
    
    return self;
}

// Simple Permission alert having title, message and couple of buttons
- (instancetype) initSimpleAlertWithTitle:(NSString *) title andMessage:(NSString *) message positiveTitle: (NSString *)pt positiveBlock: (ButtonClickBlock) positiveBlock {
    self = [self initSimpleAlertWithTitle:title andMessage:message positiveTitle:title negativeTitle:@"Cancel" positiveBlock:positiveBlock negativeBlock:nil];
    return self;
}

- (instancetype) initTapSelectWithDataSource: (id) dataSource withTitle:(NSString *) title andDescription:(NSString *) description tappedOptionBlock: (SelectedOptionBlock) tOB dismissTitle:(NSString *)dt dismissActionBlock:(ButtonClickBlock) dAB primaryActionTitle:(NSString *)pt primaryActionBlock: (ButtonClickBlock) pAB {

    self = [super init];
    
    if (self) {
        _parentView = [UIApplication sharedApplication].keyWindow;
        _alertOptionsDataSource = dataSource;
        _tappedOptionBlock = tOB;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        if ([_alertOptionsDataSource respondsToSelector:@selector(registerNibOfOptionsCellForTableView:)]) {
            [_alertOptionsDataSource registerNibOfOptionsCellForTableView:_tableView];
        }
        
        _tableView.dataSource  = _alertOptionsDataSource;
        _tableView.delegate = self;
        _tableView.allowsSelection = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView reloadData];
        
        if (!_alertView) {
            
            __weak __typeof__(self) weakSelf = self;
            
            _parentView = [UIApplication sharedApplication].keyWindow;
            
            self.backgroundBlur = NO;
            
            self.frame  = CGRectOffset(_parentView.frame, 0, 0);
            
            NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
            
            if (dt) {
                [buttonArray addObject:dt];
            }
            
            if (pt) {
                [buttonArray addObject:pt];
            }
            
            _alertView = [[ITSCoreAlertView alloc] initWithTitle: title
                                                        subtitle: description
                                                     headerImage: nil
                                                       tableView: _tableView
                                                    buttonTitles: buttonArray
                                             negativeButtonIndex:-1
                                             positiveButtonIndex:1
                                                          hidden:^{
                                                              // Clean up
                                                              [weakSelf hide];
                                                          }
                          
                                              buttonPressedBlock:^(NSInteger buttonIndex) {
                                                                                                    
                                                  if (buttonIndex == 1 ) {
                                                      (!pAB)?: pAB();
                                                  } else if (buttonIndex == 0) {
                                                      (!dAB)?: dAB();
                                                  }
                                              }];
            [self addSubview:_alertView];
        }
    }
    
    return self;
}

- (void) setBackgroundBlur:(BOOL)backgroundBlur {
    
    _backgroundBlur = backgroundBlur;
    
    if (!_backgroundBlur) {
        self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].backgroundOpacityColor;
    }
}

- (void) constructView {
    
    // Load from pop up view configuration manager
    self.backgroundBlur = NO;
    
    [self addSubview:self.alertView];
}

- (instancetype) initSimpleAlertWithTitle:(NSString *) title andMessage:(NSString *) message positiveTitle: (NSString *)pt negativeTitle: (NSString *)nt positiveBlock: (ButtonClickBlock) positiveBlock negativeBlock: (ButtonClickBlock) negativeBlock {
    
    self = [super init];
    
    if (self) {
        
        __weak __typeof__(self) weakSelf = self;
        
        _parentView = [UIApplication sharedApplication].keyWindow;
        
        self.backgroundBlur = NO;
        
        self.frame  = CGRectOffset(_parentView.frame, 0, 0);
        
        _alertView = [[ITSCoreAlertView alloc] initWithTitle:title
                                                    subtitle:message
                                                 headerImage:nil
                                                 description:nil
                                                buttonTitles:@[nt, pt]
                                         negativeButtonIndex:-1
                                         positiveButtonIndex:-1
                                                      hidden:^{
            [weakSelf hide];
                                                          
        } buttonPressedBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                // cancel called
                (!negativeBlock)?:negativeBlock();
            } else {
                // done called
                (!positiveBlock)?:positiveBlock();
            }
        }];
        
        [self addSubview:_alertView];
    }
    
    return self;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (_tappedOptionBlock) {
        if ([_alertOptionsDataSource respondsToSelector:@selector(objectAtIndexPath:)]) {
            self.tappedOptionBlock([_alertOptionsDataSource objectAtIndexPath:indexPath]);
        } else {
            self.tappedOptionBlock(indexPath);
        }
    }
    
	if (!_selectedOptionsSet) {
		_selectedOptionsSet = [[NSMutableSet alloc] init];
	}
	
	BOOL checkmarkOnSelection = YES;
	
	if ([_alertOptionsDataSource respondsToSelector:@selector(checkmarkOnSelection)]) {
		checkmarkOnSelection = [_alertOptionsDataSource checkmarkOnSelection];
	}
	
	if ([self.selectedOptionsSet containsObject:indexPath]) {
		
		// Remove from set
		[self.selectedOptionsSet removeObject:indexPath];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else {
		
		// Check if selection limit reached
		if (self.selectionLimit > 0 && self.selectedOptionsSet.count >= self.selectionLimit) {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			return;
		}
		
		// Add from set
		[self.selectedOptionsSet addObject:indexPath];
		
		if (checkmarkOnSelection) {
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (instancetype) initNewArchitecture {
    
    self = [super init];
    
    if (self) {
        
        __weak __typeof__(self) weakSelf = self;
        
        _parentView = [UIApplication sharedApplication].keyWindow;

        self.backgroundBlur = NO;

        self.frame  = CGRectOffset(_parentView.frame, 0, 0);
        
        _alertView = [[ITSCoreAlertView alloc] initWithTitle:@"Alert"
                                                    subtitle:@"Architecture"
                                                 headerImage:nil
                                                 description:nil
                                                buttonTitles:@[@"Cancel", @"Ok"]
                                         negativeButtonIndex:-1
                                         positiveButtonIndex:-1
                                                      hidden:^{
                                                          [weakSelf hide];
                                                      }
                                          buttonPressedBlock:nil];
        
        [self addSubview:_alertView];
        
    }
    
    return self;
}

- (void) show {
    
    __weak typeof(self) weakSelf = self;
    
    if (nil == self.parentView) {
        return;
    }
    
    if (nil == [self superview]) {
        self.alertView.center = self.center;
        [self.parentView addSubview:self];
    }
    
    [self.layer setOpacity:0.0f];
    self.alertView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.layer setOpacity:1.0f];
        weakSelf.alertView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void) hide {
    
    __weak typeof(self) weakSelf = self;
    
    if (self.alertView.superview) {
        self.alertView.hidden = YES;
        return;
    }
    
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [weakSelf.layer setOpacity:0.0f];
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
        
        if (_alertOptionsDataSource) {
            [_alertOptionsDataSource cleanUp];
            _alertOptionsDataSource = nil;
        }
        
        _alertView = nil;
        _selectedOptionsSet = nil;
        _tableView = nil;
        _selectedOptionsBlock = nil;
    }];
}

@end
