//
//  ITSAlertView.m
//  ITSAlertView
//

#import "ITSAlertView.h"
#import "ITSAlertViewBrandingManager.h"
#import "ITSButton.h"

#define kPadding 25.0f

@interface ITSAlertView ()

@property(nonatomic, strong) UIView *popContentView;
@property(nonatomic, weak) UIView *parentView;
@property(nonatomic, assign) BOOL backgroundBlur;
@property(nonatomic, assign) ITSAlertViewContentBackgroundType alertViewContentBackgroundType;
@property(nonatomic, strong) UIView *buttonArea;
@property(nonatomic, strong) NSArray *buttonTitles;
@property(nonatomic, copy) void (^buttonPressedBlock)(NSInteger btnIdx);
@property(nonatomic, strong) NSString *headTitle;
@property(nonatomic, strong) UILabel *headTitleLbl;

@end

@implementation ITSAlertView

+ (instancetype) initWithTitle: (NSString *) title
				   description: (NSString *) description
				  buttonTitles: (NSArray *) arrayOfButtonTitles
		   negativeButtonIndex: (NSInteger) negativeButtonIndex
			buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
				  attachToView: (UIView *) view
	alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType {
	

	view = (nil == view) ? [UIApplication sharedApplication].keyWindow : view;
	
	ITSAlertView *popUpView = [[ITSAlertView alloc] initPopUpViewInView:view alertContentBackgroundType:alertViewContentBackgroundType];
	
	[popUpView addButtonWithTitles: arrayOfButtonTitles negativeButtonIndex: negativeButtonIndex];
	
	[popUpView setHeadTitle:title];
	
	[popUpView setButtonPressedBlock:buttonPressedBlock];
	
	[view addSubview:popUpView];
	 
	return popUpView;
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
	
	[self.popContentView.layer setOpacity:0.0f];
	
	
	[UIView animateWithDuration:0.2f animations:^{
		[self.layer setOpacity:1.0f];
		[self.popContentView.layer setOpacity:1.0f];
	} completion: nil];
}

- (void) hide {
	
	[UIView animateWithDuration:0.1f animations:^{
		[self.layer setOpacity:0.0f];
	}                completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
	
}

- (UIView *) popContentView {
	
	if (nil == _popContentView) {
		
		CGFloat xPos = ((nil != self.parentView) ? CGRectGetWidth(self.parentView.bounds) / 2 : 0) - [ITSAlertViewBrandingManager sharedManager].width / 2;
		CGFloat yPos = ((nil != self.parentView) ? CGRectGetHeight(self.parentView.bounds) / 2 : 0) - [ITSAlertViewBrandingManager sharedManager].height / 2;
		
		UIView *view = nil;
		CGRect frame = CGRectMake(xPos, yPos, [ITSAlertViewBrandingManager sharedManager].width, [ITSAlertViewBrandingManager sharedManager].height);
		
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
		
		_popContentView = view;
		
		view = nil;
	}
	
	return _popContentView;
}

#pragma mark - Background Gesture
- (void)tappedOnBackground:(UITapGestureRecognizer *)tapGesture {
	
	CGPoint location = [tapGesture locationInView:self];
	
	if (CGRectContainsPoint(self.popContentView.frame, location)) {
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
	
	[self addSubview:self.popContentView];
	
	if ([ITSAlertViewBrandingManager sharedManager].dismissOnTapOutside) {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnBackground:)];
		[self addGestureRecognizer:tapGesture];
	}
}

- (void) addButtonWithTitles:(NSArray *)titles negativeButtonIndex: (NSInteger) negativeButtonIndex {
	
	if (_buttonTitles == nil) {
		_buttonTitles = [NSArray arrayWithArray:titles];
	}
	
	if (nil == self.buttonTitles || self.buttonTitles.count <= 0) {
		return;
	}
	
	[[self.buttonArea subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *_Nonnull stop) {
		[obj removeFromSuperview];
	}];

	__block CGFloat perWidth = 0;
	
	if (self.buttonTitles.count <= 2) {
		perWidth = CGRectGetWidth(self.popContentView.frame) / self.buttonTitles.count;
	} else {
		perWidth = CGRectGetWidth(self.popContentView.frame);
	}
	
	[self.buttonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
		
		if (nil == title || title.length <= 0) {
			return;
		}
		
		ITSButton *btn = nil;
		
		if (CGRectGetWidth(self.popContentView.frame) == perWidth) {
			btn = [self buttonWithTitle:title width:perWidth xPos:0 yPos:idx * 44.0f negativeButton: (idx == negativeButtonIndex) ];
			
			UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame) - 0.5f, CGRectGetWidth(btn.frame), 0.5f)];
			line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
			[self.buttonArea addSubview:line];
			
		} else {
			btn = [self buttonWithTitle:title width:(perWidth - 0.5f) xPos:idx * (perWidth + 0.5f) yPos:0 negativeButton: (idx == negativeButtonIndex) ];
			
			if (idx != self.buttonTitles.count - 1) {
				UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+0.5f, CGRectGetMinY(btn.frame), 0.5f, CGRectGetHeight(btn.frame))];
				seperator.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
				[self.buttonArea addSubview:seperator];
			}
		}
		
		[btn setTag:idx + 233];
		[btn addTarget:self action:@selector(pressedOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonArea addSubview:btn];
		
	}];
	
	if (CGRectGetWidth(self.popContentView.frame) != perWidth) {
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.popContentView.frame), 0.5f)];
		line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
		[self.buttonArea addSubview:line];
	}
	
	if (nil == [self.buttonArea superview]) {
		[self.popContentView addSubview:self.buttonArea];
	}
	
	[self layoutSubviews];
	
}

- (void)pressedOnTitleButton:(UIButton *)sender {
	
	NSInteger idx = sender.tag - 233;
	
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

- (void)setHeadTitle:(NSString *)headTitle {
	
	_headTitle = headTitle;
	
	[self.headTitleLbl setText:headTitle];
	
	if (nil == [self.headTitleLbl superview]) {
		
		[self.popContentView addSubview:self.headTitleLbl];
		
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headTitleLbl.frame) + 0.5f + kPadding, CGRectGetWidth(self.popContentView.frame), 0.5f)];
		line.backgroundColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
		[self.popContentView addSubview:line];
	}
	
	[self layoutSubviews];
}

- (UILabel *)headTitleLbl {
	
	if (nil == _headTitleLbl) {
		_headTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.popContentView.frame.size.width - 2 * kPadding, 20.0f)];
		[_headTitleLbl setTextColor:[UIColor darkTextColor]];
		[_headTitleLbl setFont:[UIFont systemFontOfSize:20.0f]];
		[_headTitleLbl setTextAlignment:NSTextAlignmentCenter];
	}
	
	return _headTitleLbl;
}

- (UIView *)buttonArea {
	
	if (_buttonArea == nil) {
		
		NSInteger numberOfButtonLayers = 1;
		
		if (self.buttonTitles.count > 2) {
			numberOfButtonLayers = self.buttonTitles.count;
		}
		
		if (numberOfButtonLayers > 1) {
			_buttonArea = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.popContentView.frame) - (44.5f * numberOfButtonLayers) , CGRectGetWidth(self.popContentView.frame), (44.5f * numberOfButtonLayers))];
		} else {
			_buttonArea = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.popContentView.frame) - 44.0f , CGRectGetWidth(self.popContentView.frame), 44.5f)];
		}
	}
	
	return _buttonArea;
}

@end
