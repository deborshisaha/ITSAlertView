//
//  ITSButton.h
//  ITSPopUpView
//
//  Created by Deborshi Saha on 5/24/16.
//  Copyright © 2016 Semicolon Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITSButton : UIButton

@property (nonatomic, readonly) BOOL negative;

- (instancetype) initWithFrame:(CGRect)frame negative: (BOOL) negative;

@end
