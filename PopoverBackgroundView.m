//
//  PopoverBackgroundView.m
//  Conasys
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "PopoverBackgroundView.h"

@implementation PopoverBackgroundView
@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;

#define kArrowBase 30.0f
#define kArrowHeight 20.0f
#define kBorderInset 8.0f

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
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

+ (CGFloat)arrowBase
{
    return kArrowBase;
}

+ (CGFloat)arrowHeight
{
    return kArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(kBorderInset, kBorderInset, kBorderInset,       kBorderInset);
}

@end
