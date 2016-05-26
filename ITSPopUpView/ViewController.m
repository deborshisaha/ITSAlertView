//
//  ViewController.m
//  ITSPopUpView
//
//  Created by Deborshi Saha on 5/23/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "ViewController.h"
#import "ITSAlert.h"
#import <UIKit/UIKit.h>

@interface ViewController ()
@property (nonatomic, strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    if (!_array) {
        _array = [NSArray arrayWithObjects:@"Violet", @"Indiglo", @"Blue", @"Green", @"Yellow", @"Orange", @"Red", nil];
    }
}

- (IBAction)showPopUpClicked:(id)sender {
	
    ITSAlert *alertViewLauncher = [[ITSAlert alloc] initMultiSelectWithOptions:self.array selectedOptionsBlock:^(NSArray *selectedOptions) {
        NSLog(@"%lu", (unsigned long)selectedOptions.count);
    }];
    
    [alertViewLauncher show];
}

@end
