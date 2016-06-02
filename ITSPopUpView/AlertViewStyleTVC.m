//
//  AlertViewStyleTVC.m
//  ITSPopUpView
//
//  Created by Deborshi Saha on 5/23/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "AlertViewStyleTVC.h"
#import "ITSPlanDataSource.h"
#import "Plan.h"

// Demo purpose only
#import "ITSAlertViewBrandingManager.h"

#import <UIKit/UIKit.h>

@interface AlertViewStyleTVC ()
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *stylesArray;
@property (nonatomic, strong) NSArray *customerThemesArray;
@property (nonatomic, strong) NSArray *inHouseThemesArray;
@end

@implementation AlertViewStyleTVC

- (void)viewDidLoad {
	[super viewDidLoad];
    
    if (!_stylesArray) {
        _stylesArray = [NSArray arrayWithObjects:@"Multiple Select", @"Single Select", @"Multiple Select with limit", @"Simple Alert", @"Notification Alert", @"Custom Multi Select", @"On option tap action", @"New Architecture", nil];
    }
    
    if (!_customerThemesArray) {
        _customerThemesArray = [NSArray arrayWithObjects:@"ItsOn", @"Telefonica", @"MTN", @"Sprint", @"Sapphire", nil];
    }
    
    if (!_inHouseThemesArray) {
        _inHouseThemesArray = [NSArray arrayWithObjects:@"Summer", @"Fall", @"Winter", @"Spring", nil];
    }
    
    if (!_array) {
        _array = [NSArray arrayWithObjects:_stylesArray, _customerThemesArray, nil];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.array.count > section) {
        return ((NSArray *)self.array[section]).count;
    }
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = nil;
    
    if (self.array.count > indexPath.section) {
        arr = ((NSArray *)self.array[indexPath.section]);
    }
    
    if (arr.count < indexPath.row) {
        return nil;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    cell.textLabel.text = arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Alert Styles";
    } else if (section == 1) {
        return @"Customer themes";
    } else {
        return @"In-house themes";
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            [self rowInSection0Selected: indexPath.row];
            break;
        case 1:
            [self rowInSection1Selected: indexPath.row];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) rowInSection1Selected: (NSInteger) row {
    switch (row) {
        case 0:
            [self loadItsOnTheme];
            break;
        case 1:
            [self loadTelefonicaTheme];
            break;
        case 2:
            [self loadMTNTheme];
            break;
        case 3:
            [self loadSprintTheme];
            break;
        case 4:
            [self loadSapphireTheme];
            break;
        default:
            break;
    }
}

- (void) loadItsOnTheme {
    [[ITSAlertViewBrandingManager sharedManager] rebrandUsingPlistFile:@"ITSItsOnTheme"];
}

- (void) loadTelefonicaTheme {
	[[ITSAlertViewBrandingManager sharedManager] rebrandUsingPlistFile:@"ITSTelefonicaTheme"];
}

- (void) loadMTNTheme {
	[[ITSAlertViewBrandingManager sharedManager] rebrandUsingPlistFile:@"ITSMTNTheme"];
}

- (void) loadSprintTheme {
	[[ITSAlertViewBrandingManager sharedManager] rebrandUsingPlistFile:@"ITSSprintTheme"];
}

- (void) loadSapphireTheme {
	[[ITSAlertViewBrandingManager sharedManager] rebrandUsingPlistFile:@"ITSSapphireTheme"];
}

- (void) rowInSection0Selected: (NSInteger) row {
    
    switch (row) {
        case 0:
            [self multipleOptionsAlertClicked];
            break;
        case 1:
            [self singleSelectAlertClicked];
            break;
        case 2:
            [self multipleOptionsWithLimitAlertClicked];
            break;
        case 3:
            [self simpleAlertClicked];
            break;
        case 4:
            [self notificationAlertClicked];
            break;
		case 5:
			[self customMultiSelect];
			break;
		case 6:
			[self customTapSelect];
			break;
        case 7:
            [self newArchitecture];
            break;
        default:
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0f;
}

- (void) customMultiSelect {
	
	Plan *plan1 = [[Plan alloc] initWithPlanName:@"Mexico calling" planDescription:@"Good plan to call Mexico" planPrice:@(30)];
	Plan *plan2 = [[Plan alloc] initWithPlanName:@"UK calling" planDescription:@"Excellent plan to call UK" planPrice:@(30)];
	Plan *plan3 = [[Plan alloc] initWithPlanName:@"Singapore calling" planDescription:@"Cheap plan to call Singapore. Cheap plan to call Singapore. Cheap plan to call Singapore. Cheap plan to call Singapore" planPrice:@(30)];
	
	ITSPlanDataSource *planDataSource = [[ITSPlanDataSource alloc] initWithPlansArray:[[NSArray alloc] initWithObjects:plan1, plan2, plan3, nil] ];
	
    ITSAlert *multiSelectAlert = [[ITSAlert alloc] initMultiSelectWithDataSource:planDataSource
                                                                       withTitle:@"Wanna make international calls"
                                                                  andDescription:@"Simply buy an international add-on to make international calls"
                                                            selectedOptionsBlock:^(NSArray *selectedObjects) {
	}];
	
	[multiSelectAlert show];
}

- (void) newArchitecture {
    
    ITSAlert *refactoredAlert = [[ITSAlert alloc] initNewArchitecture];
    [refactoredAlert show];
}

- (void) customTapSelect {
	
    Plan *plan1 = [[Plan alloc] initWithPlanName:@"Mexico calling" planDescription:@"Good plan to call Mexico" planPrice:@(21)];
    Plan *plan2 = [[Plan alloc] initWithPlanName:@"UK calling" planDescription:@"Excellent plan to call UK" planPrice:@(3)];
    Plan *plan3 = [[Plan alloc] initWithPlanName:@"Singapore calling" planDescription:@"Cheap plan to call Singapore. Cheap plan to call Singapore. Cheap plan to call Singapore. Cheap plan to call Singapore" planPrice:@(35)];
    
    ITSPlanDataSource *planDataSource = [[ITSPlanDataSource alloc] initWithPlansArray:[[NSArray alloc] initWithObjects:plan1, plan2, plan3, nil] ];
    
    __block ITSAlert *tapSelectAlert = [[ITSAlert alloc] initTapSelectWithDataSource: planDataSource
                                                                   withTitle: @"Wanna make international call?"
                                                              andDescription: @"Simply buy an international add-on to make international calls."
                                                           tappedOptionBlock: ^(id selectedObject) {
                                                                       if ([selectedObject isKindOfClass:([Plan class])]) {
                                                                           Plan *plan = (Plan *) selectedObject;
                                                                           NSLog(@"Add-on : %@",plan.planName);
                                                                           
                                                                           [tapSelectAlert hide];
                                                                       }
                                                                   }
                                                                dismissTitle:@"Cancel"
                                                          dismissActionBlock:nil
                                                          primaryActionTitle:@"Add-ons" primaryActionBlock:^{
                                                              NSLog(@"Add-ons pressed");
                                                              [tapSelectAlert hide];
                                                          }];
    
	[tapSelectAlert show];
}

- (void) notificationAlertClicked {
    
    ITSAlert *notificationAlert = [[ITSAlert alloc] initNotificationAlertWithTitle:@"You will run today" andMessage:@"Running is good for health" buttonTitle:@"Okay" buttonBlock:nil];
    [notificationAlert show];
}

- (void) multipleOptionsAlertClicked {
    
    __weak NSArray *multiSelectOptionsArray = [NSArray arrayWithObjects:@"Green", @"Yellow", @"Red", nil];
    
    ITSAlert *alertViewLauncher = [[ITSAlert alloc] initMultiSelectWithOptions:multiSelectOptionsArray withTitle:@"Which is your favorite color?" andDescription:@"Knowing your favorite color makes this world a better place!! Not really..." selectedOptionsBlock:^(NSArray *objects) {
        NSLog(@">>> %lu", (unsigned long)objects.count);
    } selectionLimit:multiSelectOptionsArray.count];
    
    [alertViewLauncher show];
}


- (void) singleSelectAlertClicked {
    
    NSArray *singleSelectOptionsArray = [NSArray arrayWithObjects:@"Green", @"Yellow", @"Red", nil];
    
    ITSAlert *singleSelectAlert = [[ITSAlert alloc] initSingleSelectWithOptions:singleSelectOptionsArray withTitle:@"Which is your favorite color?" andDescription:@"Knowing your favorite color makes this world a better place!! Not really..." selectedOptionsBlock:^(id selectedObject) {
        
        if ([selectedObject isKindOfClass:[NSString class]]) {
            NSLog(@"Selected option %@", (NSString *) selectedObject);
        }
    }];
    
    [singleSelectAlert show];
}


- (void) multipleOptionsWithLimitAlertClicked {
    
    NSArray *multiSelectOptionsArray = [NSArray arrayWithObjects:@"Green", @"Yellow", @"Red", nil];
    
    ITSAlert *alertViewLauncher = [[ITSAlert alloc] initMultiSelectWithOptions:multiSelectOptionsArray withTitle:@"Which is your favorite color?" andDescription:@"Knowing your favorite color makes this world a better place!! Not really..." selectedOptionsBlock:^(NSArray *objects) {
        NSLog(@"%lu", (unsigned long)objects.count);
    } selectionLimit:2];
    
    [alertViewLauncher show];
}

- (void) simpleAlertClicked {
    
    ITSAlert *simpleAlert = [[ITSAlert alloc] initSimpleAlertWithTitle:@"You are awesome!" andMessage:@"A man cannot be comfortable without his own approval" positiveTitle:@"Thanks!" negativeTitle:@"Cancel" positiveBlock:^{
        NSLog(@"Done clicked!!");
    } negativeBlock:^{
        NSLog(@"Cancel clicked!!");
    }];
    
    [simpleAlert show];
}

@end
