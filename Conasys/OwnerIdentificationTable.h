//
//  OwnerIdentificationTable.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseTableView.h"
#import "CustomViewHeader.h"

@interface OwnerIdentificationTable : BaseTableView<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *ownerArray;
    RNBlurModalView  *modalView;
}


@property (nonatomic, retain)id controller;

- (void)setDelegateAndSource;
- (void)setParentController:(id)controller;

//- (NSMutableArray *)selectedArray;

@property (nonatomic, retain)DeficiencyReview *currentDeficiencyReview;
- (void)rotateEditOwnerView;

@end
