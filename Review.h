//
//  Review.h
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import "Users.h"
#import "Project.h"
#import "Unit.h"
#import "Service.h"
#import "Item.h"
#import "Developer.h"

@interface Review : BaseModel

@property (nonatomic, readwrite)int reviewRowId;

@property (nonatomic, retain)NSString *userId;
@property (nonatomic, readwrite)int projectRowId;
@property (nonatomic, readwrite)int unitsRowId;
@property (nonatomic, readwrite)int serviceRowId;
@property (nonatomic, readwrite)int itemId;
@property (nonatomic, retain)NSString *userSignBase64String;
@property (nonatomic, readwrite)int isPending;



@property (nonatomic, retain)Users *user;
@property (nonatomic, retain)Project *project;
@property (nonatomic, retain)Unit *unit;
@property (nonatomic, retain)Service *service;
@property (nonatomic, retain)Item *item;
@property (nonatomic, retain)Developer *developer;

@property (nonatomic, retain)NSMutableArray *reviewOwners;

@end
