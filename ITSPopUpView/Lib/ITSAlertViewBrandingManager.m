//
//  ITSAlertViewBrandingManager.m
//  ITSAlertView
//

#import "ITSAlertViewBrandingManager.h"
#import "UIColor+ITSAlertView.h"

const CGFloat kMaximumWidth = 300.0f;
const CGFloat kMaximumHeight = 450.0f;
const CGFloat kCornerRadius = 10.0f;

static ITSAlertViewBrandingManager *alertViewBrandingManager = nil;
static NSDictionary *alertViewBrandingDictionary = nil;

@implementation ITSAlertViewBrandingManager
@synthesize width = _width;
@synthesize height = _height;
@synthesize cornerRadius = _cornerRadius;
@synthesize backgroundOpacityAlpha = _backgroundOpacityAlpha;
@synthesize backgroundOpacityColor = _backgroundOpacityColor;
@synthesize contentBackgroundGlossyTintColor = _contentBackgroundGlossyTintColor;
@synthesize contentBackgroundSolidColor = _contentBackgroundSolidColor;

@synthesize buttonDefaultBackgroundColor = _buttonDefaultBackgroundColor;
@synthesize buttonNegativeBackgroundColor = _buttonNegativeBackgroundColor;
@synthesize buttonPositiveBackgroundColor = _buttonPositiveBackgroundColor;

@synthesize buttonDefaultTitleColor = _buttonDefaultTitleColor;
@synthesize buttonNegativeTitleColor = _buttonNegativeTitleColor;
@synthesize buttonPositiveTitleColor = _buttonPositiveTitleColor;

@synthesize buttonDefaultBold = _buttonDefaultBold;
@synthesize buttonNegativeBold = _buttonNegativeBold;
@synthesize buttonPositiveBold = _buttonPositiveBold;

@synthesize buttonDefaultOnPressBackgroundColor = _buttonDefaultOnPressBackgroundColor;
@synthesize buttonNegativeOnPressBackgroundColor = _buttonNegativeOnPressBackgroundColor;
@synthesize buttonPositiveOnPressBackgroundColor = _buttonPositiveOnPressBackgroundColor;

@synthesize buttonDefaultOnPressTitleColor = _buttonDefaultOnPressTitleColor;
@synthesize buttonNegativeOnPressTitleColor = _buttonNegativeOnPressTitleColor;
@synthesize buttonPositiveOnPressTitleColor = _buttonPositiveOnPressTitleColor;

@synthesize headerTitleTextAlignment = _headerTitleTextAlignment;
@synthesize headerSubTitleTextAlignment = _headerSubTitleTextAlignment;
@synthesize headerPadding = _headerPadding;



@synthesize alertViewContentBackgroundType = _alertViewContentBackgroundType;

// Fonts
@synthesize titleFont = _titleFont;
@synthesize subTitleFont = _subTitleFont;
@synthesize buttonRegularFont = _buttonRegularFont;
@synthesize buttonBoldFont = _buttonBoldFont;
@synthesize bodyFont = _bodyFont;

@synthesize flexibleHeight = _flexibleHeight;

+ (instancetype) sharedManager {
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		alertViewBrandingManager = [[self alloc] init];
	});
	
	return alertViewBrandingManager;
}

+ (void) initializeWithBrandingFile: (NSString *) fileName andBundle: (NSBundle *) bundle type:(NSString *)type {
    [[ITSAlertViewBrandingManager sharedManager] rebrandUsingFile:fileName andBundle:bundle type:type];
}

- (void) rebrandUsingPlistFile: (NSString *) fileName andBundle: (NSBundle *) bundle {
    [self rebrandUsingFile:fileName andBundle:bundle type:@"json"];
}

- (void) rebrandUsingJSONFile: (NSString *) fileName andBundle: (NSBundle *) bundle {
    [self rebrandUsingFile:fileName andBundle:bundle type:@"plist"];
}

- (void) rebrandUsingJSONFile: (NSString *) fileName {
    [self rebrandUsingJSONFile:fileName andBundle:[NSBundle mainBundle]];
}

- (void) rebrandUsingPlistFile: (NSString *) fileName {
    [self rebrandUsingPlistFile:fileName andBundle:[NSBundle mainBundle]];
}

- (void) rebrandUsingFile: (NSString *) fileName andBundle: (NSBundle *) bundle type:(NSString *)type {
    
    alertViewBrandingDictionary = [NSDictionary dictionaryWithContentsOfFile:[bundle pathForResource:fileName ofType:type]];

    [self brandUsingDictionary:alertViewBrandingDictionary];
    
    [self applyLimits];
}

- (void) applyLimits {
	
	if (_width > kMaximumWidth) {
		_width = kMaximumWidth;
	}
	
	if (_height > kMaximumHeight) {
		_height = kMaximumHeight;
	}
	
	if (_cornerRadius > kCornerRadius) {
		_cornerRadius = kCornerRadius;
	}
}

- (void) brandUsingDictionary: (NSDictionary *) dictionary {
	
	_width = [[dictionary valueForKeyPath:@"alert.dimensions.width"] floatValue];
	_height = [[dictionary valueForKeyPath:@"alert.dimensions.height"] floatValue];
	_cornerRadius = [[dictionary valueForKeyPath:@"alert.dimensions.cornerRadius"] floatValue];
	_flexibleHeight = [[dictionary valueForKeyPath:@"alert.dimensions.flexibleHeight"] boolValue];
    
	_backgroundOpacityAlpha = [[dictionary valueForKeyPath:@"alert.background.opacity.alpha"] floatValue];
	_backgroundOpacityColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.background.opacity.tintColor"]];
	
	_contentBackgroundGlossyTintColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.contentBackground.glossy.tintColor"]];
	_contentBackgroundSolidColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.contentBackground.solid.color"]];
	
    // Background color of buttons
	_buttonDefaultBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.default.backgroundColor"]];
	_buttonNegativeBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.negative.backgroundColor"]];
    _buttonPositiveBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.positive.backgroundColor"]];
    
    // Title color of the buttons
	_buttonDefaultTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.default.titleColor"]];
	_buttonNegativeTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.negative.titleColor"]];
    _buttonPositiveTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.positive.titleColor"]];
    
    // Boldness of buttons
	_buttonDefaultBold = [[dictionary valueForKeyPath:@"alert.button.default.bold"] boolValue];
	_buttonNegativeBold = [[dictionary valueForKeyPath:@"alert.button.negative.bold"] boolValue];
	_buttonPositiveBold = [[dictionary valueForKeyPath:@"alert.button.positive.bold"] boolValue];
    
	_buttonDefaultOnPressBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.default.onPressBackgroundColor"]];
	_buttonNegativeOnPressBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.negative.onPressBackgroundColor"]];
	_buttonPositiveOnPressBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.positive.onPressBackgroundColor"]];
    
	_buttonDefaultOnPressTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.default.onPressTitleColor"]];
	_buttonNegativeOnPressTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.negative.onPressTitleColor"]];
	_buttonPositiveOnPressTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.button.positive.onPressTitleColor"]];
    
    _headerTitleTextAlignment = [self textAlignmentFromNumber: [[dictionary valueForKeyPath:@"alert.header.titleTextAlignment"] integerValue]];
    _headerSubTitleTextAlignment = [self textAlignmentFromNumber: [[dictionary valueForKeyPath:@"alert.header.subTitleTextAlignment"] integerValue]];
    
    if ([[dictionary valueForKeyPath:@"alert.contentBackground.style"] isEqualToString:@"glossy"]) {
        _alertViewContentBackgroundType = ITSAlertViewContentBackgroundTypeGlossy;
    } else {
        _alertViewContentBackgroundType = ITSAlertViewContentBackgroundTypeSolid;
    }
}

- (NSTextAlignment) textAlignmentFromNumber: (NSInteger) alignment {
    
    switch (alignment) {
        case 0:
            return NSTextAlignmentLeft;
        case 2:
            return NSTextAlignmentRight;
        case 1:
        default:
            return NSTextAlignmentCenter;
    }
}

- (CGFloat) width {
	return _width;
}

- (CGFloat) height {
	return _height;
}

- (ITSAlertViewBackgroundType) popUpBackgroundType {
	return ITSAlertViewBackgroundTypeTransparent;
}

- (CGFloat) cornerRadius {
	return _cornerRadius;
}

- (CGFloat) maximumHeight {
	return kMaximumHeight;
}

- (CGFloat) maximumWidth {
	return kMaximumWidth;
}

- (void) setSubTitleFont:(UIFont *) stf {
    _subTitleFont = stf;
}

- (void) setTitleFont:(UIFont *) tf {
    _titleFont = tf;
}

- (void) setButtonBoldFont:(UIFont *)buttonBoldFont {
    _buttonBoldFont = buttonBoldFont;
}

- (void) setButtonRegularFont:(UIFont *)buttonRegularFont {
    _buttonRegularFont = buttonRegularFont;
}

- (void) setBodyFont:(UIFont *)bodyFont {
    _bodyFont = bodyFont;
}

- (UIFont *) titleFont {
    return (_titleFont ? _titleFont: [UIFont systemFontOfSize:16.0f]);
}

- (UIFont *) subTitleFont {
    return (_subTitleFont ? _subTitleFont: [UIFont systemFontOfSize:12.0f]);
}

- (UIFont *) buttonBoldFont {
    return (_buttonBoldFont ? _buttonBoldFont: [UIFont boldSystemFontOfSize:14.0f]);
}

- (UIFont *) buttonRegularFont {
    return (_buttonRegularFont ? _buttonRegularFont: [UIFont systemFontOfSize:14.0f]);
}

- (UIFont *) bodyFont {
    return (_bodyFont ? _bodyFont: [UIFont systemFontOfSize:14.0f]);
}

@end
