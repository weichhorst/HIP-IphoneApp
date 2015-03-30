//
//  ViewSelectionPopOverController.h
//  Conasys
//
//  Created by user on 5/15/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"
#import "Project.h"

@interface ViewSelectionPopOverController : UITableViewController{
    
    void(^completionBlock)(id data, NSIndexPath *indexPath, BOOL result);
    
    
}

@property (nonatomic, retain) Project *currentProject;

- (id)initWithCompletionBlock:(void(^)(id data, NSIndexPath *indexPath, BOOL result))myBlock;

@end
