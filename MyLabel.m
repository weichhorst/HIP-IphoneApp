//
//  MyLabel.m
//  TestingPurposeApp
//
//  Created by user on 7/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "MyLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
 */
- (void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    
//    CALayer *layer = [self layer];
//    
//    [layer setCornerRadius:3.0f];
//    [layer setBorderWidth:1.0f];
//    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
//    
//    if ([self viewWithTag:100]) {
//        
//        [[self viewWithTag:100] removeFromSuperview];
//    }
//    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkbox_checked.png"]];
//    imgView.tag= 100;
//    [imgView setFrame:CGRectMake(self.frame.size.width-19, 4, 17, 17)];
//    
//    [self addSubview:imgView];

}



- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
