//
//  ProductPopOverViewController.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Unit.h"
#import "ColorFile.h"

@interface ProductPopOverViewController : UITableViewController{
    
    
    NSMutableArray *allProducts;
    void(^completionBlock)(id data, NSIndexPath *indexPath, BOOL result);
}


@property (nonatomic, retain)Location *currentLocation;
@property (nonatomic, retain)Unit *currentUnit;
@property (nonatomic, readwrite)int locationId;
@property (nonatomic , strong) NSString * currentUnitID;
- (id)initWithCompletionBlock:(void(^)(id data, NSIndexPath *indexPath, BOOL result))myBlock;


@end
