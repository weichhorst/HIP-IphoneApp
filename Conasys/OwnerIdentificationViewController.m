//
//  OwnerIdentificationViewController.m
//  Conasys
//
//  Created by user on 5/15/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerIdentificationViewController.h"
#import "PopOverHeaderFiles.h"
#import "CustomerCareViewController.h"
#import "OwnerDBManager.h"
#import "UnitsDBManager.h"
#import "Utility.h"
#import "DeficiencyReviewDatabase.h"
#import "ReviewOwnerDatabase.h"
#import "LocationDBManager.h"


#define STATIC_OWNER_ID @"100"

#define POPOVER_HEIGHT 40
#define POPOVER_WIDTH  230


#define REGISTER_VIEW_X 0
#define REGISTER_VIEW_Y 0
#define REGISTER_VIEW_WIDTH 1024
#define REGISTER_VIEW_HEIGHT 1024


#define REGISTER_VIEW_TAG 100
#define UNIT_ENROLLMENT_VIEW_TAG 101
#define POSSESSION_DATE_VIEW_TAG 102


#define UNIT_ENROLLMENT_VIEW_X 0
#define UNIT_ENROLLMENT_VIEW_Y 0
#define UNIT_ENROLLMENT_VIEW_WIDTH 320
#define UNIT_ENROLLMENT_VIEW_HEIGHT 140


#define POSSESSION_VIEW_X 0
#define POSSESSION_VIEW_Y 0
#define POSSESSION_VIEW_WIDTH 320
#define POSSESSION_VIEW_HEIGHT 315



#define OWNER_FRAME_PORTRAIT CGRectMake(19,400-[self additions],481,177)
#define OWNER_FRAME_LANDSCAPE CGRectMake(19,400-[self additions],735,110)

#define RegisterOwner_FRAME_PORTRAIT CGRectMake(518,400-[self additions],231,44)
#define BUTTONBACK_FRAME_PORTRAIT CGRectMake(518,524,103,44)
#define BUTTONNEXT_FRAME_PORTRAIT CGRectMake(646,524,103,44)



#define RegisterOwner_FRAME_LANDSCAPE CGRectMake(775,400-[self additions],231,44)
#define BUTTONBACK_FRAME_LANDSCAPE CGRectMake(775,460,103,44)
#define BUTTONNEXT_FRAME_LANDSCAPE CGRectMake(904,460,103,44)

/////BUILDER DETAILS FOR LANDSCAPE
#define LABEL_STATIC_BUILDER_REF_FRAME_LANDSCAPE CGRectMake(10,50,200,21)
#define LABEL_BUILDER_REF_FRAME_LANDSCAPE CGRectMake(10,70,200,21)

#define LABEL_STATIC_POSSESSIONDATA_FRAME_LANDSCAPE CGRectMake(250,50,130,21)
#define LABEL_POSSESSIONDATA_FRAME_LANDSCAPE CGRectMake(250,70,130,21)
#define BUTTON_POSSESSIONDATA_FRAME_LANDSCAPE CGRectMake(355,50,103,44)

#define LABEL_STATIC_ENROLLMENT_NO_FRAME_LANDSCAPE CGRectMake(480,50,150,21)
#define LABEL_ENROLLMENT_NO_FRAME_LANDSCAPE CGRectMake(480,70,150,21)
#define BUTTON_ENROLLMENT_FRAME_LANDSCAPE CGRectMake(630,50,103,44)

#define LABEL_LEGAL_DESCRIPTION_PORTRAIT CGRectMake(10, 25 , 460, 21)

/////BUILDER DETAILS FOR PORTRAIT


#define LABEL_STATIC_BUILDER_REF_FRAME_PORTRAIT CGRectMake(10,48,150,21)
#define LABEL_BUILDER_REF_FRAME_PORTRAIT CGRectMake(10,65,460,21)

#define LABEL_STATIC_POSSESSIONDATA_FRAME_PORTRAIT CGRectMake(10,88,130,21)
#define LABEL_POSSESSIONDATA_FRAME_PORTRAIT CGRectMake(10,105,460,21)
#define BUTTON_POSSESSIONDATA_FRAME_PORTRAIT CGRectMake(164,83,30,30)

#define LABEL_STATIC_ENROLLMENT_NO_FRAME_PORTRAIT CGRectMake(10,129,150,19)
#define LABEL_ENROLLMENT_NO_FRAME_PORTRAIT CGRectMake(10,149,460,21)
#define BUTTON_ENROLLMENT_FRAME_PORTRAIT CGRectMake(164,124,30,30)

#define LABEL_LEGAL_DESCRIPTION_LANDSCAPE CGRectMake(10, 25 , 710, 21)

@interface OwnerIdentificationViewController ()

@end

@implementation OwnerIdentificationViewController

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
    
    self.currentUnit.locationList = [[LocationDBManager sharedManager] getAllLocationsForUnit:self.currentUnit.unitId];
    
    if ([Utility isiOSVersion6]) {
        
        CGRect frame = ownerIdentificationTable.frame;
        frame.origin.y+=22;
        frame.size.height-=32;
        [ownerIdentificationTable setFrame:frame];
        
        frame = ownerDetailsView.frame;
        frame.origin.y-=10;
        [ownerDetailsView setFrame:frame];
    }
    
    [self localizeTheObjects];
    [self addTheSliderView];
    [self setAndDisplayData];
    [self setDataToConstructionView];
    
    if (self.deficiencyReview.lastPageNumber) {
        
        [self btnNextClicked:nil];
    }
}

- (float)additions{
    
    if ([Utility isiOSVersion6]) {
        
        return 10;
    }
    return 0;
}


- (void)localizeTheObjects{
    
    
    [lblInReport setText:NSLocalizedString(@"Owner_In_Report", @"")];
    [lblOwnerName setText:NSLocalizedString(@"Owner_Name", @"")];
    [lblEmail setText:NSLocalizedString(@"Owner_Email", @"")];
    [lblPhone setText:NSLocalizedString(@"Owner_Phone", @"")];
    [lblEdit setText:NSLocalizedString(@"Owner_Edit", @"")];
    
    [lblPerformedByName setText:NSLocalizedString(@"Owner_Performed_Name", @"")];
    [lblPerformedByEmail setText:NSLocalizedString(@"Owner_Performed_Email", @"")];
    
    [lblStaticLegalDescription setText:NSLocalizedString(@"Owner_Legal_Description", @"")];
    [lblStaticBuilderRefNum setText:NSLocalizedString(@"Owner_Legal_Builder_RefNum", @"")];
    [lblStaticPossessionDate setText:NSLocalizedString(@"Owner_Possession_Date", @"")];
    [lblStaticEnrollmentNumber setText:NSLocalizedString(@"Owner_Enrollment_Number", @"")];
    [btnViewAllUnits setTitle:NSLocalizedString(@"Owner_View_All_Units", @"") forState:UIControlStateNormal];
    
    [viewTableHeader setBackgroundColor:[self.view backgroundColor]];

    [self setFonts];
         
}

- (void)setFonts{
    
    
    [lblInReport setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblOwnerName setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblEmail setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblPhone setFont:[UIFont semiBoldWithSize:13.0f]];
    [lblEdit setFont:[UIFont semiBoldWithSize:13.0f]];
    
    [lblViewName setFont:[UIFont semiBoldWithSize:15.0f]];
    
    [textViewUnitAddress setFont:[UIFont regularWithSize:14.0f]];
    
    [btnViewAllUnits.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    
    [lblPerformedByEmail setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblPerformedByName setFont:[UIFont semiBoldWithSize:14.0f]];
    
    [textFieldPerformedEmail setFont:[UIFont regularWithSize:14.0f]];
    [textFieldPerformedName setFont:[UIFont regularWithSize:14.0f]];
    
    [constBackButton.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [constNextButton.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    
    [btnBack.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [btnNext.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    
    [lblStaticBuilderRefNum setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblStaticEnrollmentNumber setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblStaticLegalDescription setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblStaticPossessionDate setFont:[UIFont semiBoldWithSize:12.0f]];
    
    [lblBuilderRefNum setFont:[UIFont regularWithSize:12.0f]];
    [lblEnrollmentNumber setFont:[UIFont regularWithSize:12.0f]];
    [lblLegalDescription setFont:[UIFont regularWithSize:12.0f]];
    [lblPossessionData setFont:[UIFont regularWithSize:12.0f]];
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setDataToConstructionView];
    [self addBottomBar];
    [appBottomView enterLastSyncDate];
    
     //[self addViewSelectionPopOver];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}


- (void)setAndDisplayData{
    
    [lblPossessionData setText:self.deficiencyReview.possessionDate];
    
    [lblEnrollmentNumber setText:self.deficiencyReview.unitEnrolmentPolicy];
    
    [stepSliderView selectStep:1];
    
    [self setForTableData];
    
    if (self.currentProject.serviceTypes.count) {
        
        [self manageViewsForService:[self.currentProject.serviceTypes objectAtIndex:self.deficiencyReview.selectedServiceTypeIndex]];
    }
    
    [lblBuilderRefNum setText:self.currentProject.builderRefNum];
    
    [lblLegalDescription setText:self.currentUnit.unitLegalDes];
    
    [textViewUnitAddress setText:[NSString stringWithFormat:@"%@ - %@", self.currentUnit.unitNumber, self.currentUnit.address]];
}


// setting table data here to class OwnerIdentificationTable where all methods of tableveiw is being handled.
- (void)setForTableData{
    
    [ownerIdentificationTable setCurrentDeficiencyReview:self.deficiencyReview];
    [ownerIdentificationTable setParentController:self];
    [ownerIdentificationTable setDelegateAndSource];
}

// Setting construction view data here.
- (void)setDataToConstructionView{
    
    [textFieldPerformedName setText:self.deficiencyReview.performedByName];
    [textFieldPerformedEmail setText:self.deficiencyReview.performedByEmail];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// adding view selection popover. where user can select for PDI and Construction View.

-(void)addViewSelectionPopOver
{
    
    //[DELEGATE setPopOverMargin:btnServiceDropDown.frame.size.width/2 - 20];
    
    //ViewSelectionPopOverController *viewSelectionPopOverController=[[ViewSelectionPopOverController alloc]initWithCompletionBlock:^(id data, NSIndexPath *indexPath, BOOL result) {
        
//        [locationPopOver dismissPopoverAnimated:YES];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"NO"];
//        
//        AppDelegate *delegate = DELEGATE;
//        delegate.lockOrientation = NO;
//        
//        Location *location = (Location *)[self.currentUnit.locationList objectAtIndex:indexPath.row];
//        
//        if (![self.currentReviewItem.itemLocation isEqualToString:location.locationName]) {
//            
//            
//            self.currentReviewItem.itemLocationRowId = location.locationRowId;
//            self.currentReviewItem.itemLocation = location.locationName;
//            self.currentReviewItem.itemProduct = MISC;
//            self.currentReviewItem.itemProductRowId = 0;
//            self.currentReviewItem.productId = @"-1";
//            
//            if([location.locationName isEqualToString:SELECT_LOCATION]){
//                
//                self.currentReviewItem.itemLocationRowId = 0;
//                self.currentReviewItem.itemLocation = SELECT_LOCATION;
//                self.currentReviewItem.itemProduct = SELECT_PRODUCT;
//                self.currentReviewItem.productId = @"0";
//            }
//            
//            [self updateTheChanges:self.currentReviewItem];
//        }
//        
   // }];
    
    //[viewSelectionPopOverController setCurrentProject:self.currentProject];
    
//    viewSelectionPopOver=[[SYPopoverController alloc]initWithContentViewController:viewSelectionPopOverController andTintColor:COLOR_SERVICE_POPOVER];
//
//    //    locationPopOver = [[UIPopoverController alloc]initWithContentViewController:locationPopOverViewController];
//    
//    float multiplier = self.currentProject.serviceTypes.count>5?5:self.currentProject.serviceTypes.count;
//    
//    viewSelectionPopOver.popoverContentSize = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT*multiplier-1);
//    
//    viewSelectionPopOver.delegate=self;
    
   
//    
//    
//    
//    
//
    [DELEGATE setPopOverMargin:btnServiceDropDown.frame.size.width/2 - 20];
    
    ViewSelectionPopOverController *ownerIdendificationViewController=[[ViewSelectionPopOverController alloc]initWithCompletionBlock:^(id data, NSIndexPath *indexPath, BOOL result) {
        
        [viewSelectionPopOver dismissPopoverAnimated:YES];
        
        Service *service = (Service *)data;
        [self manageViewsForService:service];
        
        self.deficiencyReview.selectedServiceTypeIndex = indexPath.row;
        self.deficiencyReview.serviceTypeId = service.serviceTypeId;
        self.deficiencyReview.isPDI = !service.isConstructionView;
        
        [self updateDeficiencyReview:self.deficiencyReview];
    }];
    

    [ownerIdendificationViewController setCurrentProject:self.currentProject];
    
    viewSelectionPopOver=[[SYPopoverController alloc]initWithContentViewController:ownerIdendificationViewController andTintColor:COLOR_SERVICE_POPOVER];
    
    viewSelectionPopOver.arrowMarginPosition = 100;
    

    float multiplier = self.currentProject.serviceTypes.count>5?5:self.currentProject.serviceTypes.count;
    viewSelectionPopOver.popoverContentSize = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT*multiplier-1);
    
    if ([Utility isiOSVersion7]) {

        [viewSelectionPopOver setBackgroundColor:COLOR_BLUE_APP];

    }
    viewSelectionPopOver.delegate=self;
    
}
+ (BOOL)wantsDefaultContentAppearance{
    
    return NO;
}

// View is changing for different service type. selection of PDI or Construction View.
- (void)manageViewsForService:(Service *)service{
    
    [lblViewName setText:[service name]];
    
    if ([service isConstructionView]) {
        
        [pdiView setHidden:YES];
        [constructionView setHidden:NO];
    }
    else{
        
        [pdiView setHidden:NO];
        [constructionView setHidden:YES];
    }
    
    [self changedTitle:![service isConstructionView]];
}


#pragma mark - Button Methods

- (IBAction)btnViewSelectionClicked:(UIButton *)sender{
    
    [self addViewSelectionPopOver];
    [viewSelectionPopOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (IBAction)btnNextClicked:(UIButton *)sender{
    
    Service *service = [self.currentProject.serviceTypes objectAtIndex:self.deficiencyReview.selectedServiceTypeIndex];
    
    BOOL animation = self.deficiencyReview.lastPageNumber>1?NO:YES;
    
    if (animation) {
        
        if (!self.deficiencyReview.reviewOwners.count && !service.isConstructionView) {
            
            [self showCustomAlertWithMessage:NSLocalizedString(@"Owner_Identification_NoOwner_Registered", @"")];
            
            return;
        }
        
        if (![self hasOwner] && !service.isConstructionView) {
            
            [self showCustomAlertWithMessage:NSLocalizedString(@"Owner_Identification_NoOwner_Message", @"")];
            
            return;
        }
        else if(service.isConstructionView && (!textFieldPerformedName.text.length || !textFieldPerformedEmail.text.length)){
            
            
            [self showCustomAlertWithMessage:NSLocalizedString(@"Owner_Identification_NoEmailPassword_Message", @"")];
            
            return;
        }
        else if (![Utility validateEmail:textFieldPerformedEmail.text] && service.isConstructionView){
            
            [self showCustomAlertWithMessage:NSLocalizedString(@"Owner_Identification_InValid_Email_Message", @"")];
            
            return;
        }
        
    }
    
    
    if (animation) {
        
        self.deficiencyReview.ownerNextTimeStamp = [[DateFormatter sharedFormatter]getFullStringFromDate:[NSDate date]];
        
        [[DeficiencyReviewDatabase sharedDatabase] updateDeficiencyReview:self.deficiencyReview];
    }
    
    CustomerCareViewController *customerCareViewController = [[CustomerCareViewController alloc]initWithNibName:@"CustomerCareViewController" bundle:nil];
    [customerCareViewController setCurrentUnit:self.currentUnit];
    [customerCareViewController setCurrentProject:self.currentProject];
    [customerCareViewController setCurrentDeficiencyReview:self.deficiencyReview];
    [self.navigationController pushViewController:customerCareViewController animated:animation];
}


- (IBAction)btnPreviousClicked:(UIButton *)sender{
    
    [stepSliderView selectStep:1];
}



#pragma mark - OWNER Methods
// Will be called when Register owner button is clicked. It will open a view where user can register an owner.
- (IBAction)btnRegisterOwnerClicked:(UIButton *)sender{
    
    [self.view setUserInteractionEnabled:NO];
    [self performSelector:@selector(enableView) withObject:nil afterDelay:0.5];
    
    //12-sept-2014
//    [self performSelector:@selector(enableOwner:) withObject:nil afterDelay:0.5];
    
//    if (!isConnected) {
//        
//        [self showCustomAlertWithMessage:NSLocalizedString(@"Register_Owner_Network_Error", @"")];
//        
//        return;
//    }
    
    RegisterOwnerView *registerOwnerView = [[RegisterOwnerView alloc]initWithFrame:CGRectMake(REGISTER_VIEW_X, REGISTER_VIEW_Y, REGISTER_VIEW_WIDTH, REGISTER_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide) {
        
        if (shouldHide) {
            
            [modalView hide];
            modalView = nil;
            
            if (buttonTag) {
                
                [self registerOwner:data];
            }
        }
        
    }];
    
    NSString *nibName = @"RegisterOwnerView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:registerOwnerView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [registerOwnerView setTag:REGISTER_VIEW_TAG];
    [registerOwnerView addSubview:viewFromXib];
    [registerOwnerView setCenter:self.view.center];
    [registerOwnerView addLeftLabelsForTextFields];
    
    modalView = [[RNBlurModalView alloc]initWithViewController:self view:registerOwnerView];
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay-0.25.png"]]];
    [modalView show];
    
//    [self.view addSubview:registerOwnerView];
}


// Registering owner to server.
- (void)registerOwner:(NSMutableDictionary *)infoDict{
    
    [infoDict setValue:self.deficiencyReview.unitId forKey:@"UnitId"];

    if (isConnected)
    {
       
        [infoDict setValue:@"true" forKey:@"IsOnline"];
        [self showLoader:SPINNER_WAIT_TITLE];
        
        ConasysRequestManager *conasysRequestManager = [ConasysRequestManager sharedConasysRequestManager];
        
        [conasysRequestManager registerOwnerWithDetails:infoDict completionHandler:^(id response, NSError *error, BOOL result) {
            
            
            [self hideLoader];
            
            if(result){

                [infoDict setObject:[NSString stringWithFormat:@"%@", [response objectForKey:@"ResultData"]] forKey:@"registerOwnerId"];
                [infoDict setValue:@"0" forKey:@"isEdited"];
                [infoDict setValue:@"0" forKey:@"isNewOwner"];
                [self saveEntryToDB:infoDict];
            }
            else{
                
                [self showCustomAlertWithMessage:[[response objectForKey:@"ResultMessage"] objectForKey:@"Message"]];
            }

        }];
    }
    else{
       
        
        [infoDict setObject:STATIC_OWNER_ID forKey:@"registerOwnerId"];
        [infoDict setObject:@"0" forKey:@"isEdited"];
        [infoDict setObject:@"1" forKey:@"isNewOwner"];
        [self saveEntryToDB:infoDict];
    }
}


//
// Once user is registered, it will be saved to DB.
- (void)saveEntryToDB:(NSMutableDictionary *)dict{
    
    
    OwnerDBManager *ownerDBManager = [OwnerDBManager sharedManager];
    
    Owner *owner = [[Owner alloc]init];
    owner.userName = [dict objectForKey:REGISTER_OWNER_USERNAME];
    owner.firstName = [dict objectForKey:REGISTER_OWNER_FIRSTNAME];
    owner.lastName = [dict objectForKey:REGISTER_OWNER_LASTNAME];
    owner.email = [dict objectForKey:REGISTER_OWNER_EMAIL];
    owner.phoneNumber = [dict objectForKey:REGISTER_OWNER_PHONE_NUMBER];
    owner.enableEmailNotification = [[dict objectForKey:REGISTER_OWNER_EMAIL_PERMISSION] isEqualToString:@"true"]?@"1":@"0";
    owner.unitId = self.deficiencyReview.unitId;
    owner.ownerId = [dict objectForKey:@"registerOwnerId"];
    
    //12-sept-2014
    owner.isEdited = [[dict objectForKey:@"isEdited"] intValue];
    owner.isNewOwner = [[dict objectForKey:@"isNewOwner"] intValue];
    owner.password = [dict objectForKey:REGISTER_OWNER_PASSWORD];
    owner.builderName = [dict objectForKey:REGISTER_OWNER_BUILDER_USERNAME];
    owner.builderToken = [dict objectForKey:REGISTER_OWNER_TOKEN];
    
    
    [ownerDBManager saveOwnerToDB:[NSMutableArray arrayWithObjects:owner,nil]];

    
    Owner *lastOwner = (Owner *)[[OwnerDBManager sharedManager]lastInsertedOwner];
    
    owner.ownerRowId = lastOwner.ownerRowId;
    
        ReviewOwner *reviewOwner = [[ReviewOwner alloc]init];
        
        reviewOwner.ownerRowId = owner.ownerRowId;
        reviewOwner.printName = [NSString stringWithFormat:@"%@ %@", owner.firstName, owner.lastName];
        reviewOwner.ownerSignature = @"";
        reviewOwner.isSelectedOwner =  YES;
        reviewOwner.reviewRowId = self.deficiencyReview.reviewRowId;
        reviewOwner.owner = owner;
        reviewOwner.ownerRowId = lastOwner.ownerRowId;
    
    //12-sept-2014
    reviewOwner.userName = lastOwner.userName;
    reviewOwner.email = lastOwner.email;
    
    [[ReviewOwnerDatabase sharedDatabase] insertIntoReviewOwnerTable:reviewOwner];
    
    [self.deficiencyReview.reviewOwners addObject:reviewOwner];
    
    [self setForTableData];
}


#pragma mark - Button Methods
// Buttons allow user to PopUp a view where user can select for UnitEnrollment number.
- (IBAction)btnUnitEnrollmentClicked:(UIButton *)sender{
    
    
    [self.view setUserInteractionEnabled:NO];
    [self performSelector:@selector(enableView) withObject:nil afterDelay:0.5];
    
    UnitEnrollmentView *unitEnrollmentView = [[UnitEnrollmentView alloc]initWithFrame:CGRectMake(UNIT_ENROLLMENT_VIEW_X, UNIT_ENROLLMENT_VIEW_Y, UNIT_ENROLLMENT_VIEW_WIDTH, UNIT_ENROLLMENT_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide) {
        
        
        [modalView hide];
        modalView = nil;
        
        if (buttonTag) {

            [lblEnrollmentNumber setText:data];
            self.deficiencyReview.unitEnrolmentPolicy = data;
            self.currentUnit.unitEnrollmentNumber = data;
            [[UnitsDBManager sharedManager]updateUnit:self.currentUnit];

            [self updateDeficiencyReview:self.deficiencyReview];
        }
        
    }];
    
    NSString *nibName = @"UnitEnrollmentView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:unitEnrollmentView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [unitEnrollmentView setTag:UNIT_ENROLLMENT_VIEW_TAG];
    [unitEnrollmentView addSubview:viewFromXib];
    CGPoint center = self.view.center;
    center.y = center.y-100;
    
    [unitEnrollmentView setEnrollmentNumber:self.deficiencyReview.unitEnrolmentPolicy];
    
    modalView = [[RNBlurModalView alloc]initWithViewController:self view:unitEnrollmentView];
    [unitEnrollmentView setCenter:center];
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay-0.25.png"]]];
    [modalView show];
    
}

- (void)enableView{
    
    [self.view setUserInteractionEnabled:YES];
}

// Buttons allow user to PopUp a view where user can select for possession date.
- (IBAction)btnPossessionDateClicked:(UIButton *)sender{
    
    [self.view setUserInteractionEnabled:NO];
    [self performSelector:@selector(enableView) withObject:nil afterDelay:0.5];
    
//    float height  = [Utility isiOSVersion7]?POSSESSION_VIEW_HEIGHT;
    PossessionDateView *possessionDateView = [[PossessionDateView alloc]initWithFrame:CGRectMake(POSSESSION_VIEW_X, POSSESSION_VIEW_Y, POSSESSION_VIEW_WIDTH, POSSESSION_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide) {
        
        [modalView hide];
        modalView = nil;
        if (buttonTag) {
            
            [lblPossessionData setText:data];
            self.currentUnit.possessionDate = data;
            [[UnitsDBManager sharedManager]updateUnit:self.currentUnit];

            self.deficiencyReview.possessionDate = data;
            [self updateDeficiencyReview:self.deficiencyReview];
        }
        
    }];
    
    NSString *nibName = @"PossessionDateView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:possessionDateView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [possessionDateView setTag:POSSESSION_DATE_VIEW_TAG];
    [possessionDateView addSubview:viewFromXib];
    [possessionDateView setCenter:self.view.center];
    [possessionDateView setCurrentDate:self.deficiencyReview.possessionDate];
    [possessionDateView addNotificationToDatePicker];
    
    modalView = [[RNBlurModalView alloc]initWithViewController:self view:possessionDateView];
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay-0.25.png"]]];
    [modalView show];
    
}

// will be called when screen rotates


- (void)updateOwner:(NSMutableDictionary *)dict withCompletionHandler:(void (^)(id response,BOOL hasInternet, BOOL result))block{
    
    
    if (isConnected) {
        
        [self showLoader:SPINNER_WAIT_TITLE];
        ConasysRequestManager *conasysRequestManager = [ConasysRequestManager sharedConasysRequestManager];
        
        [conasysRequestManager editOwnerWithDetails:dict completionHandler:^(id response, NSError *error, BOOL result) {
            
            if (!result) {
                
                [self showCustomAlertWithMessage:[[response objectForKey:@"ResultMessage"] objectForKey:@"Message"]];
                
                block(nil, YES, NO);
            }
            else{
                
                block(dict, YES, YES);
            }
            
            [self hideLoader];
        }];

    }
    else{
        
        block(nil, NO, NO);
    }
}

#pragma mark - Method overloading
- (void)upTheView:(UIView *)editingView{
    
    
}

- (void)downTheView:(UIView *)editingView{
    
    
    self.deficiencyReview.performedByEmail = textFieldPerformedEmail.text;
    self.deficiencyReview.performedByName = textFieldPerformedName.text;
    [self updateDeficiencyReview:self.deficiencyReview];
}


#pragma mark -DB Update
// Updated Database here for Deficiency Review that has been updated.
- (void)updateDeficiencyReview:(DeficiencyReview *)deficiencyReview{
    
    [[DeficiencyReviewDatabase sharedDatabase]updateDeficiencyReview:deficiencyReview];
}


- (IBAction)backButtonClicked:(UIButton *)sender{
    
    self.deficiencyReview.lastPageNumber = 0;
    [self updateDeficiencyReview:self.deficiencyReview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)hasOwner{
    
    for (ReviewOwner *reviewOwner in self.deficiencyReview.reviewOwners) {
        
        if (reviewOwner.isSelectedOwner) {
            
            return YES;
        }
    }
    
    return NO;
}


-(void)setframes
{
   
    int deduction = 0;
    
    if ([self orientationTypePortrait])
    {
        
        [ownerDetailsView setFrame:OWNER_FRAME_PORTRAIT];
        [btnRegisterOwner setFrame:RegisterOwner_FRAME_PORTRAIT];
        [btnBack setFrame:BUTTONBACK_FRAME_PORTRAIT];
        [btnNext setFrame:BUTTONNEXT_FRAME_PORTRAIT];
        [lblStaticBuilderRefNum setFrame:ownerDetailsView.frame];
        
        
        [lblStaticBuilderRefNum setFrame:LABEL_STATIC_BUILDER_REF_FRAME_PORTRAIT];
        [lblBuilderRefNum setFrame:LABEL_BUILDER_REF_FRAME_PORTRAIT];
        [lblStaticPossessionDate setFrame:LABEL_STATIC_POSSESSIONDATA_FRAME_PORTRAIT];
        [lblPossessionData setFrame:LABEL_POSSESSIONDATA_FRAME_PORTRAIT];
        [lblStaticEnrollmentNumber setFrame:LABEL_STATIC_ENROLLMENT_NO_FRAME_PORTRAIT];
        [lblEnrollmentNumber setFrame:LABEL_ENROLLMENT_NO_FRAME_PORTRAIT];
        
        [btnPossessionDate setFrame:BUTTON_POSSESSIONDATA_FRAME_PORTRAIT];
        [btnEnrollment setFrame:BUTTON_ENROLLMENT_FRAME_PORTRAIT];
        
        [lblLegalDescription setFrame:LABEL_LEGAL_DESCRIPTION_PORTRAIT];
        deduction = 1;
        
    }
    else {
        
        [ownerDetailsView setFrame:OWNER_FRAME_LANDSCAPE];
        [btnRegisterOwner setFrame:RegisterOwner_FRAME_LANDSCAPE];
        [btnBack setFrame:BUTTONBACK_FRAME_LANDSCAPE];
        [btnNext setFrame:BUTTONNEXT_FRAME_LANDSCAPE];
        
        [lblStaticBuilderRefNum setFrame:LABEL_STATIC_BUILDER_REF_FRAME_LANDSCAPE];
        [lblBuilderRefNum setFrame:LABEL_BUILDER_REF_FRAME_LANDSCAPE];
        
        [lblStaticPossessionDate setFrame:LABEL_STATIC_POSSESSIONDATA_FRAME_LANDSCAPE];
        [lblPossessionData setFrame:LABEL_POSSESSIONDATA_FRAME_LANDSCAPE];
        
        [lblStaticEnrollmentNumber setFrame:LABEL_STATIC_ENROLLMENT_NO_FRAME_LANDSCAPE];
        [lblEnrollmentNumber setFrame:LABEL_ENROLLMENT_NO_FRAME_LANDSCAPE];
        
        [btnPossessionDate setFrame:BUTTON_POSSESSIONDATA_FRAME_LANDSCAPE];
        [btnEnrollment setFrame:BUTTON_ENROLLMENT_FRAME_LANDSCAPE];
        
        [lblLegalDescription setFrame:LABEL_LEGAL_DESCRIPTION_LANDSCAPE];
    }
    
    [self reframeObjects];
    
    CGRect frame = btnPossessionDate.frame;
    frame.origin.y = lblStaticPossessionDate.frame.origin.y-5;
    [btnPossessionDate setFrame:frame];
    
    frame = btnEnrollment.frame;
    frame.origin.y = lblStaticEnrollmentNumber.frame.origin.y-6-deduction;
    [btnEnrollment setFrame:frame];
    
    frame = btnBack.frame;
    frame.origin.y = ownerDetailsView.frame.origin.y + ownerDetailsView.frame.size.height-frame.size.height;
    [btnBack setFrame:frame];
    
    frame = btnNext.frame;
    frame.origin.y = btnBack.frame.origin.y;
    [btnNext setFrame:frame];
    
}

- (void)reframeObjects{
    
    [lblLegalDescription setText:self.currentUnit.unitLegalDes];

    if (lblLegalDescription.text.length) {

        [lblLegalDescription sizeToFit];
    }else{
        
        [lblStaticLegalDescription setFrame:CGRectMake(0, 0, 0, 0)];
        [lblStaticLegalDescription setText:@""];
        [lblLegalDescription setFrame:CGRectMake(0, 0, 0, 0)];
        [lblLegalDescription setText:@""];
    }
    
    [lblBuilderRefNum setText:self.currentProject.builderRefNum];
    
    if (lblBuilderRefNum.text.length) {
        [lblBuilderRefNum sizeToFit];
    }
    else{
        
        [lblStaticBuilderRefNum setFrame:CGRectMake(0, 0, 0, 0)];
        [lblStaticBuilderRefNum setText:@""];
        [lblBuilderRefNum setFrame:CGRectMake(0, 0, 0, 0)];
        [lblBuilderRefNum setText:@""];
    }

    [lblPossessionData setText:self.deficiencyReview.possessionDate];
    
    if (lblPossessionData.text.length) {
        [lblPossessionData sizeToFit];
    }
    
    [lblEnrollmentNumber setText:self.deficiencyReview.unitEnrolmentPolicy];
    
    if (lblEnrollmentNumber.text.length) {
        [lblEnrollmentNumber sizeToFit];
    }
    
    [self orientationTypePortrait]?[self setForPortrait]:[self setForLandscape];
}

- (void)setForPortrait{
    
    
    CGRect frame = lblStaticBuilderRefNum.frame;
    frame.origin.y = lblLegalDescription.frame.origin.y+lblLegalDescription.frame.size.height+5;
    
    
    [lblStaticBuilderRefNum setFrame:frame];
    

    frame = lblBuilderRefNum.frame;
    frame.origin.y = lblStaticBuilderRefNum.frame.origin.y + lblStaticBuilderRefNum.frame.size.height;
    [lblBuilderRefNum setFrame:frame];
    
    
    frame = lblStaticPossessionDate.frame;
    frame.origin.y = lblBuilderRefNum.frame.origin.y+lblBuilderRefNum.frame.size.height;
    [lblStaticPossessionDate setFrame:frame];
    
    
    frame = lblPossessionData.frame;
    frame.origin.y = lblStaticPossessionDate.frame.origin.y+lblStaticPossessionDate.frame.size.height;
    [lblPossessionData setFrame:frame];
    
    frame = lblStaticEnrollmentNumber.frame;
    frame.origin.y = lblPossessionData.frame.origin.y+lblPossessionData.frame.size.height+7;
    [lblStaticEnrollmentNumber setFrame:frame];
    
    
    frame = lblEnrollmentNumber.frame;
    frame.origin.y = lblStaticEnrollmentNumber.frame.origin.y+lblStaticEnrollmentNumber.frame.size.height;
    [lblEnrollmentNumber setFrame:frame];
    
    frame = [ownerDetailsView frame];
    frame.size.height =  lblEnrollmentNumber.frame.origin.y+lblEnrollmentNumber.frame.size.height +15;
    
    [ownerDetailsView setFrame:frame];
}

- (void)setForLandscape{
    
    CGRect frame = lblLegalDescription.frame;
    
    if (frame.size.height<21 && lblLegalDescription.text.length) {
    
        frame.size.height = 21;
    }
    [lblLegalDescription setFrame:frame];
    
    int yAxis = frame.origin.y + frame.size.height + 8;
    

    NSArray *subViewsArray = [NSArray arrayWithObjects:lblStaticBuilderRefNum, lblStaticPossessionDate, lblStaticEnrollmentNumber, nil];
    
    for (UILabel *lbl in subViewsArray) {
        
        frame = [lbl frame];
        frame.origin.y =  yAxis;
        [lbl setFrame:frame];
    }
    
    frame= lblBuilderRefNum.frame;
    frame.origin.y =  lblStaticBuilderRefNum.frame.origin.y + lblStaticBuilderRefNum.frame.size.height;
    [lblBuilderRefNum setFrame:frame];
    

    frame= lblPossessionData.frame;
    frame.origin.y =  lblStaticPossessionDate.frame.origin.y + lblStaticPossessionDate.frame.size.height ;
    [lblPossessionData setFrame:frame];
    
    frame= lblEnrollmentNumber.frame;
    frame.origin.y =  lblStaticEnrollmentNumber.frame.origin.y + lblStaticEnrollmentNumber.frame.size.height ;
    [lblEnrollmentNumber setFrame:frame];
    
    
    frame = [ownerDetailsView frame];
    
    
    if(lblBuilderRefNum.frame.size.height > lblEnrollmentNumber.frame.size.height){
        
        frame.size.height =  lblBuilderRefNum.frame.origin.y+lblBuilderRefNum.frame.size.height +15;
    }
    else{
        
        frame.size.height =  lblEnrollmentNumber.frame.origin.y+lblEnrollmentNumber.frame.size.height +15;
    }

    if (frame.size.height<95) {
        
        frame.size.height=95;
    }
    [ownerDetailsView setFrame:frame];
    
    if(!lblBuilderRefNum.text.length){
        
        
        NSArray *subViewsArray = [NSArray arrayWithObjects:lblStaticPossessionDate, lblStaticEnrollmentNumber, lblPossessionData, lblEnrollmentNumber, btnEnrollment, btnPossessionDate, nil];
        
        for (UILabel *lbl in subViewsArray) {
            
            frame = [lbl frame];
            frame.origin.x-= 239;
            [lbl setFrame:frame];
        }
    }
        
}



-(void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    [ownerIdentificationTable rotateEditOwnerView];
    [self rotateRegisterOwnerView];
    
    
    [self.view endEditing:YES];
    [self setframes];
    
    if ([self.view viewWithTag:REGISTER_VIEW_TAG]) {
        
        RegisterOwnerView  *view = (RegisterOwnerView *) [self.view viewWithTag:REGISTER_VIEW_TAG];
        
        [view setCenter:self.view.center];
    }
    
    
    if ([self.view viewWithTag:UNIT_ENROLLMENT_VIEW_TAG]) {
        
        UnitEnrollmentView  *view = (UnitEnrollmentView *) [self.view viewWithTag:UNIT_ENROLLMENT_VIEW_TAG];
        
        CGRect frame = view.frame;
        frame.origin.y = self.view.center.y-120;

        [view setFrame:frame];
    }

}


- (void)rotateRegisterOwnerView{

    BOOL isPortrait = [self orientationTypePortrait];
    
    CGPoint center = [self.view center];
    
    if (modalView) {
        
        for (UIView *view in modalView.subviews) {
            
            if ([view isKindOfClass:[RegisterOwnerView class]]) {
                
                RegisterOwnerView *registerOwnerView = (RegisterOwnerView *)view;
                
                [registerOwnerView rotateView:isPortrait];
                
                if (!isPortrait) {
                    
                    center.y = registerOwnerView.frame.size.height;
                }
                [registerOwnerView setCenter:center];

                break;
            }
        }
    }
}

@end
