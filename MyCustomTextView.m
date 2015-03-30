//
//  MyCustomTextView.m
//  Conasys
//
//  Created by user on 7/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "MyCustomTextView.h"

@implementation MyCustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.contentInset = UIEdgeInsetsMake(4,8,5,15);
}


- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {0, 5, 0, 20};
    
    self.contentInset = UIEdgeInsetsMake(4,8,5,15);
    
}


@end
