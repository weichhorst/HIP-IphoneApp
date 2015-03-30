//
//  ServiceReviewViewController.m
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ServiceReviewViewController.h"
#import "BuilderProjectViewController.h"
#import "UnitsDBManager.h"

@interface ServiceReviewViewController ()

@end

@implementation ServiceReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// setting delegate here which are controller via table class.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [serviceTable setSearchBarDelegate:unitSearchBar];
    [serviceTable setSearchBarDelegate:addressSearchBar];
    [lblProjectName setText:[self.currentProject.projectName uppercaseString]];
    [self localizeTheObjects];
    [self setForSearchbar:unitSearchBar];
    [self setForSearchbar:addressSearchBar];
}


- (void)setTableData{
    
    self.currentProject.units = [[UnitsDBManager sharedManager] getAllUnitsForProject:self.currentProject.projectId];
    [serviceTable setCurrentProject:self.currentProject];
    [serviceTable setDelegateAndSource];
    [serviceTable setParentController:self];
}



- (void)setForSearchbar:(UISearchBar *)searchbar{
    
    if ([Utility isiOSVersion7]){
        
        NSArray *subviews = [[searchbar.subviews objectAtIndex:0] subviews];
        
        for (UIView *subview in [[subviews objectAtIndex:1] subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"_UISearchBarSearchFieldBackgroundView")]) {
                [subview removeFromSuperview];
                break;
            }
        }
        
        UITextField *textField = (UITextField *)[subviews objectAtIndex:1];
        textField.leftViewMode = UITextFieldViewModeNever;
        [textField setTextAlignment:NSTextAlignmentLeft];
        [textField setFont:[UIFont regularWithSize:13.0f]];

        CGRect frame = searchbar.frame;
        frame.size.height-=6;
        frame.origin.y+=2;
        [searchbar setFrame:frame];
        
    }
    else{
        
        NSArray *subviews = searchbar.subviews;

        for (UIView *subview in subviews) {
            
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subview removeFromSuperview];
                break;
            }
        }
        
        UITextField *textField = (UITextField *)[subviews objectAtIndex:1];
                [textField setTextAlignment:NSTextAlignmentLeft];
        textField.leftViewMode = UITextFieldViewModeNever;
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setFont:[UIFont regularWithSize:13.0f]];
        [textField setBackground:nil];
        
        [searchbar setBackgroundColor:[UIColor clearColor]];
        [textField setBackgroundColor:COLOR_BACKGROUND_APP];
        
    }
    
}

- (void)localizeTheObjects{
    
    [lblGoto setText:NSLocalizedString(@"Service_goto", @"")];
    [lblAddress setText:NSLocalizedString(@"Service_Address", @"")];
    [lblUnit setText:NSLocalizedString(@"Service_Unit", @"")];
    [lblUnitNumber setText:NSLocalizedString(@"Service_Unit_Number", @"")];
    [lblStreetAddress setText:NSLocalizedString(@"Service_Street_Address", @"")];
    [lblOwnerRegistered setText:NSLocalizedString(@"Service_Owner_Registered", @"")];
    [lblCompletionDate setText:NSLocalizedString(@"Service_Completion_Date", @"")];
    [lblPossessionDate setText:NSLocalizedString(@"Service_Possession_Date", @"")];
    [lblReviewStatus setText:NSLocalizedString(@"Service_Review_Status", @"")];
    [btnDashboard setTitle:NSLocalizedString(@"Service_Dashboard", @"") forState:UIControlStateNormal];
    [btnLogout setTitle:NSLocalizedString(@"Service_Logout", @"") forState:UIControlStateNormal];
    [unitSearchBar setPlaceholder:NSLocalizedString(@"Service_UnitSearchBar_PlaceHolder", @"")];
    [addressSearchBar setPlaceholder:NSLocalizedString(@"Service_AddressSearchBar_PlaceHolder", @"")];
    
    [lblGoto setFont:[UIFont semiBoldWithSize:15.0f]];
    [lblAddress setFont:[UIFont regularWithSize:15.0f]];
    [lblUnit setFont:[UIFont regularWithSize:15.0f]];
    [lblUnitNumber setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblStreetAddress setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblOwnerRegistered setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblCompletionDate setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblPossessionDate setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblReviewStatus setFont:[UIFont semiBoldWithSize:13.0f]];
    [btnDashboard.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    [btnLogout.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    [lblProjectName setFont:[UIFont semiBoldWithSize:25.0f]];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [self addBottomBar]; // adding the bottom tabbar displaying all data about n/w and last sync.
    [self setTableData];
    [appBottomView enterLastSyncDate];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [unitSearchBar resignFirstResponder];
    [addressSearchBar resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    [serviceTable reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end