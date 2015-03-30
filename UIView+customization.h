//
//  UIView+customization.h
//  Celebrity
//
//  Created by user on 3/3/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (customization)


- (void)roundedBorderWithWidth:(float )width andColor:(UIColor *)color;

- (void)roundedBorderWithWidth:(float )width radius:(float)radius andColor:(UIColor *)color;

- (void)addTapGestureWithTarget:(id)target andSelector:(SEL)selector;

- (void)addLeftLabelToMyTextField;

- (void)removeAllSubviews;

- (void)addLeftLabelToMyTextField:(NSString *)string andWidth:(float)width;

- (void)addLeftLabelToMyTextField:(NSString *)string andWidth:(float)width bold:(BOOL)isBold;

- (void)addLeftLabelToMyTextField:(NSString *)string andWidth:(float)width bold:(BOOL)isBold andColor:(UIColor *)color;

@end
