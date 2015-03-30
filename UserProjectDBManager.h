//
//  UserProjectDBManager.h
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"

@interface UserProjectDBManager : BaseDBManager

+ (id)sharedManager;

- (void)saveDataToUserProjectsDB:(NSArray *)projectArray;

@end
