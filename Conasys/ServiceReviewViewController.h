//
//  ServiceReviewViewController.h
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTableHeader.h"

@interface ServiceReviewViewController : BaseViewController{
    
    IBOutlet ServiceReviewTable *serviceTable;
    
    IBOutlet UISearchBar *unitSearchBar;
    IBOutlet UISearchBar *addressSearchBar;
    IBOutlet UIView *searchBarView;
    __weak IBOutlet UILabel *lblProjectName;
    
    __weak IBOutlet UILabel *lblGoto;
    __weak IBOutlet UILabel *lblAddress;
    __weak IBOutlet UILabel *lblUnit;
    __weak IBOutlet UILabel *lblUnitNumber;
    __weak IBOutlet UILabel *lblStreetAddress;
    __weak IBOutlet UILabel *lblOwnerRegistered;
    __weak IBOutlet UILabel *lblCompletionDate;
    __weak IBOutlet UILabel *lblPossessionDate;
    __weak IBOutlet UILabel *lblReviewStatus;
    
    __weak IBOutlet UIButton *btnLogout;
    __weak IBOutlet UIButton *btnDashboard;
    
}

@property (nonatomic, retain) Project *currentProject;


@end