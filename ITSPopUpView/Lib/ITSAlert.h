//
//  ITSAlertViewLauncher.h
//  ITSAlertViewLauncher
//

#import <UIKit/UIKit.h>

typedef void (^SelectedOptionsBlock)(NSArray *selectedObjects);
typedef void (^SelectedOptionBlock)(id selectedObject);
typedef void (^SelectedButtonBlock)(NSInteger buttonIndex);
typedef void (^ButtonClickBlock)(void);

@protocol ITSAlertOptionsDelegate <NSObject>

@required
- (id) objectAtIndexPath: (NSIndexPath *) indexPath;
- (NSInteger) numberOfOptions;
- (void) cleanUp;

@optional
- (void) registerNibOfOptionsCellForTableView: (UITableView *) tableView;
- (BOOL) checkmarkOnSelection;

@end

@interface ITSAlert : NSObject

// Single Select
- (instancetype) initSingleSelectWithOptions: (NSArray *) options withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionBlock) selectedOptionBlock;

// Multi select with no limit
- (instancetype) initMultiSelectWithOptions: (NSArray *) options withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock;

// Multi select with limit setter
- (instancetype) initMultiSelectWithOptions: (NSArray *) options withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock selectionLimit: (NSInteger) selectionLimit;

// Multi select with external data source
- (instancetype) initMultiSelectWithDataSource: (id<UITableViewDataSource, ITSAlertOptionsDelegate>) dataSource withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock selectionLimit: (NSInteger) selectionLimit;

// Multi select with external data source without limit
- (instancetype) initMultiSelectWithDataSource: (id<UITableViewDataSource, ITSAlertOptionsDelegate>) dataSource withTitle:(NSString *) title andDescription:(NSString *) description selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock;

// Simple Permission alert having title, message and couple of buttons
- (instancetype) initSimpleAlertWithTitle:(NSString *) title andMessage:(NSString *) message positiveTitle: (NSString *)pt negativeTitle: (NSString *)nt positiveBlock: (ButtonClickBlock) positiveBlock negativeBlock: (ButtonClickBlock) negativeBlock ;

// Simple Permission alert having title, message and couple of buttons
- (instancetype) initSimpleAlertWithTitle:(NSString *) title andMessage:(NSString *) message positiveTitle: (NSString *)pt positiveBlock: (ButtonClickBlock) positiveBlock;

// Simple Notification alert having title, message and okay button
- (instancetype) initNotificationAlertWithTitle:(NSString *) title andMessage:(NSString *) message buttonTitle: (NSString *)buttonTitle buttonBlock: (ButtonClickBlock) buttonPressedBlock ;

- (void) show;

@end
