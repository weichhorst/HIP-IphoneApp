//
//  Item.h
//  Conasys
//
//  Created by user on 6/13/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"

#import "Owner.h"
//#import "Unit.h"

@interface Item : BaseModel


//@property (nonatomic, retain)Unit *unit;
@property (nonatomic, readwrite)int unitId;
@property (nonatomic, readwrite)int itemId;
@property (nonatomic, readwrite)BOOL isPdiView;

@property (nonatomic, retain)NSString *PerformedByName;
@property (nonatomic, retain)NSString *PerformedByEmail;
@property (nonatomic, retain)NSString *itemComment;
@property (nonatomic, retain)NSString *itemAddress;

@property (nonatomic, retain)NSMutableArray *itemDescriptionArray;

@property (nonatomic, retain)NSMutableArray *selectedOwner;
//@property (nonatomic, retain)

@end
