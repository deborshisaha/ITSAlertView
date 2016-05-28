//
//  Plan.m
//  ITSAlertView
//
//  Created by Deborshi Saha on 5/27/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "Plan.h"

@implementation Plan
- (instancetype) initWithPlanName: (NSString *) planName planDescription: (NSString *) planDescription planPrice: (NSNumber *) planPrice {
	self = [super init];
	
	if (self) {
		_planName = planName;
		_planDescription = planDescription;
		_planPrice = planPrice;
	}
	
	return self;
}

@end
