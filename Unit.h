//
//  Unit.h
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface Unit : BaseModel

@property (nonatomic, readwrite)long long unitRowId;


@property (nonatomic, retain)NSString *unitId;
@property (nonatomic, retain)NSString *address;
@property (nonatomic, retain)NSString *completionDate;
@property (nonatomic, retain)NSString *possessionDate;
@property (nonatomic, retain)NSString *unitEnrollmentNumber;
@property (nonatomic, retain)NSString *unitLegalDes;
@property (nonatomic, readwrite)int isPendingUnit;
@property (nonatomic, retain)NSString *unitNumber;
@property (nonatomic, readwrite)NSString *projectId;

@property (nonatomic, retain)NSMutableArray *locationList;
@property (nonatomic, retain)NSMutableArray *ownersList;


+(NSMutableArray *) unitsFromArray:(NSMutableArray *)array forProject:(NSString *)projectId;

+(Unit *) unitFromDictionary:(NSDictionary *)responseDictionary forProject:(NSString *)projectId;


@end
