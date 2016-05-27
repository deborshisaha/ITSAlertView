//
//  ITSAlert.m
//  ITSAlert
//

#import "ITSAlert.h"
#import "ITSCoreAlertView.h"

const char *InvalidArgumentException = "InvalidArgumentException";

@interface ITSAlert () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ITSCoreAlertView *alertView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableSet *selectedOptionsSet;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) SelectedOptionsBlock selectedOptionsBlock;
@property (nonatomic, assign) NSInteger selectionLimit;

@end

@implementation ITSAlert

// Multi select with no limit
- (instancetype) initMultiSelectWithOptions: (NSArray *) options withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock {
    return [[ITSAlert alloc] initMultiSelectWithOptions:options withTitle:title andDescription:description selectedOptionsBlock:selectedOptionsBlock selectionLimit: (options?options.count:0)];
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

- (instancetype) initMultiSelectWithOptions: (NSArray *) options
                                  withTitle: (NSString *) title
                             andDescription: (NSString *) description
                       selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock
                             selectionLimit: (NSInteger) selectionLimit {
    
    self = [super init];
    
    if (self) {
        _array = options;
        _tableView.allowsSelection = NO;
        _selectedOptionsBlock = selectedOptionsBlock;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
		_tableView.dataSource  = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _selectionLimit = ((selectionLimit < 0) ? 0:selectionLimit);
        
        if (_selectionLimit > options.count) {
            [NSException raise:[NSString stringWithUTF8String:InvalidArgumentException] format:@"'selectionLimit' cannot be more than options array length"];
        }

        [_tableView reloadData];
        
        if (!_alertView) {
            
            __weak __typeof__(self) weakSelf = self;
            
            _alertView = [[ITSCoreAlertView alloc] initWithTitle: title
                                                        subtitle: description
                                                     headerImage: nil
                                                       tableView: _tableView
                                                    buttonTitles: @[@"Cancel",@"Done"]
                                             negativeButtonIndex:-1
                                             positiveButtonIndex:1
                          
                                                          hidden:^{
                                                              // Clean up
                                                              [weakSelf cleanUp];
                                                          }
                          
                                              buttonPressedBlock:^(NSInteger buttonIndex) {
                                                  
                                                  if (buttonIndex == 1) {
                                                      
                                                      NSArray *selectedIndicesIndexPath = [self.selectedOptionsSet allObjects];
                                                      
                                                      if (!selectedIndicesIndexPath || selectedIndicesIndexPath.count == 0) {
                                                          self.selectedOptionsBlock(nil);
                                                      }
                                                      
                                                      NSMutableArray *selectedObjects= [[NSMutableArray alloc] initWithCapacity:selectedIndicesIndexPath.count];
                                                      
                                                      for (NSIndexPath *idxPath in selectedIndicesIndexPath) {
                                                          
                                                          if (idxPath.row > self.array.count) {
                                                              [NSException raise:@"Selected object index cannot be more than option count" format:@"Selected index %ld Option count %lu", (long)idxPath.row , (unsigned long)self.array.count];
                                                          }
                                                          
                                                          [selectedObjects addObject:self.array[idxPath.row]];
                                                      }
                                                      
                                                      self.selectedOptionsBlock(selectedObjects);
                                                  }
                                              }];
        }
        
    }
    
    return self;
}

- (instancetype) initMultiSelectWithDataSource: (id<UITableViewDataSource>) dataSource
                                     withTitle: (NSString *) title
                                andDescription: (NSString *) description
                          selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock
                                selectionLimit: (NSInteger) selectionLimit{
	
	self = [super init];
	
	if (self) {
		_selectedOptionsBlock = selectedOptionsBlock;
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.dataSource  = dataSource;
		_tableView.delegate = self;
		_tableView.allowsSelection = YES;
		_tableView.showsVerticalScrollIndicator = NO;

        _selectionLimit = ((selectionLimit < 0) ? 0:selectionLimit);
        
        [_tableView reloadData];
        
        if (!_alertView) {
            
            __weak __typeof__(self) weakSelf = self;
            
            _alertView = [[ITSCoreAlertView alloc] initWithTitle: title
                                                        subtitle: description
                                                     headerImage: nil
                                                       tableView: _tableView
                                                    buttonTitles:@[@"Cancel",@"Done"]
                                             negativeButtonIndex:-1
                                             positiveButtonIndex:-1
                                                          hidden:^{
                                                              // Clean up
                                                              [weakSelf cleanUp];
                                                          }
                          
                                              buttonPressedBlock:^(NSInteger buttonIndex) {
                                                  
                                                  if (buttonIndex == 1) {
                                                      
                                                      NSArray *selectedIndicesIndexPath = [self.selectedOptionsSet allObjects];
                                                      
                                                      if (!selectedIndicesIndexPath || selectedIndicesIndexPath.count == 0) {
                                                          self.selectedOptionsBlock(nil);
                                                      }
                                                      
                                                      NSMutableArray *selectedObjects= [[NSMutableArray alloc] initWithCapacity:selectedIndicesIndexPath.count];
                                                      
                                                      for (NSIndexPath *idxPath in selectedIndicesIndexPath) {
                                                          
                                                          if (idxPath.row > self.array.count) {
                                                              [NSException raise:@"Selected object index cannot be more than option count" format:@"Selected index %ld Option count %lu", (long)idxPath.row , (unsigned long)self.array.count];
                                                          }
                                                          
                                                          [selectedObjects addObject:self.array[idxPath.row]];
                                                      }
                                                      
                                                      self.selectedOptionsBlock(selectedObjects);
                                                  }
                                              }];
        }
	}
	
	return self;
}

// Simple Notification alert having title, message and okay button
- (instancetype) initNotificationAlertWithTitle:(NSString *) title andMessage:(NSString *) message buttonTitle: (NSString *)buttonTitle buttonBlock: (ButtonClickBlock) buttonPressedBlock {

    self = [super init];
    
    if (self) {
        __weak __typeof__(self) weakSelf = self;
        _alertView = [[ITSCoreAlertView alloc] initWithTitle:title
                                                    subtitle:message
                                                 headerImage:nil
                                                 description:nil
                                                buttonTitles:@[buttonTitle, @"asdf", @"zccf"]
                                         negativeButtonIndex:-1
                                         positiveButtonIndex:-1
                                                      hidden:^{
                                                          [weakSelf cleanUp];
                                                      } buttonPressedBlock:^(NSInteger buttonIndex) {
                                                          (!buttonPressedBlock)?:buttonPressedBlock();
                                                      }];
    }
    
    return self;
}

// Simple Permission alert having title, message and couple of buttons
- (instancetype) initSimpleAlertWithTitle:(NSString *) title andMessage:(NSString *) message positiveTitle: (NSString *)pt positiveBlock: (ButtonClickBlock) positiveBlock {
    self = [self initSimpleAlertWithTitle:title andMessage:message positiveTitle:title negativeTitle:@"Cancel" positiveBlock:positiveBlock negativeBlock:nil];
    return self;
}

- (instancetype) initSimpleAlertWithTitle:(NSString *) title andMessage:(NSString *) message positiveTitle: (NSString *)pt negativeTitle: (NSString *)nt positiveBlock: (ButtonClickBlock) positiveBlock negativeBlock: (ButtonClickBlock) negativeBlock {
    
    self = [super init];
    
    if (self) {
        __weak __typeof__(self) weakSelf = self;
        _alertView = [[ITSCoreAlertView alloc] initWithTitle:title
                                                    subtitle:message
                                                 headerImage:nil
                                                 description:nil
                                                buttonTitles:@[nt, pt]
                                         negativeButtonIndex:-1
                                         positiveButtonIndex:-1
                                                      hidden:^{
            [weakSelf cleanUp];
        } buttonPressedBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                // cancel called
                (!negativeBlock)?:negativeBlock();
            } else {
                // done called
                (!positiveBlock)?:positiveBlock();
            }
        }];
    }
    
    return self;
}

- (void) show {
    [self.alertView show];
}

- (void) cleanUp {
    _alertView = nil;
    _array = nil;
    _selectedOptionsSet = nil;
    _tableView = nil;
    _selectedOptionsBlock = nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.array.count < indexPath.row) {
		return nil;
	}
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    cell.textLabel.text = self.array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_selectedOptionsSet) {
        _selectedOptionsSet = [[NSMutableSet alloc] init];
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
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 48.0f;
}

@end
