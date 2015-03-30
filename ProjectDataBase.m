//
//  ProjectDataBase.m
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ProjectDataBase.h"
#import "Macros.h"
#import "ServiceDataBase.h"
#import "ServiceDBManager.h"
#import "UnitsDBManager.h"
#import "DeficiencyReviewDatabase.h"


@implementation ProjectDataBase


static Database *sharedDatabase = nil;

+ (id)sharedDatabase{
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
    }
    return sharedDatabase;
}


static sqlite3_stmt *insertProjectStatement;
static sqlite3_stmt *getAllProjectStatement;
static sqlite3_stmt *getAllProjectStatement2;

static sqlite3_stmt *deleteProjectStatement;
static sqlite3_stmt *switchParagmaON;
static sqlite3_stmt *updateProjectStatement;
static sqlite3_stmt *countProjectStatement;

static sqlite3_stmt *getProjectIdStatement;

//static sqlite3_stmt *lastInsertedObject;


// This method will initialiase all sqlite statement(insertion, fetching, deletion) at once and can be used to perform DB Operations later.
-(void)customInit {
    
//    static const char *insertRecord = "Insert into Project (projectId, logohref, address, builderRefNum, primaryColor, secondaryColor, projectName, userId, builderLogo) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	
  	static const char *insertRecord = "Insert into Project (projectId, logohref, address, builderRefNum, primaryColor, secondaryColor, projectName, builderLogo) values (?, ?, ?, ?, ?, ?, ?, ?)";

    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertProjectStatement, NULL);
    
    
    static const char *getProject = "SELECT * From Project where userId = ?";
	  static const char *getAllProject = "SELECT * From Project";
    sqlite3_prepare_v2(self.connection, getProject, -1, &getAllProjectStatement, NULL);
	  sqlite3_prepare_v2(self.connection, getAllProject, -1, &getAllProjectStatement2, NULL);

    static const char *getProjectFromRow = "SELECT * From Project where projectId = ?";
    sqlite3_prepare_v2(self.connection, getProjectFromRow, -1, &getProjectIdStatement, NULL);
    
    
    static const char *countProject = "SELECT count(*) From Project where userId = ? and ProjectId = ?";
    sqlite3_prepare_v2(self.connection, countProject, -1, &countProjectStatement, NULL);
    
    
//    static const char *deleteRecord = "DELETE FROM Project WHERE userId = ? AND projectId = ?";
  	static const char *deleteRecord = "DELETE FROM Project WHERE projectId = ?";
    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteProjectStatement, NULL);
    
    
    static const char *pragmaON = "PRAGMA foreign_keys = ON";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &switchParagmaON, NULL);
    
    
    static const char *updateQuery = "Update Project set logohref=?, address=?, builderRefNum = ?, primaryColor = ?, secondaryColor = ?, projectName = ?, builderLogo=? where projectId = ? and userId = ?";
    sqlite3_prepare_v2(self.connection, updateQuery, -1, &updateProjectStatement, NULL);
    
}


- (void)insertIntoProjectTable:(Project *)project{
    
  	static sqlite3_stmt * checkIfProjectExists;
  	static const char * checkIfProjectExistsQuery= "SELECT EXISTS(SELECT * FROM Project WHERE projectId = ? )";
	  sqlite3_prepare_v2(self.connection, checkIfProjectExistsQuery, -1, &checkIfProjectExists, NULL);
  	sqlite3_bind_text(checkIfProjectExists, 1, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);

	
    sqlite3_bind_text(insertProjectStatement, 1, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertProjectStatement, 2, [project.logohref UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertProjectStatement, 3, [project.address UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertProjectStatement, 4, [project.builderRefNum UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertProjectStatement, 5, [project.primaryColor UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertProjectStatement, 6, [project.secondaryColor UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertProjectStatement, 7, [project.projectName UTF8String], -1, SQLITE_TRANSIENT);
    
//    sqlite3_bind_text(insertProjectStatement, 8, [project.userId UTF8String], -1, SQLITE_TRANSIENT);
	
    sqlite3_bind_text(insertProjectStatement, 8, [project.builderLogo UTF8String], -1, SQLITE_TRANSIENT);
    
		 if(SQLITE_DONE != sqlite3_step(checkIfProjectExists)){
			 // check is there is already an entry in the table for this projectID
				NSString * exists = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(checkIfProjectExists, 0)];
				if([exists isEqualToString:@"1"]){
					// if there is an entry
					NSLog(@"Do Nothing");
					sqlite3_reset(checkIfProjectExists);
				}
			 else{
				 if(SQLITE_DONE != sqlite3_step(insertProjectStatement))
					 NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
			
			 }
			}
	
  	sqlite3_reset(checkIfProjectExists);
    sqlite3_reset(insertProjectStatement);
    
}


- (int)isProjectExist:(Project *)project{
    
    int count = 0;
    
    sqlite3_bind_text(countProjectStatement, 1, [project.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(countProjectStatement, 2, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);
    while (sqlite3_step(countProjectStatement)==SQLITE_ROW)
    {
        count =  sqlite3_column_int(countProjectStatement, 0);
    }
    
    sqlite3_reset(countProjectStatement);
    
    return count;
}


- (NSMutableArray *)getAllProjectsForUser:(NSString *)userId
{
    
    NSMutableArray *allProjectArray = [NSMutableArray new];
    
    sqlite3_bind_text(getAllProjectStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllProjectStatement)==SQLITE_ROW)
    {
        
        Project *project = [[Project alloc]init];

        project.projectId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 0)];
        
        
        if(sqlite3_column_text(getAllProjectStatement, 1) != nil){
            
            project.logohref = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 1)];
        }
        else{
            
            project.logohref = @" ";
        }
        
        
        if(sqlite3_column_text(getAllProjectStatement, 2) != nil){
            
            project.address = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 2)];
        }
        else{
            
            project.address = @" ";
        }
        
        if(sqlite3_column_text(getAllProjectStatement, 3) != nil){

            project.builderRefNum = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 3)];
        }
        else{
            
            project.builderRefNum=@"";
        }
        
        if(sqlite3_column_text(getAllProjectStatement, 4) != nil){
            
            project.primaryColor = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 4)];
        }
        else{
            
            project.primaryColor = @"";
        }
        
        if(sqlite3_column_text(getAllProjectStatement, 5) != nil){
            
            project.secondaryColor = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 5)];
        }
        else{
            
            project.secondaryColor = @"";
        }
        
        
        
        if(sqlite3_column_text(getAllProjectStatement, 6) != nil){
            
            project.projectName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 6)];
        }
        else{
            
            project.projectName = @"";
        }
        
        project.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 7)];
        
        if(sqlite3_column_text(getAllProjectStatement, 8) != nil){
            
            project.builderLogo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement, 8)];
        }
        else{
            
            project.builderLogo=@"";
        }
        
        project.serviceTypes = [[ServiceDBManager sharedManager] getAllServicesForProject:project.projectId];

        [allProjectArray addObject:project];
    }
    
    sqlite3_reset(getAllProjectStatement);
    return allProjectArray;
}

- (NSMutableArray *)getAllProjects
{
	
	NSMutableArray *allProjectArray = [NSMutableArray new];
	
	//    sqlite3_bind_text(getAllProjectStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
	
	while (sqlite3_step(getAllProjectStatement2)==SQLITE_ROW)
	{
		
		Project *project = [[Project alloc]init];
		
		project.projectId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 0)];
		
		
		if(sqlite3_column_text(getAllProjectStatement2, 1) != nil){
			
			project.logohref = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 1)];
		}
		else{
			
			project.logohref = @" ";
		}
		
		
		if(sqlite3_column_text(getAllProjectStatement2, 2) != nil){
			
			project.address = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 2)];
		}
		else{
			
			project.address = @" ";
		}
		
		if(sqlite3_column_text(getAllProjectStatement2, 3) != nil){
			
			project.builderRefNum = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 3)];
		}
		else{
			
			project.builderRefNum=@"";
		}
		
		if(sqlite3_column_text(getAllProjectStatement2, 4) != nil){
			
			project.primaryColor = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 4)];
		}
		else{
			
			project.primaryColor = @"";
		}
		
		if(sqlite3_column_text(getAllProjectStatement2, 5) != nil){
			
			project.secondaryColor = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 5)];
		}
		else{
			
			project.secondaryColor = @"";
		}
		
		
		
		if(sqlite3_column_text(getAllProjectStatement2, 6) != nil){
			
			project.projectName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 6)];
		}
		else{
			
			project.projectName = @"";
		}
		
		project.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 7)];
		
		if(sqlite3_column_text(getAllProjectStatement2, 8) != nil){
			
			project.builderLogo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProjectStatement2, 8)];
		}
		else{
			
			project.builderLogo=@"";
		}
		
		project.serviceTypes = [[ServiceDBManager sharedManager] getAllServicesForProject:project.projectId];
		
		[allProjectArray addObject:project];
	}
	
	sqlite3_reset(getAllProjectStatement2);
	return allProjectArray;
}


- (Project *)getProjectWithId:(NSString *)projectId
{
	
    Project *project = [[Project alloc]init];
	
    sqlite3_bind_text(getProjectIdStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
	
    while (sqlite3_step(getProjectIdStatement)==SQLITE_ROW)
    {
			
        project.projectId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 0)];
			
        if(sqlite3_column_text(getProjectIdStatement, 1) != nil){
					
            project.logohref = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 1)];
        }
        else{
            
            project.logohref = @" ";
        }
        
        if(sqlite3_column_text(getProjectIdStatement, 2) != nil){
            
            project.address = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 2)];
        }
        else{
            
            project.address = @" ";
        }
        
        if(sqlite3_column_text(getProjectIdStatement, 3) != nil){
            
            project.builderRefNum = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 3)];
        }
        else{
            
            project.builderRefNum=@"";
        }
        
        if(sqlite3_column_text(getProjectIdStatement, 4) != nil){
            
            project.primaryColor = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 4)];
        }
        else{
            
            project.primaryColor = @"";
        }
        
        if(sqlite3_column_text(getProjectIdStatement, 5) != nil){
            
            project.secondaryColor = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 5)];
        }
        else{
            
            project.secondaryColor = @"";
        }
        
        if(sqlite3_column_text(getProjectIdStatement, 6) != nil){
            
            project.projectName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 6)];
        }
        else{
            
            project.projectName = @"";
        }
        
//        project.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 7)];
			
        if(sqlite3_column_text(getProjectIdStatement, 8) != nil){
            
            project.builderLogo = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectIdStatement, 8)];
        }
        else{
            
            project.builderLogo=@"";
        }
        
        project.serviceTypes = [[ServiceDBManager sharedManager] getAllServicesForProject:project.projectId];
    }
    
    sqlite3_reset(getProjectIdStatement);
    
    return project;
}



- (void)deleteProject:(Project *)project{
    
    
    [self switchPragmaOn];

    NSMutableArray *array  = [[UnitsDBManager sharedManager]getAllUnitIdsForProjectId:project.projectId];
    
    for (NSString *unitId in array) {
        
        [[DeficiencyReviewDatabase sharedDatabase]deleteDeficiencyReviewForUnit:unitId];
    }
    
//    sqlite3_bind_text(deleteProjectStatement, 1, [project.userId UTF8String], -1, SQLITE_TRANSIENT);
	
    sqlite3_bind_text(deleteProjectStatement, 1, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteProjectStatement);
    sqlite3_reset(deleteProjectStatement);
    
}



- (void)deleteOldForNewProjectForUser:(NSString *)userId{
    
    
    [self switchPragmaOn];
    
    NSMutableArray *array = [self getAllProjectsForUser:CURRENT_BUILDER_ID];
    
    for (Project *project in array) {
        
        if (![[UnitsDBManager sharedManager] getPendingUnitsCountForProject:project.projectId]) {
            
            [self deleteProject:project];
        }
        
    }
    
}



- (void)updateProject:(Project *)project{
    
    
    sqlite3_bind_text(updateProjectStatement, 1, [project.logohref UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 2, [project.address UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 3, [project.builderRefNum UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 4, [project.primaryColor UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 5, [project.secondaryColor UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 6, [project.projectName UTF8String], -1, SQLITE_TRANSIENT);
   
    sqlite3_bind_text(updateProjectStatement, 7, [project.builderLogo UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 8, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateProjectStatement, 9, [project.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if(SQLITE_DONE != sqlite3_step(updateProjectStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(updateProjectStatement);

}

- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}



@end
