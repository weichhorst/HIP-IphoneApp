//
//  OwnerIdentificationTable.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerIdentificationTable.h"
#import "CustomCellsHeader.h"
#import "OwnerDBManager.h"
#import "OwnerIdentificationViewController.h"
#import "ReviewOwnerDatabase.h"

#define CELL_HEIGHT 50
#define TABLE_HEADER_HEIGHT 0

#define EDIT_OWNER_VIEW_TAG 100

#define EDIT_OWNER_VIEW_X 0
#define EDIT_OWNER_VIEW_Y 0
#define EDIT_OWNER_WIDTH 1024
#define EDIT_OWNER_HEIGHT 1024

@implementation OwnerIdentificationTable

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


- (void)setDelegateAndSource{
    
    
    self.dataSource = self;
    self.delegate = self;
    
    [self reloadData];
}


#pragma mark - TableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentDeficiencyReview.reviewOwners.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    return nil;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"OwnerIdentificationCell";
    
    OwnerIdentificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                
                cell = (OwnerIdentificationCell *)currentObject;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
                
            }
        }
    }
    
    ReviewOwner *reviewOwner = [self.currentDeficiencyReview.reviewOwners objectAtIndex:indexPath.row];
    
    [cell setCellData:reviewOwner withClickHandler:^(id data, BOOL isClicked) {
        
        [self showTheEditView:reviewOwner forIndex:indexPath];
        
    } andOwnerSelectionHandler:^(id data, BOOL isSelected) {
        
        [self updateTheOwnerAtIndex:indexPath isSelected:isSelected];
    }];
    
    
    [cell setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
    
    if (![Utility isiOSVersion7]) {
        
        [cell.contentView setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
    }
        
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


// This will open a custom view where user can edit the selected owner.
- (void)showTheEditView:(ReviewOwner *)reviewOwner forIndex:(NSIndexPath *)indexPath{
    
    //15-sept-2014
//    if (!isConnected) {
//        
//        OwnerIdentificationViewController *obj = (OwnerIdentificationViewController *)self.controller;
//        
//        [obj showCustomAlertWithMessage:NSLocalizedString(@"Edit_Owner_Save_Network_Error", @"")];
//        
//        return;
//    }
    
    EditOwnerView *editOwnerView = [[EditOwnerView alloc]initWithFrame:CGRectMake(EDIT_OWNER_VIEW_X, EDIT_OWNER_VIEW_Y, EDIT_OWNER_WIDTH, EDIT_OWNER_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide) {
        
        if (shouldHide) {
            
            [modalView hide];
            modalView = nil;
        }
        
        if(buttonTag){
            
            [data setValue:self.currentDeficiencyReview.unitId forKey:@"UnitId"];
            [data setValue:@"true" forKey:@"IsOnline"];
            
            OwnerIdentificationViewController *obj = (OwnerIdentificationViewController *)self.controller;
            
            [obj updateOwner:data withCompletionHandler:^(id response, BOOL hasInternet, BOOL result) {
                
                if (result || !hasInternet) {
                    
                    if([[NSString stringWithFormat:@"%@ %@", reviewOwner.owner.firstName, reviewOwner.owner.lastName] isEqualToString:reviewOwner.printName]){
                        
                        reviewOwner.printName = [NSString stringWithFormat:@"%@ %@", [data objectForKey:EDIT_OWNER_FIRST_NAME_KEY], [data objectForKey:EDIT_OWNER_LAST_NAME_KEY]];
                    }
                    
                    reviewOwner.owner.firstName = [data objectForKey:EDIT_OWNER_FIRST_NAME_KEY];
                    reviewOwner.owner.lastName = [data objectForKey:EDIT_OWNER_LAST_NAME_KEY];
                    reviewOwner.email = reviewOwner.owner.email = [data objectForKey:EDIT_OWNER_EMAIL_KEY];
                    reviewOwner.owner.phoneNumber = [data objectForKey:EDIT_OWNER_PHONE_NUMBER_KEY];
                    reviewOwner.owner.enableEmailNotification = [[data objectForKey:EDIT_OWNER_EMAIL_KEY] isEqualToString:@"true"]?@"1":@"0";
                    
                    //15-sept-2014
                    reviewOwner.owner.isEdited = !hasInternet;
                    
                    Owner *myOwner = [[OwnerDBManager sharedManager] getOwnerFromId:reviewOwner.owner.ownerRowId];
                    
                    reviewOwner.owner.isNewOwner = myOwner.isNewOwner;

                    [[OwnerDBManager sharedManager] updateOwner:[NSMutableArray arrayWithObject:reviewOwner.owner]];
                    
                    [[ReviewOwnerDatabase sharedDatabase] updateReviewOwnerTable:reviewOwner];
                    
                    [self reloadData];
                }
            }];            
        }
    }];
    
    
    NSString *nibName = @"EditOwnerView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:editOwnerView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [editOwnerView setTag:EDIT_OWNER_VIEW_TAG];
    [editOwnerView addSubview:viewFromXib];
    
    [editOwnerView addLeftLabelsForTextFields];
    
    [editOwnerView setDataForView:reviewOwner.owner];
    
    modalView = [[RNBlurModalView alloc]initWithViewController:_controller view:editOwnerView];
    
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay-0.25.png"]]];
    
    [modalView show];
    
}


#pragma mark - DB Update
// Will be called when user wants to update the owner. It will be called from OwnerIdentificationCell.

- (void) updateTheOwnerAtIndex:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected{
    
    ReviewOwner *reviewOwner  = (ReviewOwner *)[self.currentDeficiencyReview.reviewOwners objectAtIndex:indexPath.row];
    
    reviewOwner.isSelectedOwner = isSelected;
    
    [[ReviewOwnerDatabase sharedDatabase] updateReviewOwnerTable:reviewOwner];
    
    [self.currentDeficiencyReview.reviewOwners replaceObjectAtIndex:indexPath.row withObject:reviewOwner];
 }


- (void)rotateEditOwnerView{
    
    
    if (modalView) {
                
        for (UIView *view in modalView.subviews) {
            
            if ([view isKindOfClass:[EditOwnerView class]]) {
                
                EditOwnerView *editOwner = (EditOwnerView *)view;
                
                [editOwner rotateView:[self orientationTypePortrait]];
                
                break;
            }
        }
    }
    
}

@end
