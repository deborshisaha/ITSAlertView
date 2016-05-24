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
	
	ITSAlertView *alertView = [ITSAlertView initWithTitle:@"Pop up" description:@"Description" buttonTitles:@[@"Cancel"] negativeButtonIndex:0 buttonPressedBlock:^(NSInteger buttonIndex) {
		NSLog(@"Hello");
	} attachToView:nil alertContentBackgroundType:ITSAlertViewContentBackgroundTypeSolid];
	
	[alertView show];
}

@end
