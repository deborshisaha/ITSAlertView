//
//  ITSAlertViewLauncher.h
//  ITSAlertViewLauncher
//

#import <UIKit/UIKit.h>

typedef void (^SelectedOptionsBlock)(NSArray *selectedOptions);
typedef void (^SelectedOptionsBlock)(NSArray *selectedOptions);

@interface ITSAlert : NSObject

- (instancetype) initMultiSelectWithOptions: (NSArray *) options selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock;
- (instancetype) initMultiSelectWithDataSource: (id<UITableViewDataSource>) dataSource selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock;

- (void) show;

@end
