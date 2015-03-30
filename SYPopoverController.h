//
//  SYPopoverController.h
//  Conasys
//
//  Created by Optimus-66 on 2/2/15.
//  Copyright (c) 2015 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SYPopoverController : UIPopoverController

@property (readonly) UIColor *tintColor;
@property (nonatomic, readwrite)float arrowMarginPosition;

- (id)initWithContentViewController:(UIViewController *)viewController andTintColor: (UIColor *)tintColor;

@end
