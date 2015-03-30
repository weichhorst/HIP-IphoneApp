//
//  UIFont+Gibson.m
//  Conasys
//
//  Created by user on 7/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UIFont+Gibson.h"

@implementation UIFont (Gibson)

+ (UIFont *)regularWithSize:(float)size{
    
    return [UIFont fontWithName:@"Gibson-Regular" size:size];
    
}

+ (UIFont *)lightWithSize:(float)size{
    
    return [UIFont fontWithName:@"Gibson-Light" size:size];
}

+ (UIFont *)boldWithSize:(float)size{
    
    return [UIFont fontWithName:@"Gibson-Bold" size:size];
}

+ (UIFont *)semiBoldWithSize:(float)size{
    
    return [UIFont fontWithName:@"Gibson-SemiBold" size:size];
}

@end
