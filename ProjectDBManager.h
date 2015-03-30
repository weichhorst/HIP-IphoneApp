//
//  ProjectDBManager.h
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"

#import "Project.h"

@interface ProjectDBManager : BaseDBManager

- (void)saveUserProjectsToDB:(NSArray *)projectArray;

- (NSMutableArray *)getAllProjectsForUser:(NSString *)userId;

- (void)deleteOldForNewProjectForUser:(NSString *)userId;

- (void)updateProject:(Project *)project;

- (int)isProjectExist:(Project *)project;

- (Project *)getProjectWithRowId:(int )projectRowId;

- (void)deleteProject:(Project *)project;

@end
