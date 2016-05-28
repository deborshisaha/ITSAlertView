//
//  UpsellPlanItemTableViewCell.m
//  ITSAlertView
//
//  Created by Deborshi Saha on 5/27/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "UpsellPlanItemTableViewCell.h"

@interface UpsellPlanItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *upsellPlanName;
@property (weak, nonatomic) IBOutlet UILabel *upsellPlanDescription;
@property (weak, nonatomic) IBOutlet UILabel *upsellPlanPrice;

@end

@implementation UpsellPlanItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPlan: (Plan *) plan {
	self.upsellPlanName.text = plan.planName;
	self.upsellPlanDescription.numberOfLines = 2;
	self.upsellPlanDescription.text = plan.planDescription;
	[self.upsellPlanDescription sizeToFit];
	self.upsellPlanPrice.text = [NSString stringWithFormat:@"%.2f", [plan.planPrice floatValue]];
}

@end
