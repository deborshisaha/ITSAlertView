//
//  ITSAlertViewLauncher.h
//  ITSAlertViewLauncher
//

#import <Foundation/Foundation.h>

typedef void (^SelectedOptionsBlock)(NSArray *selectedOptions);

@interface ITSAlertViewLauncher : NSObject

- (instancetype) initMultiSelectWithOptions: (NSArray *) options selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock;

- (void) show;

@end
