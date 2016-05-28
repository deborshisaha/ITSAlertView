//
//  ITSAlertViewBrandingManager.m
//  ITSAlertView
//

#import "ITSAlertViewBrandingManager.h"
#import "UIColor+ITSAlertView.h"

#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define isFaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define isFaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO

const CGFloat kMaximumPotraitWidth = 300.0f;
const CGFloat kMaximumPotraitHeight = 450.0f;

const CGFloat kMaximumLandscapeWidth = 450.0f;
const CGFloat kMaximumLandscapeHeight = 300.0f;

const CGFloat kCornerRadius = 10.0f;

static ITSAlertViewBrandingManager *alertViewBrandingManager = nil;
static NSDictionary *alertViewBrandingDictionary = nil;

@implementation ITSAlertViewBrandingManager

@synthesize potraitWidth = _potraitWidth;
@synthesize potraitHeight = _potraitHeight;
@synthesize landscapeWidth = _landscapeWidth;
@synthesize landscapeHeight =_landscapeHeight;

@synthesize cornerRadius = _cornerRadius;
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
@synthesize headerBackgroundColor = _headerBackgroundColor;
@synthesize headerTitleColor = _headerTitleColor;
@synthesize headerSubTitleColor = _headerSubTitleColor;

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
    [self rebrandUsingFile:fileName andBundle:bundle type:@"plist"];
}

- (void) rebrandUsingJSONFile: (NSString *) fileName andBundle: (NSBundle *) bundle {
    [self rebrandUsingFile:fileName andBundle:bundle type:@"json"];
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
	
	if (isLandscape) {
		[self applyLandscapeLimits];
	} else {
		[self applyPotraitLimits];
	}
}

- (void) applyPotraitLimits {
	
	if (_potraitWidth > kMaximumPotraitWidth) {
		_potraitWidth = kMaximumPotraitWidth;
	}
	
	if (_potraitHeight > kMaximumPotraitHeight) {
		_potraitHeight = kMaximumPotraitHeight;
	}
	
	if (_cornerRadius > kCornerRadius) {
		_cornerRadius = kCornerRadius;
	}
}

- (void) applyLandscapeLimits {
	
	if (_potraitWidth > kMaximumPotraitWidth) {
		_potraitWidth = kMaximumPotraitWidth;
	}
	
	if (_potraitHeight > kMaximumPotraitHeight) {
		_potraitHeight = kMaximumPotraitHeight;
	}
	
	if (_cornerRadius > kCornerRadius) {
		_cornerRadius = kCornerRadius;
	}
}

- (void) brandUsingDictionary: (NSDictionary *) dictionary {
	
	_potraitWidth = [[dictionary valueForKeyPath:@"alert.dimensions.potrait.width"] floatValue];
	_potraitHeight = [[dictionary valueForKeyPath:@"alert.dimensions.potrait.height"] floatValue];
	
	_landscapeWidth = [[dictionary valueForKeyPath:@"alert.dimensions.landscape.width"] floatValue];
	_landscapeHeight = [[dictionary valueForKeyPath:@"alert.dimensions.landscape.height"] floatValue];
	
	_cornerRadius = [[dictionary valueForKeyPath:@"alert.dimensions.cornerRadius"] floatValue];
	_flexibleHeight = [[dictionary valueForKeyPath:@"alert.dimensions.flexibleHeight"] boolValue];

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
	
	_headerTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.header.titleColor"]];
	_headerSubTitleColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.header.subTitleColor"]];
	
	_headerBackgroundColor = [UIColor colorFromHexString:[dictionary valueForKeyPath:@"alert.header.backgroundColor"]];
	
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

- (CGFloat) potraitWidth {
	return _potraitWidth;
}

- (CGFloat) potraitHeight {
	return _potraitHeight;
}

- (CGFloat) landscapeWidth {
	return _landscapeWidth;
}

- (CGFloat) landscapeHeight {
	return _landscapeHeight;
}

- (ITSAlertViewBackgroundType) popUpBackgroundType {
	return ITSAlertViewBackgroundTypeTransparent;
}

- (CGFloat) cornerRadius {
	return _cornerRadius;
}

//- (CGFloat) maximumHeight {
//	return kMaximumHeight;
//}
//
//- (CGFloat) maximumWidth {
//	return kMaximumWidth;
//}

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
