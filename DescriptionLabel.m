//
//  DescriptionLabel.m
//  Conasys
//
//  Created by user on 7/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "DescriptionLabel.h"

@implementation DescriptionLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    CALayer *layer = [self layer];
    
    [layer setCornerRadius:3.0f];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
}


- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {2, 5, 2, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
