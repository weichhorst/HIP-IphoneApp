//
//  Product.h
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface Product : BaseModel

@property (nonatomic, readwrite)long long productRowId;

@property (nonatomic, retain)NSString *productId;
@property (nonatomic, retain)NSString *productName;
@property (nonatomic, readwrite)int isIndented;
@property (nonatomic, retain)NSString *category;
@property (nonatomic ,retain)NSString *parentID;
@property (nonatomic, readwrite)int locationRowId;

+(NSMutableArray *) productsFromArray:(NSMutableArray *)array;

+(Product *) productFromDictionary:(NSDictionary *)responseDictionary;

@end
