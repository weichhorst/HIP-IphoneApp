//
//  Project.h
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import "Service.h"

@interface Project : BaseModel

@property (nonatomic, readwrite)long long projectRowId;
@property (nonatomic, retain)NSString *userId;

// attributes/properties
@property (nonatomic, retain)NSString *projectId;
@property (nonatomic, retain)NSString *logohref;
@property (nonatomic, retain)NSString *address;
@property (nonatomic, retain)NSString *builderRefNum;
@property (nonatomic, retain)NSString *primaryColor;
@property (nonatomic, retain)NSString *secondaryColor;
@property (nonatomic, retain)NSString *projectName;
@property (nonatomic, retain)NSString *builderLogo;


@property (nonatomic, retain)NSMutableArray *units;
@property (nonatomic, retain)NSMutableArray *serviceTypes;


+(NSMutableArray *) projectsFromArray:(NSMutableArray *)array andConstructionDict:(NSDictionary *)dict;

+(Project *) projectFromDictionary:(NSDictionary *)responseDictionary andConstructionDict:(NSDictionary *)dict;

@end
