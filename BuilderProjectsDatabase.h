//
//  BuilderProjectsDatabase.h
//  Conasys
//
//  Created by optimus-130 on 3/20/15.
//  Copyright (c) 2015 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface BuilderProjectsDatabase : Database


- (NSMutableArray *)getAllProjectsForUser:(NSString *)userId;

- (void)insertProjectsForABuilder:(NSString *)userId projectArray:(NSMutableArray*)projectsArray;
- (void)deleteOldProjectForBuilder:(NSString*)builderId;
@end
