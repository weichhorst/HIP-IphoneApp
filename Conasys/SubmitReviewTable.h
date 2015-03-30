//
//  SubmitReviewTable.h
//  Conasys
//
//  Created by user on 7/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseTableView.h"

@interface SubmitReviewTable : BaseTableView<UITableViewDelegate, UITableViewDataSource>{
    
    int numberOfSections;

    NSMutableArray *myDataArray;
}

@property (nonatomic, retain)DeficiencyReview *currentDeficiencyReview;
- (void)manageItemData;
- (void)setDelegateAndDataSource;
- (CGFloat)tableMaxHeight;

@end
