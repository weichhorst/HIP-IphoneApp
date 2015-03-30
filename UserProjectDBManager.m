//
//  UserProjectDBManager.m
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UserProjectDBManager.h"

@implementation UserProjectDBManager

static UserProjectDBManager *userProjectDBManager = nil;

+ (id)sharedManager{
    
    if (!userProjectDBManager) {
        
        userProjectDBManager = [[UserProjectDBManager alloc] init];
    }
    return userProjectDBManager;
}



- (void)saveDataToUserProjectsDB:(NSArray *)projectArray{
    
    
}

@end
