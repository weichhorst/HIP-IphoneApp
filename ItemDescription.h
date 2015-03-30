//
//  ItemDescription.h
//  Conasys
//
//  Created by user on 6/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import "Unit.h"
#import "Location.h"
#import "Product.h"

@interface ItemDescription : BaseModel



@property (nonatomic, readwrite)int itemId;
@property (nonatomic, readwrite)int itemProductId;
@property (nonatomic, readwrite)int itemLocationId;


@property (nonatomic, readwrite)int itemNumber;
@property (nonatomic, retain)NSString *itemProduct;
@property (nonatomic, retain)NSString *itemLocation;
@property (nonatomic, retain)NSString *itemDescription;

@property (nonatomic, retain)NSMutableArray *itemImages;

@property (nonatomic, readwrite)long long itemDescRowId;

@property (nonatomic, readwrite)int myRefNumber;

@property (nonatomic, retain)Location *location;
@property (nonatomic, retain)Product *product;

//@property (nonatomic, retain)NSMutableArray *imageArray;

@end
