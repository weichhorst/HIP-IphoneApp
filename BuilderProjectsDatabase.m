//
//  BuilderProjectsDatabase.m
//  Conasys
//
//  Created by optimus-130 on 3/20/15.
//  Copyright (c) 2015 Evon technologies. All rights reserved.
//

#import "BuilderProjectsDatabase.h"
#import "Project.h"
#import  <sqlite3.h>
@implementation BuilderProjectsDatabase


static BuilderProjectsDatabase *sharedDatabase = nil;
static sqlite3_stmt *getProjectsForABuilder;
static sqlite3_stmt *deleteProjectsForABuilder;
static sqlite3_stmt *insertProjectsForABuilder;


+ (id)sharedDatabase
{
	
	if (!sharedDatabase)
	{
		sharedDatabase = [[self alloc] init];
		
		[sharedDatabase createDb:sharedDatabase];
		[sharedDatabase customInit];
		
	}
	return sharedDatabase;
}

-(void)customInit
{
	
//	static const char *insertPhotoPath = "Insert into ReviewItemImage (itemImagePath, base64String, reviewItemRowId) values (?, ?, ?)";
//	sqlite3_prepare_v2(self.connection, insertPhotoPath, -1, &insertItemPhotoStatement, NULL);
//	
//	static const char *getAllPhotos = "SELECT *, rowid From ReviewItemImage where reviewItemRowId = ?";
//	sqlite3_prepare_v2(self.connection, getAllPhotos, -1, &getAllItemPhotosStatement, NULL);
//	
//	static const char *deleteItemImages = "delete from ReviewItemImage where reviewItemRowId = ?";
//	sqlite3_prepare_v2(self.connection, deleteItemImages, -1, &deleteItemImageTable, NULL);
//	
//	static const char *deleteImage = "delete from ReviewItemImage where reviewItemRowId = ? and rowid = ?";
//	sqlite3_prepare_v2(self.connection, deleteImage, -1, &deleteItemImageWithPath, NULL);
	
	static const char * insertProjectsForABuilderQuery = "INSERT INTO BuilderProjects (BuilderId,ProjectID) VALUES (?,?) ";
	sqlite3_prepare_v2(self.connection, insertProjectsForABuilderQuery, -1, &insertProjectsForABuilder, NULL);
	
	static const char * deleteProjectsForABuilderQuery = "delete from BuilderProjects where BuilderId = ? ";
	sqlite3_prepare_v2(self.connection, deleteProjectsForABuilderQuery, -1, &deleteProjectsForABuilder, NULL);
	
	static const char * getProjectsForABuilderQuery = "select * from BuilderProjects where BuilderId = ? ";
	sqlite3_prepare_v2(self.connection, getProjectsForABuilderQuery, -1, &getProjectsForABuilder, NULL);
}


- (NSMutableArray *)getAllProjectsForUser:(NSString *)userId
{
	
	NSMutableArray *allProjectArray = [NSMutableArray new];
	
	sqlite3_bind_text(getProjectsForABuilder, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
	
	while (sqlite3_step(getProjectsForABuilder)==SQLITE_ROW)
	{

		NSString * projectID = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getProjectsForABuilder, 2)];
		
		[allProjectArray addObject:projectID];

	}
	
	sqlite3_reset(getProjectsForABuilder);
	return allProjectArray;
}

- (void)insertProjectsForABuilder:(NSString *)userId projectArray:(NSMutableArray*)projectsArray
{
	sqlite3_stmt * ifRowExists;
	static const char * ifRowExistsQuery = "SELECT EXISTS(SELECT * FROM BuilderProjects WHERE BuilderId = '?' and projectID = '?' );";
	sqlite3_prepare_v2(self.connection, ifRowExistsQuery, -1, &ifRowExists, NULL);

	sqlite3_bind_text(insertProjectsForABuilder, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(ifRowExists, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);

	
	for (Project * project in projectsArray) {
		sqlite3_bind_text(insertProjectsForABuilder, 2, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(ifRowExists, 2, [project.projectId UTF8String], -1, SQLITE_TRANSIENT);

		if (SQLITE_DONE != sqlite3_step(ifRowExists)) {
			// check is there is already an entry in the table for this projectID and User
			NSString * exists = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(ifRowExists, 0)];
			if([exists isEqualToString:@"1"]){
      // if there is an entry
				NSLog(@"Do Nothing");
				sqlite3_reset(ifRowExists);

			}
			else{
				//Insert ProjectID
				if (SQLITE_DONE != sqlite3_step(insertProjectsForABuilder))
					NSLog(@"InsertionFailed");
				else
					NSLog(@"InsertionSuccess");
				
				sqlite3_reset(insertProjectsForABuilder);
				sqlite3_reset(ifRowExists);

			}
				
		}
		
	}

}

-(void)deleteOldProjectForBuilder:(NSString*)userId{
	sqlite3_bind_text(deleteProjectsForABuilder, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
	if (SQLITE_DONE != sqlite3_step(deleteProjectsForABuilder)) {
		NSLog(@"Query Failed");
	}else
		NSLog(@"Query Succesfull");
	
	sqlite3_reset(deleteProjectsForABuilder);
}


@end
