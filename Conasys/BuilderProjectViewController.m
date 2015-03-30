//
//  BuilderProjectViewController.m
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BuilderProjectViewController.h"
#import "BuilderProjectsDatabase.h"
#import "Service.h"
#import "CustomViewHeader.h"
#import "BuilderProjectsDatabase.h"
#import "ServiceReviewViewController.h"
#import "ProjectDataBase.h"
#import "DBHeaderFiles.h"
#import "BuilderUser.h"

#define BUTTON_WIDTH 229
#define BUTTON_HEIGHT 280
#define START_X 0
#define START_Y -10
#define SCROLL_OS6_START_Y 100

#define SERVICE_NIB_NAME @"ServiceReviewViewController"
#define PROJECT_TILE_NIB_NAME @"BuilderProjectTileView"


@interface BuilderProjectViewController ()

@end

@implementation BuilderProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self localizeObjects];
    self.builderProjectArray = [[NSMutableArray alloc]init];
    [self fetchAllProjectsFromServer];
    
}

- (void)localizeObjects{
    
    [lblDashBoard setText:NSLocalizedString(@"Builder_Project_Dashboard", @"")];
    [lblDashBoard setFont:[UIFont semiBoldWithSize:22.0f]];
    [logoutButton.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    [refreshButton.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    [logoutButton.titleLabel setText:NSLocalizedString(@"Builder_Project_Logout", @"")];
    [refreshButton.titleLabel setText:NSLocalizedString(@"Builder_Project_Refresh", @"")];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self addBottomBar];
    [appBottomView enterLastSyncDate];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}


// Method will be called at the load of view.
// This will fetch all data at once.
/*
- (void)deleteObsoleteProjects:(NSMutableArray *)newProjects{
    
    
    NSMutableArray *allOldProjects = [[ProjectDBManager sharedManager]getAllProjectsForUser:CURRENT_BUILDER_ID];
    

    for (Project *oldProject in allOldProjects) {
        
        if (![self projectExistInNewOne:newProjects oldProject:oldProject]) {
            
            [[ProjectDBManager sharedManager] deleteProject:oldProject];
        }
    }
    
    [[ProjectDBManager sharedManager] deleteOldForNewProjectForUser:CURRENT_BUILDER_ID]; // it will delete the older project from DB so Newer can be inserted.
}

*/

- (void)deleteObsoleteProjects:(NSMutableArray *)newProjects{
    
    
//    NSMutableArray *allOldProjects = [[ProjectDBManager sharedManager]getAllProjectsForUser:CURRENT_BUILDER_ID];
//
	  NSMutableArray *allOldProjects = [[ProjectDataBase sharedDatabase] getAllProjects];
//
//  	NSMutableArray * AllOldProjectID =  [[NSMutableArray alloc]init];
  	NSMutableArray * AllNewProjectID =  [[NSMutableArray alloc]init];
//
//		for (Project *Project in allOldProjects) {
//			[AllOldProjectID addObject:Project.projectId];
//		}
//	
		for (Project *Project in newProjects) {
			[AllNewProjectID addObject:Project.projectId];
		}
	
	
    for (Project *oldProject in allOldProjects) {
        
//        if (![self projectExistInNewOne:newProjects oldProject:oldProject]) {
//			if ([AllNewProjectID containsObject:oldProject.projectId]) {

           [[ProjectDBManager sharedManager] deleteProject:oldProject];
			
    }

	
    [[ProjectDBManager sharedManager] deleteOldForNewProjectForUser:CURRENT_BUILDER_ID]; // it will delete the older project from DB so Newer can be inserted.
}

- (void)deleOldProjectsForCurrentUser:(NSMutableArray*)arrayNewProjects{
	[[BuilderProjectsDatabase sharedDatabase]deleteOldProjectForBuilder:CURRENT_BUILDER_ID];
	for (Project  *project in arrayNewProjects) {
		[[ProjectDataBase sharedDatabase]deleteProject:project];
	}

}




- (BOOL)projectExistInNewOne:(NSMutableArray *)newProjects oldProject:(Project *)oldProject{
	
	

    for (Project *newProject in newProjects) {
        
        if([newProject.projectId isEqualToString:oldProject.projectId]){
            
            return YES;
        }
			
    }
    return NO;
}

/*
- (void)fetchAllProjectsFromServer{
    
    
    [self showLoader:SPINNER_WAIT_TITLE];
    
    
    if ([self networkAvailable]) {
        
        ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
        
        [requestManager getAllProjectList:[NSMutableDictionary dictionaryWithObjectsAndKeys:CURRENT_USER_TOKEN, BUILDER_API_TOKEN_KEY, CURRENT_USERNAME, BUILDER_API_USERNAME_KEY, nil]  completionHandler:^(id response, NSError *error, BOOL result) {
            
            [appBottomView enterLastSyncDate];
            
            self.builderProjectArray = response;
            
            [self deleteObsoleteProjects:response];
            
            [[ProjectDBManager sharedManager] saveUserProjectsToDB:response];
            
            [self fetchProjectsFromDB];

            [self hideLoader];
            
        }];
    }
    else{
        
        [self fetchProjectsFromDB];
        [appBottomView enterLastSyncDate];
        
        if (!self.builderProjectArray.count)
        {
            
            [Utility showErrorAlert:NETWORK_ERROR_MESSAGE];
        }
        
        [self hideLoader];
    }
}
*/


- (void)fetchAllProjectsFromServer{
    
    
    [self showLoader:SPINNER_WAIT_TITLE];
    [self fetchProjectsFromDB];
    [appBottomView enterLastSyncDate];
    if (self.builderProjectArray.count) {
        
        [self hideLoader];
        return;
    }
    
    else if ([self networkAvailable])
    {
        
        ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
        
        [requestManager getAllProjectList:[NSMutableDictionary dictionaryWithObjectsAndKeys:CURRENT_USER_TOKEN, BUILDER_API_TOKEN_KEY, CURRENT_USERNAME, BUILDER_API_USERNAME_KEY, nil]  completionHandler:^(id response, NSError *error, BOOL result) {
            
            [appBottomView enterLastSyncDate];
            self.builderProjectArray = response;
  					[self deleOldProjectsForCurrentUser : response];
					  [[BuilderProjectsDatabase sharedDatabase] insertProjectsForABuilder:CURRENT_BUILDER_ID projectArray: response];
//            [self deleteObsoleteProjects:response];
            [[ProjectDBManager sharedManager] saveUserProjectsToDB:response];
            [self fetchProjectsFromDB];
            [self hideLoader];
        }];
    }
    else{
        
        [self hideLoader];
        [Utility showErrorAlert:NETWORK_ERROR_MESSAGE];
    }
}

- (void)fetchProjectsFromDB
{
    
//    self.builderProjectArray = [[ProjectDBManager sharedManager] getAllProjectsForUser:CURRENT_BUILDER_ID];
  	self.builderProjectArray = [self getProjectsForCurrentBuilder];
    [self createButtons:self.builderProjectArray];
}

- (NSMutableArray*)getProjectsForCurrentBuilder{
	
	NSMutableArray * newProjectID =[[BuilderProjectsDatabase sharedDatabase]getAllProjectsForUser:CURRENT_BUILDER_ID];
	NSMutableArray * projectArray =[[NSMutableArray alloc]init];
	for (NSString * projectID in newProjectID) {
		Project * project = [[ProjectDataBase sharedDatabase]getProjectWithId:projectID];
		[projectArray addObject:project];
	}
	return projectArray;
}


// This will create tile views for different project associated to user.
- (void)createButtons:(NSArray *)array{
    
    [projectScrollView removeAllSubviews];
    float x = START_X;
    float y= START_Y+[Utility isiOSVersion6]?10:0;
    
    int numberOfTiles = 3;
    
    float width = 768;
    
    if (![self orientationTypePortrait]) {
        
        width = 1024;
        numberOfTiles = 4;
    }
    
    float allowedSpacing = 20;//(width/numberOfTiles)-BUTTON_WIDTH;
    
    float startXPoint = 20;//allowedSpacing/2;
    
    for (int i=0; i<array.count; i++) {
        
            if (i%numberOfTiles==0) {
                
                if(i>0){
                    
                    y=y+BUTTON_HEIGHT+allowedSpacing;
                }
                
                x=startXPoint;
                
            }else {

                x=x+BUTTON_WIDTH+allowedSpacing;
            }
        
        BuilderProjectTileView * tileView = [[BuilderProjectTileView alloc]initWithFrame:CGRectMake(x, y, BUTTON_WIDTH, BUTTON_HEIGHT) andCompletionBlock:^(id data, BOOL result) {
            
            
            [self projectTileClicked:tileView andIndex:i];
        
        }];
        
        NSString *nibName = PROJECT_TILE_NIB_NAME;
        
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:tileView options:nil];
        
        UIView *viewFromXib;
        for (id currentObject in topLevelObjects)
        {
            
            if ([currentObject isKindOfClass:[UIView class]])
            {
                
                viewFromXib = (UIView*)currentObject;
                break;
            }
        }
        
        [tileView addSubview:viewFromXib];
        [tileView setDataToView:[array objectAtIndex:i]];
        [tileView setBackgroundColor:[UIColor clearColor]];
        [projectScrollView addSubview:tileView];
    }
    
    [projectScrollView setContentSize:CGSizeMake(0, y+BUTTON_WIDTH+allowedSpacing)];
    
    CGRect frame = projectScrollView.frame;
    if ([Utility isiOSVersion6]) {
        
        
        frame.origin.y = SCROLL_OS6_START_Y;
    }
    else{
        frame.origin.y = SCROLL_OS6_START_Y-20;
    }
    
    [projectScrollView setFrame:frame];
}


// This will be called when project tile is clicked. User will be navigated to a page where all units will be displayed in/as table.
- (void)projectTileClicked:(BuilderProjectTileView *)sender andIndex:(int)index{
    
    ServiceReviewViewController *serviceReviewViewController = [[ServiceReviewViewController alloc]initWithNibName:SERVICE_NIB_NAME bundle:nil];

    [serviceReviewViewController setCurrentProject:[self.builderProjectArray objectAtIndex:index]];
    
    [self.navigationController pushViewController:serviceReviewViewController animated:YES];
}


#pragma mark- Button Methods

-(IBAction)logoutButtonClicked:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)refreshButtonClicked:(UIButton *)sender{
    
    if ([self networkAvailable]) {
        
        if([[UnitsDBManager sharedManager] getAllPendingUnitsCount:CURRENT_BUILDER_ID]>0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"All the pending reviews will be lost, Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertView show];
        }
        else {
            
            [self refreshData];
        
        }
    }
    else {
        
        [self hideLoader];
        
        [self showCustomAlertWithMessage:NSLocalizedString(@"Login_Offline_User_Not_Exist_Error", @"")];
//        [Utility showErrorAlert:NETWORK_ERROR_MESSAGE];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        
        [self refreshData];
    }
}

- (void)refreshData{
    
    [self showLoader:SPINNER_REFRESH_TITLE];
    
    ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
    
    [requestManager getAllProjectList:[NSMutableDictionary dictionaryWithObjectsAndKeys:CURRENT_USER_TOKEN, BUILDER_API_TOKEN_KEY, CURRENT_USERNAME, BUILDER_API_USERNAME_KEY, nil]  completionHandler:^(id response, NSError *error, BOOL result) {
        
        [appBottomView enterLastSyncDate];
        self.builderProjectArray = response;
//      [self deleteObsoleteProjects:response];
  			[self deleOldProjectsForCurrentUser:response];
  			[[BuilderProjectsDatabase sharedDatabase] insertProjectsForABuilder:CURRENT_BUILDER_ID projectArray: response];
        [[ProjectDBManager sharedManager] saveUserProjectsToDB:response];
        [self fetchProjectsFromDB];
        [self hideLoader];
        
    }];
}

// This will relayout all subviews within self.view
-(void)viewWillLayoutSubviews{
	
    [super viewWillLayoutSubviews];
    [self createButtons:self.builderProjectArray];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
