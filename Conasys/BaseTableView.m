//
//  BaseTableView.m
//  Conasys
//
//  Created by user on 6/11/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseTableView.h"

#import "DeficiencyReviewDatabase.h"
#import "ReviewItemDatabase.h"
#import "ReviewItemImageDatabase.h"
#import "ReviewOwnerDatabase.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (int)orientationTypePortrait{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    
    return NO;
}


@end
