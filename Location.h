//
//  Location.h
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface Location : BaseModel

@property (nonatomic, readwrite)long long locationRowId;

@property (nonatomic, retain)NSString *locationId;
@property (nonatomic, retain)NSString *locationName;
@property (nonatomic, retain)NSMutableArray *products;
@property (nonatomic, readwrite)NSString *unitId;


+(NSMutableArray *) locationsFromArray:(NSMutableArray *)array forUnit:(NSString *)unitId;
+(Location *) locationFromDictionary:(NSDictionary *)responseDictionary forUnit:(NSString *)unitId;


@end
