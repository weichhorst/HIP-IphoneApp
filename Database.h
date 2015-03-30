//
//  Database.h
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Database : NSObject

@property sqlite3 *connection;
@property (nonatomic,retain) NSString *databaseName;
@property (nonatomic,retain) NSString *databasePath;

+ (id)sharedDatabase;

-(void)createDb:(Database*)sharedDatabase;

-(void)customInit;

-(long long)getLastInsertedId;

@end
