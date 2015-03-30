//
//  ItemImage.h
//  Conasys
//
//  Created by user on 6/30/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

@interface ItemImage : BaseModel


@property (nonatomic, readwrite)long long itemImageRowId;
@property (nonatomic, readwrite)NSString *unitId;
@property (nonatomic, retain)NSURL *itemImagePath;

@end
