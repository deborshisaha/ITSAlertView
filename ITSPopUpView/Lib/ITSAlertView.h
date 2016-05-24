//
//  ITSAlertView.h
//  ITSAlertView
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ITSAlertViewBackgroundType) {
    ITSAlertViewBackgroundTypeBlur = 1,
    ITSAlertViewBackgroundTypeTint = 2,
    ITSAlertViewBackgroundTypeTransparent = 3,
};

typedef NS_ENUM(NSUInteger, ITSAlertViewContentBackgroundType) {
	ITSAlertViewContentBackgroundTypeBlur = 1,
	ITSAlertViewContentBackgroundTypeSolid = 2,
};

@interface ITSAlertView : UIView

// Pop-up view maximumWidth (constant)

// Pop-up view maximumHeight (constant)

// Pop-up view width

// Pop-up view height

// Pop-up backgroundType - background blur, background simple opacity (tint color)

// Pop-up cornerRadius

// Header headerIconImage

// Header headerBackgroundColor

// Header headerText

// Header headerTextAlignment

// Header headerTextFont

// Header headerTextColor

// Description descriptionText

// Description descriptionTextColor

// Description descriptionTextAlignment

// Description descriptionTextFont

// Button negativeButtonBackgroundColor

// Button positiveButtonBackgroundColor

// Button primaryButtonBackgroundColor

// Button negativeButtonTextColor

// Button positiveButtonTextColor

// Button primaryButtonTextColor

// Button negativeButtonTextFont

// Button positiveButtonTextFont

// Button primaryButtonTextFont

// Button negativeButtonTextAlignment

// Button positiveButtonTextAlignment

// Button primaryButtonTextAlignment


// instantiating

// instantiate with Pop up view delegate object

// instantiate with title, description, buttons and block on button press
+ (instancetype) initWithTitle: (NSString *) title
				   description: (NSString *) description
				  buttonTitles: (NSArray *) arrayOfButtons
		   negativeButtonIndex: (NSInteger) negativeButtonIndex
			buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
				  attachToView: (UIView *) view
	alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType;

- (void) show;

@end