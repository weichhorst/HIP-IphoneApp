//
//  ProjectDataBase.h
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Project.h"


@interface ProjectDataBase : Database


+ (id)sharedDatabase;

- (void)insertIntoProjectTable:(Project *)project;

- (NSMutableArray *)getAllProjectsForUser:(NSString *)userId;

- (void)deleteProject:(Project *)project;

- (void)deleteOldForNewProjectForUser:(NSString *)userId;

- (void)updateProject:(Project *)project;

- (int)isProjectExist:(Project *)project;

- (Project *)getProjectWithId:(NSString *)projectId;

- (NSMutableArray *)getAllProjects;




@end
