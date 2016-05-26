//
//  ITSAlertViewBrandingManager.h
//  ITSAlertView
//

#import <UIKit/UIKit.h>
#import "ITSCoreAlertView.h"

@interface ITSAlertViewBrandingManager : NSObject

////  view maximumWidth
//@property (nonatomic, readonly) CGFloat maximumWidth;
//
////  view maximumHeight
//@property (nonatomic, readonly) CGFloat maximumHeight;

//  view width
@property (nonatomic, readonly) CGFloat width;

//  view height
@property (nonatomic, readonly) CGFloat height;

//  cornerRadius
@property (nonatomic, readonly) CGFloat cornerRadius;

//  backgroundOpacityAlpha
@property (nonatomic, readonly) CGFloat backgroundOpacityAlpha;

//  backgroundOpacityColor
@property (nonatomic, readonly) UIColor *backgroundOpacityColor;

//  contentBackgroundGlossyTintColor
@property (nonatomic, readonly) UIColor *contentBackgroundGlossyTintColor;

//  contentBackgroundSolidColor
@property (nonatomic, readonly) UIColor *contentBackgroundSolidColor;

//  dismissOnTapOutside
@property (nonatomic, readonly) BOOL dismissOnTapOutside;

//  buttonDefaultBackgroundColor
@property (nonatomic, readonly) UIColor *buttonDefaultBackgroundColor;

//  buttonNegativeBackgroundColor
@property (nonatomic, readonly) UIColor *buttonNegativeBackgroundColor;

//  buttonDefaultTitleColor
@property (nonatomic, readonly) UIColor *buttonDefaultTitleColor;

//  buttonNegativeTitleColor
@property (nonatomic, readonly) UIColor *buttonNegativeTitleColor;

//  buttonDefaultOnPressBackgroundColor
@property (nonatomic, readonly) UIColor *buttonDefaultOnPressBackgroundColor;

//  buttonNegativeOnPressBackgroundColor
@property (nonatomic, readonly) UIColor *buttonNegativeOnPressBackgroundColor;

//  buttonDefaultOnPressTitleColor
@property (nonatomic, readonly) UIColor *buttonDefaultOnPressTitleColor;

//  buttonNegativeOnPressTitleColor
@property (nonatomic, readonly) UIColor *buttonNegativeOnPressTitleColor;

//  buttonDefaultBold
@property (nonatomic, readonly) BOOL buttonDefaultBold;

//  buttonNegativeBold
@property (nonatomic, readonly) BOOL buttonNegativeBold;

//  flexibleHeight
@property (nonatomic, readonly) BOOL flexibleHeight;

//  headerTitleTextAlignment
@property (nonatomic, readonly) NSTextAlignment headerTitleTextAlignment;

@property (nonatomic, readonly) NSTextAlignment headerSubTitleTextAlignment;

@property (nonatomic, readonly) CGFloat headerPadding;

//----------
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIFont *subTitleFont;

@property (nonatomic, strong) UIFont *buttonRegularFont;

@property (nonatomic, strong) UIFont *buttonBoldFont;

@property (nonatomic, strong) UIFont *bodyFont;

+ (instancetype) sharedManager;
+ (void) initializeWithBrandingFile: (NSString *) fileName andBundle: (NSBundle *) bundle;

@end
