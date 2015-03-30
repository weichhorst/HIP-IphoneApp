//
//  Owner.h
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface Owner : BaseModel


@property (nonatomic, readwrite)int ownerRowId;


@property (nonatomic, retain)NSString *ownerId;
@property (nonatomic, retain)NSString *unitId;
@property (nonatomic, retain)NSString *userName;
@property (nonatomic, retain)NSString *firstName;
@property (nonatomic, retain)NSString *lastName;
@property (nonatomic, retain)NSString *email;
@property (nonatomic, retain)NSString *phoneNumber;
@property (nonatomic, retain)NSString *enableEmailNotification;


@property (nonatomic, readwrite)BOOL isEdited;
@property (nonatomic, readwrite)BOOL isNewOwner;
@property (nonatomic, readwrite)BOOL isSyncing;
@property (nonatomic, retain)NSString *password;
@property (nonatomic, retain)NSString *builderName;
@property (nonatomic, retain)NSString *builderToken;

+(NSMutableArray *) ownersFromArray:(NSMutableArray *)array forUnit:(NSString *)unitId;
+(Owner *) ownerFromDictionary:(NSDictionary *)responseDictionary forUnit:(NSString *)unitId;

@end
