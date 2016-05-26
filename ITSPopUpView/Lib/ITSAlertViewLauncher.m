//
//  ITSAlertViewLauncher.m
//  ITSAlertViewLauncher
//

#import "ITSAlertViewLauncher.h"
#import "ITSCoreAlertView.h"

@interface ITSAlertViewLauncher () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak) ITSCoreAlertView *alertView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SelectedOptionsBlock selectedOptionsBlock;
@end

@implementation ITSAlertViewLauncher

- (instancetype) initMultiSelectWithOptions: (NSArray *) options selectedOptionsBlock: (SelectedOptionsBlock) selectedOptionsBlock {
    
    self = [super init];
    
    if (self) {
        _array = options;
        _selectedOptionsBlock = selectedOptionsBlock;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource  = self;
        _tableView.delegate = self;
        _tableView.allowsSelection = YES;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}

- (void) show {
    
    [self.tableView reloadData];
    
    ITSCoreAlertView *alertView = [[ITSCoreAlertView alloc] initWithTitle:@"Which is your favorite color?"
                                                                 subtitle:@"Knowing your favorite color makes this world a better place... Not really!"
                                                              headerImage:nil
                                                                tableView: self.tableView
                                                             buttonTitles:@[@"Cancel",@"Done"]
                                                      negativeButtonIndex:-1
                                                       buttonPressedBlock:^(NSInteger buttonIndex) {
                                                           
                                                           if (buttonIndex == 1) {
                                                               self.selectedOptionsBlock(nil);
                                                           }
                                                       }
                                                             attachToView:nil
                                               alertContentBackgroundType:ITSAlertViewContentBackgroundTypeSolid];
    
    [alertView show];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
