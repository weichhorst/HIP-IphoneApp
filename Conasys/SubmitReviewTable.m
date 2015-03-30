//
//  SubmitReviewTable.m
//  Conasys
//
//  Created by user on 7/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "SubmitReviewTable.h"
#import "SubmitReviewCell.h"
#import "Utility.h"


#define TABLE_HEADER_HEIGHT 25

#define GROUP_NAME_KEY @"groupName"
#define DESCRIPTION_KEY @"groupDescriptionArray"

@implementation SubmitReviewTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)calculateRowData:(id)data{
    
    
}

- (void)setDelegateAndDataSource{
    
    [self setDelegate:self];
    [self setDataSource:self];
}


- (void)manageItemData{
    

    myDataArray = [NSMutableArray new];
    
    NSMutableArray *array = [NSMutableArray new];
    

    int counter = self.currentDeficiencyReview.deficienceyReviewItems.count;
    

    for (ReviewItem *reviewItem in self.currentDeficiencyReview.deficienceyReviewItems) {
        
        
        reviewItem.reviewItemNumber = counter--;
        [array addObject:reviewItem.itemLocation];
    }
    

    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:array];
    NSSet *uniqueStates = [orderedSet set];
    NSMutableArray *uniqueArray = [NSMutableArray arrayWithArray:[uniqueStates allObjects]];
    

    for (NSString *groupName in uniqueArray) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: groupName, GROUP_NAME_KEY, [self getTheDescriptionArray:groupName], DESCRIPTION_KEY, nil];
        
        [myDataArray addObject:dict];
    }
    

    [self reloadData];
}


- (NSMutableArray *)getTheDescriptionArray:(NSString *)groupName{
    
    NSMutableArray *detailItems = [NSMutableArray array];
    
    for (ReviewItem *reviewItem in self.currentDeficiencyReview.deficienceyReviewItems) {
        
        if ([reviewItem.itemLocation isEqualToString:groupName]) {
            
            [detailItems addObject:reviewItem];
        }
    }
    
    return detailItems;
}


#pragma mark UITableView data source delegate methods

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect tableFrame = tableView.frame;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableFrame.size.width, TABLE_HEADER_HEIGHT)];
    [headerView setBackgroundColor:COLOR_BLUE_APP];
    
    
    CGRect labelFrame = CGRectMake(15, 2, tableFrame.size.width-20, 20);
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:labelFrame];

    
    [lbl setText:[[myDataArray objectAtIndex:section] objectForKey:GROUP_NAME_KEY]];
    

    
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:[UIFont semiBoldWithSize:13.0f]];
    [lbl setTextColor:[UIColor whiteColor]];
    [headerView addSubview:lbl];
    return headerView;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [myDataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return [[[myDataArray objectAtIndex:section] objectForKey:DESCRIPTION_KEY] count];

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [self orientationTypePortrait]?@"SubmitReviewCell":@"SubmitReviewCell_iPad";
    
    SubmitReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                
                cell = (SubmitReviewCell *)currentObject;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
                
            }
        }
    }
    

    ReviewItem *reviewItem = [[[myDataArray objectAtIndex:indexPath.section] objectForKey:DESCRIPTION_KEY] objectAtIndex:indexPath.row];
    

    [cell setData:reviewItem];
    
    [cell setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
    if (![Utility isiOSVersion7]) {
        
        [cell.contentView setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
        
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    ReviewItem *reviewItem = [[[myDataArray objectAtIndex:indexPath.section] objectForKey:DESCRIPTION_KEY] objectAtIndex:indexPath.row];

    return [SubmitReviewCell heightForCell:reviewItem];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (CGFloat)tableMaxHeight{
    
    float height = 0.0;
    
    [myDataArray count];
    
    for (int section=0; section<[myDataArray count]; section++) {
                
        for (int row = 0; row< [[[myDataArray objectAtIndex:section] objectForKey:DESCRIPTION_KEY] count]; row++) {
            
            height+=[self tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        }
        height +=TABLE_HEADER_HEIGHT;
        
    }

    return height;
}



@end
