//
//  ServiceReviewTable.m
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ServiceReviewTable.h"
#import "ServiceReviewCell.h"
#import "OwnerIdentificationViewController.h"
#import "ServiceReviewViewController.h"
#import "Unit.h"
#import "DeficiencyReview.h"
#import "DeficiencyReviewDatabase.h"
#import "ReviewOwnerDatabase.h"

@implementation ServiceReviewTable


#define GALLERY_RECORD_LIMIT @"10"

#define CELL_HEIGHT 60
#define TABLE_HEADER_HEIGHT 0

#define SEARCHBAR_TAG 1111
#define OWNER_IDENTIFICATION_NIB @"OwnerIdentificationViewController"

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
    
    [self setSeparatorColor:[UIColor clearColor]];
    self.dataSource = self;
    self.delegate = self;
//    self.currentProject.units = [[UnitsDBManager sharedManager]getAllUnitsForProject:self.currentProject.projectId];
    _allUnitsArray = [[NSMutableArray alloc]initWithArray:self.currentProject.units];
    _searchedUnitArray = [[NSMutableArray alloc]initWithArray:self.currentProject.units];
    [addressSearchBar setText:@""];
    [unitSearchBar setText:@""];
    [self reloadData];
}


- (void)removeAllObjectsAndReload{
    
    [self reloadData];
}


// setting various searchbar delegates here. Searching will be handled here.
- (void)setSearchBarDelegate:(UISearchBar *)searchBar{
    
    [searchBar setDelegate:self];
    if (searchBar.tag) {
        
        addressSearchBar = searchBar;
    }else{
        
        unitSearchBar = searchBar;
    }
}


- (void)reloadData{
    
    [super reloadData];
}


#pragma mark UITableView data source delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEADER_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _searchedUnitArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [self orientationTypePortrait]?@"ServiceReviewCell":@"ServiceReviewCell_Landscape";
    
    ServiceReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                
                cell = (ServiceReviewCell *)currentObject;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
                
            }
        }
    }
    
    
    [cell setCellData:[_searchedUnitArray objectAtIndex:indexPath.row] withStartHandler:^(id data, BOOL isClicked) {
        
        Unit *unit = [self.searchedUnitArray objectAtIndex:indexPath.row];
        if (!unit.isPendingUnit) {
            
            unit.isPendingUnit = YES;
            [[UnitsDBManager sharedManager] updateUnit:unit];
            [self startDeficiencyReviewForUnit:unit];
        }
        
        [self.searchedUnitArray replaceObjectAtIndex:indexPath.row withObject:unit];
        [self navigateToOwnerIdentificationView:indexPath];
        
    }];
    
    [cell setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
    if (![Utility isiOSVersion7]) {
        
        [cell.contentView setBackgroundColor:indexPath.row%2? COLOR_LIGHTGRAY_CELL_APP:COLOR_OFFWHITE_CELL_APP];
    }
    
    return cell;
}


- (void )startDeficiencyReviewForUnit:(Unit *)unit{
    
    
    DeficiencyReview *defReview = [[DeficiencyReview alloc]init];
    defReview.userId = CURRENT_BUILDER_ID;
    defReview.unitId = unit.unitId;
    defReview.performedByEmail = CURRENT_BUILDER_PERFORMED_EMAIL;
    defReview.performedByName = CURRENT_BUILDER_PERFORMED_NAME;
    defReview.developerName = CURRENT_USERNAME;
    defReview.additionalComments = @"";
    defReview.reviewInitiationTimeStamp = [[DateFormatter sharedFormatter]getFullStringFromDate:[NSDate date]];
    defReview.isUploaded = NO;
    
    if (self.currentProject.serviceTypes.count) {
        
        Service *service = (Service *)[self.currentProject.serviceTypes objectAtIndex:0];
        defReview.serviceTypeId =  service.serviceTypeId;
        defReview.isPDI = !service.isConstructionView;
    }else{
        
        defReview.serviceTypeId = @"0";
        defReview.isPDI = 0;
    }
    
    defReview.possessionDate = unit.possessionDate;
    defReview.unitEnrolmentPolicy = unit.unitEnrollmentNumber;
    int reviewRowId = (int)[[DeficiencyReviewDatabase sharedDatabase]insertDeficiencyReview:defReview];
    [self fetchAndInsertReviewOwners:unit andReviewRowId:reviewRowId];
}


- (void)fetchAndInsertReviewOwners:(Unit *)unit andReviewRowId:(int)reviewRowId{
    
    NSMutableArray *owners = [[OwnerDBManager sharedManager]getAllOwnersForUnit:unit.unitId];
    
    ReviewOwnerDatabase *reviewOwnerDB = [ReviewOwnerDatabase sharedDatabase];
    for (Owner *owner in owners) {
        
        ReviewOwner *reviewOwner = [[ReviewOwner alloc]init];
        reviewOwner.ownerRowId = owner.ownerRowId;
        reviewOwner.printName = [NSString stringWithFormat:@"%@ %@", owner.firstName, owner.lastName];
        reviewOwner.ownerSignature = @"";
        reviewOwner.isSelectedOwner =  YES;
        reviewOwner.reviewRowId = reviewRowId;
        
        //12-sept-2014
        reviewOwner.userName = owner.userName;
        reviewOwner.email = owner.email;
        
        [reviewOwnerDB insertIntoReviewOwnerTable:reviewOwner];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Unit *unit = [_searchedUnitArray objectAtIndex:indexPath.row];
    CGFloat maxHeight = [ServiceReviewCell maxHeightOfCell:unit.address];
    return maxHeight>CELL_HEIGHT?maxHeight:CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - SEARCH BAR METHODS

// Will be called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}


// will be called when text has been changed
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _searchedUnitArray = [self arrayUsingSets:[self refineSearchResults:addressSearchBar.text isUnitId:NO] andArray:[self refineSearchResults:unitSearchBar.text isUnitId:YES]];
    _searchedUnitArray = [[self sortSearchedArray] mutableCopy];
    [self reloadData];
}


- (NSArray *)sortSearchedArray{
    
    return [_searchedUnitArray sortedArrayUsingComparator:^(Unit *firstObject, Unit *secondObject) {
        NSString *first = [firstObject address];
        NSString *second = [secondObject address];
        
        NSComparisonResult result =  [first compare:second];
        
        if (result == NSOrderedSame) {
            
            return [[firstObject unitNumber] compare:[secondObject unitNumber] options:NSRegularExpressionSearch];
        }
        
        return [first compare:second options:NSRegularExpressionSearch];
    }];

}

// Will return the commong items in two different array;
-(NSMutableArray *)arrayUsingSets:(NSMutableArray *)arr1 andArray:(NSMutableArray *)arr2
{
    
    NSMutableSet *set1 = [NSMutableSet setWithArray: arr1];
    NSSet *set2 = [NSSet setWithArray: arr2];
    [set1 intersectSet: set2];
    return [[set1 allObjects] mutableCopy];
}


// Will be called when search button is clicked
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
    [self reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    [searchBar setText:@""];
    [searchBar endEditing:YES];
}


// Will return the list of all items that matches to search string.
- (NSMutableArray *)refineSearchResults:(NSString *)searchString isUnitId:(BOOL)isUnitId{
    
    [_searchedUnitArray removeAllObjects];
    NSMutableArray *helpArray = [NSMutableArray new];
    
    if (!searchString.length) {
        
        [helpArray addObjectsFromArray:_allUnitsArray];
        return helpArray;
    }
    for(int i=0;i<[_allUnitsArray count];i++)
    {
        
        Unit *unit = [_allUnitsArray objectAtIndex:i];
        NSString *sTemp= isUnitId?unit.unitNumber:unit.address;
        NSRange titleResultsRange = [sTemp rangeOfString:searchString options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
        {
            
            [helpArray addObject:[_allUnitsArray objectAtIndex:i]];
        }
    }
    
    return helpArray;
}

// If an unit is tapped, user will be navigation to ownerIdentification or Identification page.
- (void)navigateToOwnerIdentificationView:(NSIndexPath *)indexPath{
    
    OwnerIdentificationViewController *ownerController = [[OwnerIdentificationViewController alloc]initWithNibName:OWNER_IDENTIFICATION_NIB bundle:nil];
    
    ServiceReviewViewController *serviceReviewViewController = (ServiceReviewViewController *)self.controller;
    Unit *unit = [_searchedUnitArray objectAtIndex:indexPath.row];
    [ownerController setCurrentUnit:unit];
    [ownerController setCurrentProject:self.currentProject];
    
    DeficiencyReview *deficiencyReview = [[DeficiencyReviewDatabase sharedDatabase] getDeficiencyReviewForUnit:unit.unitId];
    [ownerController setDeficiencyReview:deficiencyReview];
    [serviceReviewViewController.navigationController pushViewController:ownerController animated:deficiencyReview.lastPageNumber>0?NO:YES];
}



@end
