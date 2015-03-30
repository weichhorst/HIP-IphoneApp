//
//  Service.h
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface Service : BaseModel

@property (nonatomic, readwrite)long long serviceRowId;

@property (nonatomic, retain)NSString *serviceTypeId;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, readwrite)int isConstructionView;
@property (nonatomic, retain)NSString *legalTerms;
@property (nonatomic, readwrite)NSString *projectId;


+(NSMutableArray *) serviceFromArray:(NSArray *)responseArray forProject:(NSString *)projectId;

+(Service *) serviceFromDictionary:(NSDictionary *)responseDictionary forProject:(NSString *)projectId;

@end
