//
//  CustomerCareTable.h
//  Conasys
//
//  Created by user on 5/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseTableView.h"
#import "CustomCellsHeader.h"

@interface CustomerCareTable : BaseTableView<UITableViewDataSource, UITableViewDelegate>{
    
//    NSMutableArray *itemArray;
}


@property (nonatomic, retain)id controller;
@property (nonatomic, retain)Unit *currentUnit;
@property (nonatomic, retain)Project *currentProject;
@property (nonatomic, retain)DeficiencyReview *currentDeficiencyReview;


- (void)setDelegateAndSource;
- (void)setParentController:(id)controller;

- (void)reloadTheRowWithIndexPath:(NSIndexPath *)indexPath;

- (void)addItem:(id)object;


- (void)itemCellUpdated:(id)cell withObject:(ReviewItem *)reviewItem;

- (void)photosUpdatedForCell:(id)cell withAssets:(NSArray *)imageAssetArray;

- (id)getTheData;

- (CGFloat)tableMaxHeight;

- (void)adjustFrame;


@end
