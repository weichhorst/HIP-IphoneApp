//
//  BuilderProjectViewController.h
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"


@interface BuilderProjectViewController : BaseViewController{
    
    __weak IBOutlet UIScrollView *projectScrollView;
    
    
    __weak IBOutlet UILabel *lblDashBoard;
    
    __weak IBOutlet UIButton *logoutButton;
    
    __weak IBOutlet UIButton *refreshButton;
    
}

@property (nonatomic, retain)NSMutableArray *builderProjectArray;

-(IBAction)logoutButtonClicked:(UIButton *)sender;

-(IBAction)refreshButtonClicked:(UIButton *)sender;

@end
