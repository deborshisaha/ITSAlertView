//
//  Plan.h
//  ITSAlertView
//
//  Created by Deborshi Saha on 5/27/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plan : NSObject

@property (nonatomic, copy) NSString *planName;
@property (nonatomic, copy) NSString *planDescription;
@property (nonatomic, strong) NSNumber *planPrice;

- (instancetype) initWithPlanName: (NSString *) planName planDescription: (NSString *) planDescription planPrice: (NSNumber *) planPrice;

@end
