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

@interface ITSButton ()
@property (nonatomic, assign) BOOL bold;
@end

@implementation ITSButton

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	
    // Handle scenarios like (TRUE and TRUE) or (FALSE and FALSE).. Both cases will consider this button to be default
    if ((self.negative && self.positive) || (!self.negative && !self.positive)) {
        if (highlighted) {
            self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultOnPressBackgroundColor;
            self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultOnPressTitleColor;
        } else {
            self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultBackgroundColor;
            self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonDefaultTitleColor;
        }
    } else if (self.negative) {
		if (highlighted) {
			self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeOnPressBackgroundColor;
			self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeOnPressTitleColor;
		} else {
			self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeBackgroundColor;
			self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonNegativeTitleColor;
		}
    } else if (self.positive) {
        if (highlighted) {
            self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonPositiveOnPressBackgroundColor;
            self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonPositiveOnPressTitleColor;
        } else {
            self.backgroundColor = [ITSAlertViewBrandingManager sharedManager].buttonPositiveBackgroundColor;
            self.titleLabel.textColor = [ITSAlertViewBrandingManager sharedManager].buttonPositiveTitleColor;
        }
    }

}

- (instancetype) initWithFrame:(CGRect)frame negative: (BOOL) negative positive:(BOOL)positive {
	self = [super initWithFrame:frame];
	
	if (self) {
		_negative = negative;
        _positive = positive;
        self.backgroundColor = [UIColor clearColor];
        [self stylize];
	}
	
	return self;
}

- (void) stylize {
    
    // ErrorHandle : Scenarios like (TRUE and TRUE) or (FALSE and FALSE).. Both cases will consider this button to be default
    if ((self.negative && self.positive) || (!self.negative && !self.positive)) {
        
        [self setTitleColor:[ITSAlertViewBrandingManager sharedManager].buttonDefaultTitleColor forState:UIControlStateNormal];
        
        [self setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].buttonDefaultBackgroundColor];
        
        self.bold = [ITSAlertViewBrandingManager sharedManager].buttonDefaultBold;
        
    } else if (self.negative) {
        
        [self setTitleColor:[ITSAlertViewBrandingManager sharedManager].buttonNegativeTitleColor forState:UIControlStateNormal];
        
        [self setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].buttonNegativeBackgroundColor];
        
        self.bold = [ITSAlertViewBrandingManager sharedManager].buttonNegativeBold;
        
    } else if (self.positive) {
        
        [self setTitleColor:[ITSAlertViewBrandingManager sharedManager].buttonPositiveTitleColor forState:UIControlStateNormal];
        
        [self setBackgroundColor:[ITSAlertViewBrandingManager sharedManager].buttonPositiveBackgroundColor];
        
        self.bold = [ITSAlertViewBrandingManager sharedManager].buttonPositiveBold;
    }
}

- (void) setBold:(BOOL)bold {
    
    _bold = bold;
    
    if (_bold) {
        // Bold
        [self.titleLabel setFont:[ITSAlertViewBrandingManager sharedManager].buttonBoldFont];
    } else {
        [self.titleLabel setFont:[ITSAlertViewBrandingManager sharedManager].buttonRegularFont];
    }
}

@end
