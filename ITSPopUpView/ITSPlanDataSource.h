//
//  ITSPlanDataSource.h
//  ITSAlertView
//
//  Created by Deborshi Saha on 5/27/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITSAlert.h"

@interface ITSPlanDataSource : NSObject <UITableViewDataSource, ITSAlertOptionsDelegate>

- (instancetype) initWithPlansArray: (NSArray *) array;

@end