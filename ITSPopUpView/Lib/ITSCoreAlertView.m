//
//  ITSCoreAlertView.m
//  ITSCoreAlertView
//

#import "ITSCoreAlertView.h"
#import "ITSAlertViewBrandingManager.h"
#import "ITSButton.h"

#define kPadding 24.0f

#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define isFaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define isFaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO

typedef NS_ENUM(NSUInteger, ITSAlertViewHeaderType) {
    ITSAlertViewHeaderTypeImageTitle = 1,
    ITSAlertViewHeaderTypeTitle = 2,
    ITSAlertViewHeaderTypeTitleSubtitle = 3,
    ITSAlertViewHeaderTypeImageTitleSubtitle = 4
};

@interface ITSCoreAlertView ()

// Main sections
@property(nonatomic, strong) UIView *buttonArea;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footerView;

@property(nonatomic, strong) NSArray *buttonTitles;
@property(nonatomic, strong) void (^buttonPressedBlock)(NSInteger btnIdx);
@property(nonatomic, copy) void (^hiddenCompletionBlock)(void);

@property(nonatomic, strong) NSString *headerTitle;
@property(nonatomic, strong) NSString *subTitle;
@property(nonatomic, strong) UILabel *headerTitleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) UIImage *headerImage;

@property(nonatomic, strong) NSString *bodyText;

@property(nonatomic, readonly) CGFloat alertViewWidth;
@property(nonatomic, readonly) CGFloat alertViewHeight;

@property(nonatomic, assign) ITSAlertViewHeaderType alertViewHeaderType;
@property(nonatomic, assign) NSInteger negativeButtonIndex;
@property(nonatomic, assign) NSInteger positiveButtonIndex;

@end

@implementation ITSCoreAlertView

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *) subtitle
                   headerImage: (UIImage *) headerImage
                   description: (NSString *) description
                  buttonTitles: (NSArray *) arrayOfButtonTitles
           negativeButtonIndex: (NSInteger) negativeButtonIndex
                 positiveButtonIndex: (NSInteger) positiveButtonIndex
                        hidden:(void (^)(void))hiddenCompletionBlock
            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock {
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {

        _headerTitle = title;
        _subTitle = subtitle;
        _headerImage = headerImage;
        _bodyText = description;
        _buttonTitles = [NSArray arrayWithArray:arrayOfButtonTitles];
        _negativeButtonIndex = negativeButtonIndex;
        _positiveButtonIndex = positiveButtonIndex;;
        _buttonPressedBlock = buttonPressedBlock;
        _alertViewHeaderType = ITSAlertViewHeaderTypeTitle;
        _hiddenCompletionBlock = hiddenCompletionBlock;
        
        if (headerImage && title) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeImageTitle;
        } else if (headerImage && title && subtitle) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeImageTitleSubtitle;
        } else if (title && subtitle) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeTitleSubtitle;
        }
        
        [self addSubview:[self headerView]];
        [self addSubview:[self footerView]];
        [self addSubview:[self contentView]];
        
        [self decorateView];
        
        [self layoutSubviews];
        
    }

    return self;
}

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *) subtitle
                   headerImage: (UIImage *) headerImage
                     tableView: (UITableView *) tableView
                  buttonTitles: (NSArray *) arrayOfButtonTitles
           negativeButtonIndex: (NSInteger) negativeButtonIndex
           positiveButtonIndex: (NSInteger) positiveButtonIndex
                        hidden: (void (^)(void))hiddenCompletionBlock
            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock {
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {

        _headerTitle = title;
        _subTitle = subtitle;
        _headerImage = headerImage;
        _tableView = tableView;
        _buttonTitles = [NSArray arrayWithArray:arrayOfButtonTitles];
        _negativeButtonIndex = negativeButtonIndex;
        _positiveButtonIndex = positiveButtonIndex;
        _buttonPressedBlock = buttonPressedBlock;
        _alertViewHeaderType = ITSAlertViewHeaderTypeTitle;
        _hiddenCompletionBlock = hiddenCompletionBlock;
        
        if (headerImage && title) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeImageTitle;
        } else if (headerImage && title && subtitle) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeImageTitleSubtitle;
        } else if (title && subtitle) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeTitleSubtitle;
        }
        
        [self addSubview:[self headerView]];
        [self addSubview:[self footerView]];
        [self addSubview:[self contentView]];
        
        [self decorateView];
        
        [self layoutSubviews];
    }
    
    return self;
}

- (CGFloat) permittedContentViewHeight {
	
	if (isLandscape) {
		return [ITSAlertViewBrandingManager sharedManager].landscapeHeight  - CGRectGetHeight([self headerView].frame) - CGRectGetHeight([self footerViewFrame]);
	} else {
		return [ITSAlertViewBrandingManager sharedManager].potraitHeight  - CGRectGetHeight([self headerView].frame) - CGRectGetHeight([self footerViewFrame]);
	}
}

- (CGRect) bodyViewFrame {
	
	CGFloat bodyViewFrameHeight = 0;
	
	if (isLandscape) {
		bodyViewFrameHeight = [ITSAlertViewBrandingManager sharedManager].landscapeHeight  - CGRectGetHeight([self headerView].frame) - CGRectGetHeight([self footerView].frame);
	} else {
		bodyViewFrameHeight = [ITSAlertViewBrandingManager sharedManager].potraitHeight  - CGRectGetHeight([self headerView].frame) - CGRectGetHeight([self footerView].frame);
	}
	
    if ([ITSAlertViewBrandingManager sharedManager].flexibleHeight) {
		bodyViewFrameHeight = (isLandscape? MIN([ITSAlertViewBrandingManager sharedManager].landscapeHeight, bodyViewFrameHeight): MIN([ITSAlertViewBrandingManager sharedManager].potraitHeight, bodyViewFrameHeight));
    }
    
    return CGRectMake(0, 0, self.alertViewWidth, bodyViewFrameHeight);
}

- (void) setHidden:(BOOL)h {
    
    __weak typeof(self) weakSelf = self;
    
    if (h && !self.isHidden) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [weakSelf.layer setOpacity:0.0f];
        } completion:^(BOOL finished) {
            
            [weakSelf removeFromSuperview];
            
            ((!weakSelf.hiddenCompletionBlock)? : weakSelf.hiddenCompletionBlock());
            
        }];
    }
}

- (void) decorateView {
    
    CGRect frame = CGRectMake(0, 0, self.alertViewWidth, self.alertViewHeight);
    self.frame = frame;
    
    if ([ITSAlertViewBrandingManager sharedManager].alertViewContentBackgroundType == ITSAlertViewContentBackgroundTypeSolid) {
        [self setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].contentBackgroundSolidColor];
    }
    
    // Configurable
    [self.layer setCornerRadius: [ITSAlertViewBrandingManager sharedManager].cornerRadius];
    [self.layer setMasksToBounds:YES];

    CGFloat alphaComponent = CGColorGetAlpha([ITSAlertViewBrandingManager sharedManager].backgroundOpacityColor.CGColor);
    
    if (alphaComponent < 0.1f) {
        // When the background color is too light, add a border to help user differentiate with background and notification view
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithWhite:0.9f alpha:1.0f].CGColor;
    }
}

- (void) addButtonsToView: (UIView *) view {
	
	if (nil == self.buttonTitles || self.buttonTitles.count <= 0) {
		return;
	}
	
	[[view subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *_Nonnull stop) {
		[obj removeFromSuperview];
	}];

	__block CGFloat perWidth = 0;
	
	int maxNumberOfButtonsInARow = -1;
	
	if (isLandscape) {
		maxNumberOfButtonsInARow = 3;
	} else {
		maxNumberOfButtonsInARow = 2;
	}
	
	if (self.buttonTitles.count <= maxNumberOfButtonsInARow) {
		perWidth = self.alertViewWidth / self.buttonTitles.count;
	} else {
		perWidth = self.alertViewWidth;
	}
	
	[self.buttonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
		
		if (nil == title || title.length <= 0) {
			return;
		}
		
		ITSButton *btn = nil;
		
		if (self.alertViewWidth == perWidth) {
			btn = [self buttonWithTitle:title width:perWidth xPos:0 yPos:idx * 44.0f negativeButton: (idx == self.negativeButtonIndex) positiveButton: (idx == self.positiveButtonIndex)];
			
			UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame) - 0.5f, CGRectGetWidth(btn.frame), 0.5f)];
			line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
			[view addSubview:line];
			
		} else {
			btn = [self buttonWithTitle:title width:(perWidth - 0.5f) xPos:idx * (perWidth + 0.5f) yPos:0 negativeButton: (idx == self.negativeButtonIndex) positiveButton: (idx == self.positiveButtonIndex)];
			
			if (idx != self.buttonTitles.count - 1) {
				UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+0.5f, CGRectGetMinY(btn.frame), 0.5f, CGRectGetHeight(btn.frame))];
				seperator.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
				[view addSubview:seperator];
			}
		}
        
        btn.backgroundColor = [UIColor clearColor];
		
        [btn setTag:idx];
		[btn addTarget:self action:@selector(pressedOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
		[view addSubview:btn];
		
	}];
	
	if (self.alertViewWidth != perWidth) {
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertViewWidth, 0.5f)];
		line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
		[view addSubview:line];
	}
}

- (void)pressedOnTitleButton:(UIButton *)sender {
	
	if (self.buttonPressedBlock) {
		self.buttonPressedBlock(sender.tag);
	}
    
    self.hidden = YES;
}

- (ITSButton *) buttonWithTitle:(NSString *)title width:(CGFloat)width xPos:(CGFloat)xPos yPos:(CGFloat)yPos negativeButton: (BOOL) negative positiveButton: (BOOL) positive {
	
	ITSButton *button = [[ITSButton alloc] initWithFrame:CGRectMake(xPos, yPos, width, 44.0f) negative:negative positive:positive];
	[button setTitle:title forState:UIControlStateNormal];
	
	return button;
}

- (UILabel *) headerTitleLabel {
	
	if (!_headerTitleLabel) {
		_headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.alertViewWidth - (2 * kPadding), 56.0f)];
        _headerTitleLabel.numberOfLines = 3;
        _headerTitleLabel.font = [ITSAlertViewBrandingManager sharedManager].titleFont;
		[_headerTitleLabel setTextColor:[ITSAlertViewBrandingManager sharedManager].headerTitleColor];
		[_headerTitleLabel setTextAlignment:[ITSAlertViewBrandingManager sharedManager].headerTitleTextAlignment];
        _headerTitleLabel.text = _headerTitle;
        [_headerTitleLabel sizeToFit];
	}
	
	return _headerTitleLabel;
}

- (UILabel *) subTitleLabel {
    
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, self.alertViewWidth - (2 * kPadding), 56.0f)];
        _subTitleLabel.numberOfLines = 3;
        [_subTitleLabel setTextColor:[ITSAlertViewBrandingManager sharedManager].headerSubTitleColor];
        _subTitleLabel.font = [ITSAlertViewBrandingManager sharedManager].subTitleFont;
        [_subTitleLabel setTextAlignment:[ITSAlertViewBrandingManager sharedManager].headerSubTitleTextAlignment];
        _subTitleLabel.text = _subTitle;
        [_subTitleLabel sizeToFit];
    }
    
    return _subTitleLabel;
}

- (CGRect) horizontalSeperatorLineFrame {
    return CGRectMake(0, 0, self.alertViewWidth, 0.5f);
}

- (CGRect) footerViewFrame {
    
    NSInteger numberOfButtonLayers = 1;
	
	if (isLandscape) {
        numberOfButtonLayers = ((self.buttonTitles.count > 3)? self.buttonTitles.count: ((self.buttonTitles.count == 0)?0:numberOfButtonLayers));
	} else {
		numberOfButtonLayers = ((self.buttonTitles.count > 2)? self.buttonTitles.count: ((self.buttonTitles.count == 0)?0:numberOfButtonLayers));
	}
    
    return CGRectMake(0, 0 , self.alertViewWidth, ((numberOfButtonLayers == 0)? 10.0f:(44.5f * numberOfButtonLayers)));
}

- (UIView *) footerView {
    
    self.buttonArea.frame = CGRectOffset(self.buttonArea.frame, 0, self.alertViewHeight - CGRectGetHeight([self footerViewFrame]));
    
    return self.buttonArea;
}

- (UIView *) buttonArea {
	
	if (_buttonArea == nil) {
				
		_buttonArea = [[UIView alloc] initWithFrame: [self footerViewFrame]];
        _buttonArea.backgroundColor = [UIColor clearColor];
        
        [self addButtonsToView:_buttonArea];
	}

	return _buttonArea;
}

- (UIView *) headerView {
    
    if (_headerView == nil) {
        
        CGFloat height = 0;
        
        if (self.alertViewHeaderType == ITSAlertViewHeaderTypeTitle) {
            
            height = CGRectGetHeight(self.headerTitleLabel.frame) + CGRectGetHeight(self.horizontalSeperatorLineFrame) + (2 * kPadding);
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertViewWidth, height)];
            
            // Adjust the frame of the titles based on the alignment
            self.headerTitleLabel.frame = [self titleFrame:self.headerTitleLabel.frame alignment:[ITSAlertViewBrandingManager sharedManager].headerTitleTextAlignment dy:0];
            
            // Adding all the views
            [_headerView addSubview:self.headerTitleLabel];
            
        } else if (self.alertViewHeaderType == ITSAlertViewHeaderTypeTitleSubtitle) {
            
            height = CGRectGetHeight(self.headerTitleLabel.frame) + CGRectGetHeight(self.subTitleLabel.frame) + CGRectGetHeight(self.horizontalSeperatorLineFrame) + (2.5f * kPadding);
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertViewWidth, height)];
            
            // Adjust the frame of the titles based on the alignment
            self.headerTitleLabel.frame = [self titleFrame:self.headerTitleLabel.frame alignment:[ITSAlertViewBrandingManager sharedManager].headerTitleTextAlignment dy:0];
            self.subTitleLabel.frame = [self titleFrame:self.subTitleLabel.frame alignment:[ITSAlertViewBrandingManager sharedManager].headerSubTitleTextAlignment dy:CGRectGetMaxY(self.headerTitleLabel.frame) + (0.5f * kPadding)];
            
            // Adding all the views
            [_headerView addSubview:self.headerTitleLabel];
            [_headerView addSubview:self.subTitleLabel];
            
        } else if (self.alertViewHeaderType == ITSAlertViewHeaderTypeImageTitleSubtitle) {
            
        } else if (self.alertViewHeaderType == ITSAlertViewHeaderTypeImageTitle) {
            
        }
		
		_headerView.backgroundColor = [ITSAlertViewBrandingManager sharedManager].headerBackgroundColor;
		
        [_headerView addSubview:[self seperatorLineWithFrame: CGRectOffset(self.horizontalSeperatorLineFrame, 0, height)]];
    }
    
    return _headerView;
}

- (CGRect) titleFrame: (CGRect) frame alignment:(NSTextAlignment) textAlignment dy: (CGFloat) dy {
    
    if ([ITSAlertViewBrandingManager sharedManager].headerSubTitleTextAlignment == NSTextAlignmentCenter) {
        return CGRectOffset(frame, (self.alertViewWidth/2 - CGRectGetMidX(frame)), dy);
    } else if ([ITSAlertViewBrandingManager sharedManager].headerSubTitleTextAlignment == NSTextAlignmentLeft) {
        return CGRectOffset(frame, 0, dy);
    } else {
        return CGRectOffset(frame, self.alertViewWidth - (2*kPadding) - CGRectGetWidth(frame), dy);
    }
}

- (UIView *) contentView {
    
    if ((_contentView && [_contentView isKindOfClass:[UILabel class]]) ||
        ( _contentView && CGRectGetMinX(_contentView.frame) == (kPadding +CGRectGetMaxY([self headerView].frame)))) {
        return _contentView;
    } else if (_contentView ) {
        return _contentView;
    }
    
    if (_contentView) {
        NSLog(@".... %f %f", CGRectGetMinY(_contentView.frame),CGRectGetMaxY([self headerView].frame));
    }
    
    CGRect contentViewFrame = CGRectMake(0, 0, self.alertViewWidth, [self permittedContentViewHeight]);
    
    if (self.bodyText) {
        
        UILabel *bodyTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.alertViewWidth - (2*kPadding), 20.0f)];
        bodyTextLabel.font = [ITSAlertViewBrandingManager sharedManager].bodyFont;
        bodyTextLabel.text = _bodyText;
        [bodyTextLabel sizeToFit];
        
        if ([self permittedContentViewHeight] < (CGRectGetHeight(bodyTextLabel.frame) + (2 * kPadding) )) {
            contentViewFrame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), self.alertViewWidth, [self permittedContentViewHeight]);
        } else {
            contentViewFrame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), self.alertViewWidth, CGRectGetHeight(bodyTextLabel.frame) + (2 * kPadding));
        }
        
        _contentView = [[UIView alloc] initWithFrame:contentViewFrame];
		
        [_contentView addSubview: bodyTextLabel];
        
    } else if (self.tableView) {
        
        CGFloat contentHeight = self.tableView.contentSize.height;
        
        if ([self permittedContentViewHeight] < contentHeight) {
            
            // Content of the screen is more than permitted height, restrict the view height and make the content scrollable if possible
            contentViewFrame = CGRectMake(0, CGRectGetHeight([self headerView].frame), self.alertViewWidth, [self permittedContentViewHeight]);
            
            self.tableView.scrollEnabled = YES;

        } else {
            
            contentViewFrame = CGRectMake(0, CGRectGetHeight([self headerView].frame), self.alertViewWidth, contentHeight);
            
            self.tableView.scrollEnabled = NO;
        }
        
        self.tableView.frame = CGRectMake(0, 0.5f, self.alertViewWidth, CGRectGetHeight(contentViewFrame) - 0.5f );
        
        _contentView = [[UIView alloc] initWithFrame:contentViewFrame];
		_tableView.opaque = YES;
		
        [_contentView addSubview:_tableView];
    }
    
    return _contentView;
}

- (UIView *) seperatorLineWithFrame : (CGRect) frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
    return view;
}

- (CGFloat) alertViewWidth {
	
	if (isLandscape) {
    	return [ITSAlertViewBrandingManager sharedManager].landscapeWidth;
	} else {
		return [ITSAlertViewBrandingManager sharedManager].potraitWidth;
	}
}

- (CGFloat) alertViewHeight {
    return CGRectGetHeight([self headerView].frame) + CGRectGetHeight([self contentView].frame) + CGRectGetHeight([self footerViewFrame]);
}

- (void) layoutSubviews {
	[super layoutSubviews];
}

@end
