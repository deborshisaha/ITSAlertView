//
//  ITSAlertViewBrandingManager.h
//  ITSAlertView
//

#import <UIKit/UIKit.h>
#import "ITSAlertView.h"

@interface ITSAlertViewBrandingManager : NSObject

//// AlertView view maximumWidth
//@property (nonatomic, readonly) CGFloat maximumWidth;
//
//// AlertView view maximumHeight
//@property (nonatomic, readonly) CGFloat maximumHeight;

// AlertView view width
@property (nonatomic, readonly) CGFloat width;

// AlertView view height
@property (nonatomic, readonly) CGFloat height;

// AlertView cornerRadius
@property (nonatomic, readonly) CGFloat cornerRadius;

// AlertView backgroundOpacityAlpha
@property (nonatomic, readonly) CGFloat backgroundOpacityAlpha;

// AlertView backgroundOpacityColor
@property (nonatomic, readonly) UIColor *backgroundOpacityColor;

// AlertView contentBackgroundGlossyTintColor
@property (nonatomic, readonly) UIColor *contentBackgroundGlossyTintColor;

// AlertView contentBackgroundSolidColor
@property (nonatomic, readonly) UIColor *contentBackgroundSolidColor;

// AlertView dismissOnTapOutside
@property (nonatomic, readonly) BOOL dismissOnTapOutside;

// AlertView buttonDefaultBackgroundColor
@property (nonatomic, readonly) UIColor *buttonDefaultBackgroundColor;

// AlertView buttonNegativeBackgroundColor
@property (nonatomic, readonly) UIColor *buttonNegativeBackgroundColor;

// AlertView buttonDefaultTitleColor
@property (nonatomic, readonly) UIColor *buttonDefaultTitleColor;

// AlertView buttonNegativeTitleColor
@property (nonatomic, readonly) UIColor *buttonNegativeTitleColor;

// AlertView buttonDefaultOnPressBackgroundColor
@property (nonatomic, readonly) UIColor *buttonDefaultOnPressBackgroundColor;

// AlertView buttonNegativeOnPressBackgroundColor
@property (nonatomic, readonly) UIColor *buttonNegativeOnPressBackgroundColor;

// AlertView buttonDefaultOnPressTitleColor
@property (nonatomic, readonly) UIColor *buttonDefaultOnPressTitleColor;

// AlertView buttonNegativeOnPressTitleColor
@property (nonatomic, readonly) UIColor *buttonNegativeOnPressTitleColor;

// AlertView buttonDefaultBold
@property (nonatomic, readonly) BOOL buttonDefaultBold;

// AlertView buttonNegativeBold
@property (nonatomic, readonly) BOOL buttonNegativeBold;

// AlertView flexibleHeight
@property (nonatomic, readonly) BOOL flexibleHeight;

// AlertView headerTitleTextAlignment
@property (nonatomic, readonly) NSTextAlignment headerTitleTextAlignment;

@property (nonatomic, readonly) NSTextAlignment headerSubTitleTextAlignment;

@property (nonatomic, readonly) CGFloat headerPadding;

+ (instancetype) sharedManager;
+ (void) initializeWithBrandingFile: (NSString *) fileName andBundle: (NSBundle *) bundle;

@end
