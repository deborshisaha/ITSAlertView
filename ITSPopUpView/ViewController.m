//
//  ViewController.m
//  ITSPopUpView
//
//  Created by Deborshi Saha on 5/23/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "ViewController.h"
#import "ITSAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showPopUpClicked:(id)sender {
	
//    ITSAlertView *alertView = [ITSAlertView initWithTitle:@"Wish to upgrade?" headerImage:nil description:@"Upgrading to latest version protects you from vulnerabilities" buttonTitles:@[@"Cancel"] negativeButtonIndex:0 buttonPressedBlock:^(NSInteger buttonIndex) {
//        NSLog(@"Hello");
//    } attachToView:nil alertContentBackgroundType:ITSAlertViewContentBackgroundTypeSolid];
	
    ITSAlertView *alertView = [[ITSAlertView alloc] initWithTitle:@"Wish to upgrade?" subtitle:@"Upgrading to latest version protects your phone from vulnerabilities" headerImage:nil description:@"Description" buttonTitles:@[@"Cancel"] negativeButtonIndex:0 buttonPressedBlock:^(NSInteger buttonIndex) {
        NSLog(@"Hello");
    } attachToView:nil alertContentBackgroundType:ITSAlertViewContentBackgroundTypeSolid];
    
	[alertView show];
}

@end
