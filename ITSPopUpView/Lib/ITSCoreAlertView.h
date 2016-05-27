//
//  ITSCoreAlertView.h
//  ITSCoreAlertView
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ITSAlertViewBackgroundType) {
    ITSAlertViewBackgroundTypeBlur = 1,
    ITSAlertViewBackgroundTypeTint = 2,
    ITSAlertViewBackgroundTypeTransparent = 3,
};

@interface ITSCoreAlertView : UIView

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
//+ (instancetype) initWithTitle: (NSString *) title
//				   description: (NSString *) description
//				  buttonTitles: (NSArray *) arrayOfButtons
//		   negativeButtonIndex: (NSInteger) negativeButtonIndex
//			buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
//				  attachToView: (UIView *) view
//	alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType;

//+ (instancetype) initWithTitle: (NSString *) title
//                   headerImage: (UIImage *) headerImage
//                   description: (NSString *) description
//                  buttonTitles: (NSArray *) arrayOfButtons
//           negativeButtonIndex: (NSInteger) negativeButtonIndex
//            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock
//                  attachToView: (UIView *) view
//    alertContentBackgroundType: (ITSAlertViewContentBackgroundType)alertViewContentBackgroundType;

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *) subtitle
                   headerImage: (UIImage *) headerImage
                   description: (NSString *) description
                  buttonTitles: (NSArray *) arrayOfButtonTitles
           negativeButtonIndex: (NSInteger) negativeButtonIndex
                 positiveButtonIndex: (NSInteger) positiveButtonIndex
                        hidden: (void (^)(void)) hiddenCompletionBlock
            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock;

- (instancetype) initWithTitle: (NSString *) title
                      subtitle: (NSString *) subtitle
                   headerImage: (UIImage *) headerImage
                     tableView: (UITableView *) tableView
                  buttonTitles: (NSArray *) arrayOfButtonTitles
           negativeButtonIndex: (NSInteger) negativeButtonIndex
                 positiveButtonIndex: (NSInteger) positiveButtonIndex
                        hidden: (void (^)(void)) hiddenCompletionBlock
            buttonPressedBlock: (void (^)(NSInteger buttonIndex))buttonPressedBlock;

- (void) show;

@end
