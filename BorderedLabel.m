//
//  BorderedLabel.m
//  Conasys
//
//  Created by user on 7/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BorderedLabel.h"

@implementation BorderedLabel

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
    
    
    if ([self viewWithTag:100]) {
        
        [[self viewWithTag:100] removeFromSuperview];
    }
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropdown_arrow.png"]];
    imgView.tag= 100;
    [imgView setFrame:CGRectMake(self.frame.size.width-19, 8, 14, 12)];
    
    [self addSubview:imgView];

    
}



- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
