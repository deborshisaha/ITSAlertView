//
//  ITSAlertView.m
//  ITSAlertView
//

#import "ITSAlertView.h"
#import "ITSAlertViewBrandingManager.h"
#import "ITSButton.h"

#define kPadding 24.0f

typedef NS_ENUM(NSUInteger, ITSAlertViewHeaderType) {
    ITSAlertViewHeaderTypeImageTitle = 1,
    ITSAlertViewHeaderTypeTitle = 2,
    ITSAlertViewHeaderTypeTitleSubtitle = 3,
    ITSAlertViewHeaderTypeImageTitleSubtitle = 4
};

@interface ITSAlertView ()

@property(nonatomic, strong) UIView *alertContentView;
@property(nonatomic, weak) UIView *parentView;
@property(nonatomic, assign) BOOL backgroundBlur;
@property(nonatomic, assign) ITSAlertViewContentBackgroundType alertViewContentBackgroundType;

// Main sections
@property(nonatomic, strong) UIView *buttonArea;

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *embeddedContentView;
@property(nonatomic, strong) UIView *footerView;

@property(nonatomic, strong) NSArray *buttonTitles;
@property(nonatomic, copy) void (^buttonPressedBlock)(NSInteger btnIdx);

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

@end

@implementation ITSAlertView

//+ (instancetype) initWithTitle: (NSString *) title
//				   description: (NSString *) description
//				  buttonTitles: (NSArray *) arrayOfButtonTitles
//		   negativeButtonIndex: (NSInteger) negativeButtonIndex
//			buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
//				  attachToView: (UIView *) view
//	alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType {
//	
//
//	view = (nil == view) ? [UIApplication sharedApplication].keyWindow : view;
//	
//	ITSAlertView *popUpView = [[ITSAlertView alloc] initPopUpViewInView:view alertContentBackgroundType:alertViewContentBackgroundType];
//	
//	[popUpView addButtonWithTitles: arrayOfButtonTitles negativeButtonIndex: negativeButtonIndex];
//	
//	[popUpView setHeaderTitle:title];
//	
//	[popUpView setButtonPressedBlock:buttonPressedBlock];
//	
//	[view addSubview:popUpView];
//	 
//	return popUpView;
//}

//+ (instancetype) initWithTitle: (NSString *) title
//                   headerImage: (UIImage *) headerImage
//                   description: (NSString *) description
//                  buttonTitles: (NSArray *) arrayOfButtonTitles
//           negativeButtonIndex: (NSInteger) negativeButtonIndex
//            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
//                  attachToView: (UIView *) view
//    alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType {
//    
//    view = (nil == view) ? [UIApplication sharedApplication].keyWindow : view;
//    
//    ITSAlertView *alertView = [[ITSAlertView alloc] initWithTitle:title subtitle:@"This is good" headerImage:headerImage description:description buttonTitles:arrayOfButtonTitles negativeButtonIndex:negativeButtonIndex buttonPressedBlock:buttonPressedBlock attachToView: view alertContentBackgroundType:alertViewContentBackgroundType];
//    
//    // [view addSubview:alertView];
//    
//    return alertView;
//}

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *) subtitle
                   headerImage: (UIImage *) headerImage
                   description: (NSString *) description
                  buttonTitles: (NSArray *) arrayOfButtonTitles
           negativeButtonIndex: (NSInteger) negativeButtonIndex
            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
                  attachToView: (UIView *) view
    alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType {
    
    view = (nil == view) ? [UIApplication sharedApplication].keyWindow : view;
    
    self = [super initWithFrame:view.bounds];
    
    if (self) {
        _parentView = view;
        _headerTitle = title;
        _subTitle = subtitle;
        _headerImage = headerImage;
        _bodyText = description;
        _buttonTitles = [NSArray arrayWithArray:arrayOfButtonTitles];
        _negativeButtonIndex = negativeButtonIndex;
        _buttonPressedBlock = buttonPressedBlock;
        _alertViewContentBackgroundType = alertViewContentBackgroundType;
        _alertViewHeaderType = ITSAlertViewHeaderTypeTitle;
        
        if (headerImage && title) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeImageTitle;
        } else if (headerImage && title && subtitle) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeImageTitleSubtitle;
        } else if (title && subtitle) {
            _alertViewHeaderType = ITSAlertViewHeaderTypeTitleSubtitle;
        }
        
        [self constructView];
        
        [self.alertContentView addSubview:[self headerView]];
        [self.alertContentView addSubview:[self contentView]];
        [self.alertContentView addSubview:[self footerView]];
        
        [self layoutSubviews];
        
        self.alertContentView.frame = CGRectOffset(self.alertContentView.frame, 0, CGRectGetMidY(self.alertContentView.frame) - CGRectGetMidY(_parentView.frame)/2);
    }

    return self;
}

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *) subtitle
                   headerImage: (UIImage *) headerImage
           embeddedContentView: (UIView *) embeddedContentView
                  buttonTitles: (NSArray *) arrayOfButtonTitles
           negativeButtonIndex: (NSInteger) negativeButtonIndex
            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
                  attachToView: (UIView *) view
    alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType {
    
    return self;
}

- (CGFloat) permittedContentViewHeight {
    return [ITSAlertViewBrandingManager sharedManager].height  - CGRectGetHeight(self.headerView.frame) - CGRectGetHeight(self.buttonArea.frame);
}

- (CGRect) bodyViewFrame {
    
    CGFloat bodyViewFrameHeight = [ITSAlertViewBrandingManager sharedManager].height  - CGRectGetHeight(self.headerView.frame) - CGRectGetHeight(self.buttonArea.frame);
    
    if ([ITSAlertViewBrandingManager sharedManager].flexibleHeight) {
        // if flexible height, respect only maximumHeight
        bodyViewFrameHeight = MIN([ITSAlertViewBrandingManager sharedManager].height, bodyViewFrameHeight);
    }
    
    return CGRectMake(0, 0, self.alertViewWidth, bodyViewFrameHeight);
}

- (instancetype) initPopUpViewInView:(UIView *)view
		  alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType
{
	
	self.parentView = view;
	self.alertViewContentBackgroundType = alertViewContentBackgroundType;
	
	self = [super initWithFrame:view.bounds];
	if (self) {
		[self constructView];
	}
	return self;
}

- (void) show {
	
	if (nil == self.parentView) {
		return;
	}
	
	if (nil == [self superview]) {
		[self.parentView addSubview:self];
	}
	
	[self.layer setOpacity:0.0f];
	
	[self.alertContentView.layer setOpacity:0.0f];
	
	[UIView animateWithDuration:0.2f animations:^{
		[self.layer setOpacity:1.0f];
		[self.alertContentView.layer setOpacity:1.0f];
	} completion: nil];
}

- (void) hide {
	
	[UIView animateWithDuration:0.1f animations:^{
		[self.layer setOpacity:0.0f];
	}                completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
	
}

- (UIView *) alertContentView {
	
	if (nil == _alertContentView) {
		
		CGFloat xPos = ((nil != self.parentView) ? CGRectGetWidth(self.parentView.bounds) / 2 : 0) - [ITSAlertViewBrandingManager sharedManager].width / 2;
		CGFloat yPos = ((nil != self.parentView) ? CGRectGetHeight(self.parentView.bounds) / 2 : 0) - [ITSAlertViewBrandingManager sharedManager].height / 2;
		
		UIView *view = nil;
		CGRect frame = CGRectMake(xPos, yPos, self.alertViewWidth, self.alertViewHeight);
		
        NSLog(@"frame : %@", NSStringFromCGRect(frame));
        
		if (self.alertViewContentBackgroundType == ITSAlertViewContentBackgroundTypeSolid) {
			
			view = [[UIView alloc] initWithFrame:frame];
			[view setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].contentBackgroundSolidColor];
			
		} else if (self.alertViewContentBackgroundType == ITSAlertViewContentBackgroundTypeBlur) {
			
			UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
			blurView.frame = frame;
			blurView.tintColor = [ITSAlertViewBrandingManager sharedManager].contentBackgroundGlossyTintColor;
			
			view = blurView;
		}
		
		// Configurable
		[view.layer setCornerRadius: [ITSAlertViewBrandingManager sharedManager].cornerRadius];
		[view.layer setMasksToBounds:YES];
		
		_alertContentView = view;
		
		view = nil;
	}
    
	return _alertContentView;
}

#pragma mark - Background Gesture
- (void)tappedOnBackground:(UITapGestureRecognizer *)tapGesture {
	
	CGPoint location = [tapGesture locationInView:self];
	
	if (CGRectContainsPoint(self.alertContentView.frame, location)) {
		return;
	}
	
	[self hide];
}

- (void) setBackgroundBlur:(BOOL)backgroundBlur {
	
	_backgroundBlur = backgroundBlur;
	
	if (_backgroundBlur) {
		//structure view
//		UIGraphicsBeginImageContext(self.parentView.frame.size);
//		CGContextRef context = UIGraphicsGetCurrentContext();
//		[self.parentView.layer renderInContext:context];
//		UIImage *clipImg = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//		
//		
//		UIColor *tintColor = [UIColor colorWithWhite:0.10 alpha:0.3];
//		
//		UIImage *blurImg = [UIImageEffects imageByApplyingBlurToImage:clipImg withRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
//		
//		UIImageView *bgImgView = [[UIImageView alloc] initWithImage:blurImg];
//		
//		[self addSubview:bgImgView];
	} else {
		self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].backgroundOpacityColor;
	}
}

- (void) constructView {
	
	// Load from pop up view configuration manager
	self.backgroundBlur = NO;
	
	[self addSubview:self.alertContentView];
	
	if ([ITSAlertViewBrandingManager sharedManager].dismissOnTapOutside) {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnBackground:)];
		[self addGestureRecognizer:tapGesture];
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
	
	if (self.buttonTitles.count <= 2) {
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
			btn = [self buttonWithTitle:title width:perWidth xPos:0 yPos:idx * 44.0f negativeButton: (idx == self.negativeButtonIndex) ];
			
			UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame) - 0.5f, CGRectGetWidth(btn.frame), 0.5f)];
			line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
			[view addSubview:line];
			
		} else {
			btn = [self buttonWithTitle:title width:(perWidth - 0.5f) xPos:idx * (perWidth + 0.5f) yPos:0 negativeButton: (idx == self.negativeButtonIndex) ];
			
			if (idx != self.buttonTitles.count - 1) {
				UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+0.5f, CGRectGetMinY(btn.frame), 0.5f, CGRectGetHeight(btn.frame))];
				seperator.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
				[view addSubview:seperator];
			}
		}
		
		[btn setTag:idx + 233];
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
	[self hide];
}

- (ITSButton *) buttonWithTitle:(NSString *)title width:(CGFloat)width xPos:(CGFloat)xPos yPos:(CGFloat)yPos negativeButton: (BOOL) negative {
	
	ITSButton *button = [[ITSButton alloc] initWithFrame:CGRectMake(xPos, yPos, width, 44.0f) negative:negative];
	
	if (negative) {
		[button setTitleColor:[ITSAlertViewBrandingManager sharedManager].buttonNegativeTitleColor forState:UIControlStateNormal];
		[button setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].buttonNegativeBackgroundColor];
		
		if ([ITSAlertViewBrandingManager sharedManager].buttonNegativeBold) {
			// Bold
			[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		} else {
			[button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
		}
		
	} else {
		[button setTitleColor:[ITSAlertViewBrandingManager sharedManager].buttonDefaultTitleColor forState:UIControlStateNormal];
		[button setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].buttonDefaultBackgroundColor];
		
		if ([ITSAlertViewBrandingManager sharedManager].buttonDefaultBold) {
			// Bold
			[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		} else {
			[button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
		}
	}
	
	[button setTitle:title forState:UIControlStateNormal];
	
	return button;
}

//- (void)setHeaderTitle:(NSString *)headerTitle {
//	
//	_headerTitle = headerTitle;
//	
//	[self.headerTitleLabel setText:headerTitle];
//	
//	if (nil == [self.headerTitleLabel superview]) {
//		
//		[self.popContentView addSubview:self.headerTitleLabel];
//		
//		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerTitleLabel.frame) + 0.5f + kPadding, self.alertViewWidth, 0.5f)];
//		line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
//		[self.popContentView addSubview:line];
//	}
//	
//	[self layoutSubviews];
//}

- (UILabel *) headerTitleLabel {
	
	if (!_headerTitleLabel) {
		_headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.alertViewWidth - (2 * kPadding), 56.0f)];
        _headerTitleLabel.numberOfLines = 3;
		[_headerTitleLabel setTextColor:[UIColor darkTextColor]];
		[_headerTitleLabel setFont:[UIFont systemFontOfSize:20.0f]];
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
        [_subTitleLabel setTextColor:[UIColor darkTextColor]];
        [_subTitleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_subTitleLabel setTextAlignment:[ITSAlertViewBrandingManager sharedManager].headerSubTitleTextAlignment];
        _subTitleLabel.text = _subTitle;
        [_subTitleLabel sizeToFit];
    }
    
    return _subTitleLabel;
}

//- (UIView *) horizontalSeperatorLine {
//    
//    if (!_horizontalSeperatorLine) {
//        _horizontalSeperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.alertViewWidth, 0.5f)];
//        _horizontalSeperatorLine.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
//    }
//    
//    return _horizontalSeperatorLine;
//}

- (CGRect) horizontalSeperatorLineFrame {
    return CGRectMake(0, 0, self.alertViewWidth, 0.5f);
}

- (CGRect) footerViewFrame {
    
    NSInteger numberOfButtonLayers = 1;
    
    if (self.buttonTitles.count > 2) {
        numberOfButtonLayers = self.buttonTitles.count;
    }
    
    return CGRectMake(0, 0 , self.alertViewWidth, (44.5f * numberOfButtonLayers));
}

- (UIView *) footerView {
    
    self.buttonArea.frame = CGRectOffset(self.buttonArea.frame, 0, self.alertViewHeight - CGRectGetHeight(self.buttonArea.frame));
    return self.buttonArea;
}

- (UIView *) buttonArea {
	
	if (_buttonArea == nil) {
		
		NSInteger numberOfButtonLayers = 1;
		
		if (self.buttonTitles.count > 2) {
			numberOfButtonLayers = self.buttonTitles.count;
		}
		
		_buttonArea = [[UIView alloc] initWithFrame: [self footerViewFrame]];
        
        [self addButtonsToView:_buttonArea];
	}
    _buttonArea.backgroundColor = [UIColor yellowColor];
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
    } else if (_contentView && CGRectGetMinY(_contentView.frame) != CGRectGetMaxY([self headerView].frame)) {
        _contentView.frame = CGRectOffset(_contentView.frame, 0, CGRectGetMaxY([self headerView].frame));
    }
    
    if (self.bodyText) {
        
        CGRect contentViewFrame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), self.alertViewWidth, [self permittedContentViewHeight]);
        
        UILabel *bodyTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.alertViewWidth - (2*kPadding), 20.0f)];
        bodyTextLabel.text = _bodyText;
        [bodyTextLabel sizeToFit];
        
        if ([self permittedContentViewHeight] < (CGRectGetHeight(bodyTextLabel.frame) + (2 * kPadding) )) {
            contentViewFrame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), self.alertViewWidth, [self permittedContentViewHeight]);
        } else {
            contentViewFrame = CGRectMake(0, CGRectGetHeight(self.headerView.frame), self.alertViewWidth, CGRectGetHeight(bodyTextLabel.frame) + (2 * kPadding));
        }
        
        _contentView = [[UIView alloc] initWithFrame:contentViewFrame];
        _contentView.backgroundColor = [UIColor greenColor];
        [_contentView addSubview: bodyTextLabel];
        
    }
    
    return _contentView;
}

- (UIView *) seperatorLineWithFrame : (CGRect) frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
    return view;
}

- (CGFloat) alertViewWidth {
    return [ITSAlertViewBrandingManager sharedManager].width;
}

- (CGFloat) alertViewHeight {
    
    NSLog(@"())()(: %f", CGRectGetHeight([self contentView].frame) );
    return CGRectGetHeight(self.headerView.frame) + CGRectGetHeight([self contentView].frame) + CGRectGetHeight([self footerViewFrame]);
}

@end
