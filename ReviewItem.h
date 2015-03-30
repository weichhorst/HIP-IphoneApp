//
//  ReviewItem.h
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface ReviewItem : BaseModel


@property (nonatomic, readwrite)int reviewItemRowId;// only to fetch

@property (nonatomic, readwrite)int reviewRowId;

@property (nonatomic, readwrite)int itemLocationRowId;
@property (nonatomic, readwrite)int itemProductRowId;

@property (nonatomic, retain)NSString *itemLocation;
@property (nonatomic, retain)NSString *itemProduct;
@property (nonatomic, retain)NSString *itemDescription;


@property (nonatomic, retain)NSMutableArray *reviewItemImages;

@property (nonatomic, readwrite)int reviewItemNumber;
@property (nonatomic, retain)NSString *productId;

@end
