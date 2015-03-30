//
//  ServiceReviewTable.h
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseTableView.h"

@interface ServiceReviewTable : BaseTableView<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    
    UISearchBar *unitSearchBar, *addressSearchBar;
    
}


@property (nonatomic, retain)NSMutableArray *allUnitsArray, *searchedUnitArray;
@property (nonatomic, retain)id controller;

@property (nonatomic, retain)Project *currentProject;


- (void)setParentController:(id)controller;

- (void)setSearchBarDelegate:(UISearchBar *)searchBar;

- (void)removeAllObjectsAndReload;

- (void)setDelegateAndSource;

@end
