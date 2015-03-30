//
//  CustomerCareTable.m
//  Conasys
//
//  Created by user on 5/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "CustomerCareTable.h"
#import "CustomerCareViewController.h"

@implementation CustomerCareTable

#define TABLE_HEADER_HEIGHT 0

#define  MISC NSLocalizedString(@"Miscellaneous", @"")

#define SELECT_LOCATION @"Select Location"
#define SELECT_PRODUCT @"Select Product"


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setParentController:(id)controller{
    
    self.controller = controller;
}

- (void)checkAndInsertIntoUnitsTable{
    
    
}


//- (void)viewdidload{
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//}

- (void)setDelegateAndSource{
    
    self.dataSource = self;
    self.delegate = self;
    
    [self setEditing:YES animated:YES];
    [self reloadData];
    
}



- (void)addItem:(id)object{
    
    ReviewItem *myReviewItem = [[ReviewItem alloc]init];
    
    if (self.currentDeficiencyReview.deficienceyReviewItems.count) {
        
        ReviewItem *reviewItem = [self.currentDeficiencyReview.deficienceyReviewItems objectAtIndex:0];
        
        myReviewItem.itemLocationRowId = reviewItem.itemLocationRowId;
        myReviewItem.itemLocation = reviewItem.itemLocation;
        myReviewItem.itemProduct = reviewItem.itemLocationRowId?MISC:SELECT_PRODUCT;

    }
    else{
      
        myReviewItem.itemLocationRowId = 0;
        myReviewItem.itemLocation = SELECT_LOCATION;
        myReviewItem.itemProduct = SELECT_PRODUCT;
    }
    
    
    myReviewItem.reviewRowId = self.currentDeficiencyReview.reviewRowId;
    
    myReviewItem.productId = [myReviewItem.itemProduct isEqualToString:SELECT_PRODUCT]?@"0":@"-1";
    
    myReviewItem.itemDescription = @"";
    myReviewItem.itemProductRowId = 0;
    
    
    ReviewItemDatabase *reviewDB = [ReviewItemDatabase sharedDatabase];
    
    [reviewDB insertIntoReviewItemTable:myReviewItem];
    
    
    ReviewItem *lastReviewItem  = [reviewDB getLastInsertedReviewItem];
    
    if (self.currentDeficiencyReview.deficienceyReviewItems.count) {

        [self.currentDeficiencyReview.deficienceyReviewItems insertObject:lastReviewItem atIndex:0];
    }
    else{
        
        [self.currentDeficiencyReview.deficienceyReviewItems addObject:lastReviewItem];

    }
    
    [self reloadData];
}
 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentDeficiencyReview.deficienceyReviewItems.count;
}

- (BOOL)isPortrait{
    
    if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation]==UIDeviceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    return NO;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [self orientationTypePortrait]?@"CustomerCareCell":@"CustomerCareCell_Landscape";

    CustomerCareCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                
                cell = (CustomerCareCell *)currentObject;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
                
            }
        }
    }
    
    cell.tag = cell.contentView.tag = indexPath.row;
    
    [cell setCellDataForItemDescription:[self.currentDeficiencyReview.deficienceyReviewItems objectAtIndex:indexPath.row] andUnit:self.currentUnit WithClickEvent:^(UIButton *button, BOOL result, id data) {
       
        
    }];

    cell.controller = self.controller;
    cell.parentController = self;
    
    [cell.lblItemDescNumber setText:[NSString stringWithFormat:@"%d", self.currentDeficiencyReview.deficienceyReviewItems.count-indexPath.row]];
    
    [cell.lblItemDescNumber setFont:[UIFont regularWithSize:14.0f]];
    
    
    [cell addTapGestures];
    
    
    [cell setBackgroundColor:indexPath.row%2?COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
    
    if (![Utility isiOSVersion7]) {
        
        [cell.contentView setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height)];
        [view setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
        [cell setBackgroundView:view];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    ReviewItem *reviewItem = [self.currentDeficiencyReview.deficienceyReviewItems objectAtIndex:indexPath.row];
    
    return [CustomerCareCell heightForCell:reviewItem.itemLocation product:reviewItem.itemProduct andDescription:reviewItem.itemDescription];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        
        [[ReviewItemDatabase sharedDatabase]deleteReviewItem:[self.currentDeficiencyReview.deficienceyReviewItems objectAtIndex:indexPath.row]];
        
        [self.currentDeficiencyReview.deficienceyReviewItems removeObjectAtIndex:indexPath.row];
        
        [aTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self reloadData];
        
        [self adjustFrame];
    }
}




- (void)adjustFrame{
    
    CustomerCareViewController *viewController = (CustomerCareViewController *)self.controller;
    [viewController setframes];
}


- (void)reloadTheRowWithIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (void)photosUpdatedForCell:(CustomerCareCell *)cell withAssets:(NSMutableArray *)imageAssetArray{
    
    
    
    [self reloadData];

}

- (void)itemCellUpdated:(CustomerCareCell *)cell withObject:(ReviewItem *)reviewItem{
    
    [[ReviewItemDatabase sharedDatabase]updateReviewItem:reviewItem];
    
    [self updateCell:cell];
    
    [self adjustFrame];
}


- (void)updateCell:(CustomerCareCell *)cell{
    
    [self beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}


- (id)getTheData{
    
    return self.currentDeficiencyReview;
}



- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (CGFloat)tableMaxHeight{
    
    
    float currentHeight =[self orientationTypePortrait]?572:300;
    
    currentHeight -= [Utility isiOSVersion6]?15:0;
    
    if (self.currentDeficiencyReview.deficienceyReviewItems.count>=8) {
    
        return currentHeight;
    }
    
    float height = 0.0;
    
    for (int i=0; i<[self.currentDeficiencyReview.deficienceyReviewItems count]; i++) {
    

        height+=[self tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
    }
    
    height+=20;

    if (height>currentHeight) {
        
        return currentHeight;
    }
    
    return height;
}


- (float)additions{
    
    if ([Utility isiOSVersion6]) {
        
        return 20;
    }
    return 0;
}

@end
