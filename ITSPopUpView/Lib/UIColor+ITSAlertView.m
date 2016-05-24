//
//  UIColor.m
//  ITSPopUpView
//
//  Created by Deborshi Saha on 5/23/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "UIColor+ITSAlertView.h"

@implementation UIColor (ITSAlertView)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
	unsigned rgbValue = 0;
	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	[scanner setScanLocation:1];
	[scanner scanHexInt:&rgbValue];
	
	CGFloat alpha = ((rgbValue & 0xFF000000) >> 24)/255.0;
	CGFloat red = ((rgbValue & 0xFF0000) >> 16)/255.0;
	CGFloat blue = (rgbValue & 0xFF)/255.0;
	CGFloat green = ((rgbValue & 0xFF00) >> 8)/255.0;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
	
}

@end
