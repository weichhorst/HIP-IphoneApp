//
//  ProjectDBManager.m
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ProjectDBManager.h"
#import "ProjectDataBase.h"
#import "ServiceDBManager.h"
#import "UnitsDBManager.h"

@implementation ProjectDBManager

static ProjectDBManager *projectDBManager = nil;

+ (id)sharedManager{
    
    if (!projectDBManager) {
        
        projectDBManager = [[ProjectDBManager alloc] init];
    }
    return projectDBManager;
}


// Saving all projects to Database.
- (void)saveUserProjectsToDB:(NSArray *)projectArray{
    
    UnitsDBManager *unitsDBManager = [UnitsDBManager sharedManager];
    ProjectDataBase *projectDataBase = [ProjectDataBase sharedDatabase];
    ServiceDBManager *serviceDBManager = [ServiceDBManager sharedManager];
    
    for (Project *project in projectArray) {

        if (![self isProjectExist:project]) {
            
            [projectDataBase insertIntoProjectTable:project];
            
            [serviceDBManager saveServicesToDB:project.serviceTypes];
            
            [unitsDBManager saveUnitsToDB:project.units];

        }
    }
}


- (NSMutableArray *)getAllProjectsForUser:(NSString *)userId{
    
    ProjectDataBase *projectDataBase = [ProjectDataBase sharedDatabase];
    
    return [projectDataBase getAllProjectsForUser:userId];
}

- (void)deleteOldForNewProjectForUser:(NSString *)userId{
    
    ProjectDataBase *projectDataBase = [ProjectDataBase sharedDatabase];
    
    [projectDataBase deleteOldForNewProjectForUser:userId];
}

- (void)updateProject:(Project *)project{
    
    [[ProjectDataBase sharedDatabase] updateProject:project];
}

- (int)isProjectExist:(Project *)project{
    
    return [[ProjectDataBase sharedDatabase] isProjectExist:project];
}


- (Project *)getProjectWithRowId:(int )projectRowId;{
    
    return [[ProjectDataBase sharedDatabase] getProjectWithRowId:projectRowId];
}


- (void)deleteProject:(Project *)project{
    
    [[ProjectDataBase sharedDatabase] deleteProject:project];
}

@end
