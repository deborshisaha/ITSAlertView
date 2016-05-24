//
//  ITSButton.m
//  ITSPopUpView
//
//  Created by Deborshi Saha on 5/24/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import "ITSButton.h"
#import "UIColor+ITSAlertView.h"
#import "ITSAlertViewBrandingManager.h"

@implementation ITSButton

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	
	if (self.negative) {
		if (highlighted) {
			self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeOnPressBackgroundColor;
			self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeOnPressTitleColor;
		} else {
			self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeBackgroundColor;
			self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeTitleColor;
		}
	} else {
		if (highlighted) {
			self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultOnPressBackgroundColor;
			self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultOnPressTitleColor;
		} else {
			self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultBackgroundColor;
			self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultTitleColor;
		}
	}

}

- (instancetype) initWithFrame:(CGRect)frame negative: (BOOL) negative {
	self = [super initWithFrame:frame];
	
	if (self) {
		_negative = negative;
	}
	
	return self;
}
@end
