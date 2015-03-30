//
//  LocationPopOverViewController.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//      

#import <UIKit/UIKit.h>
#import "Unit.h"

@interface LocationPopOverViewController : UITableViewController{
    
    
    NSMutableArray *allLocations;
    void(^completionBlock)(id data, NSIndexPath *indexPath, BOOL result);
}

@property (nonatomic, retain)Unit *currentUnit;


- (id)initWithCompletionBlock:(void(^)(id data, NSIndexPath *indexPath, BOOL result))myBlock;


@end
