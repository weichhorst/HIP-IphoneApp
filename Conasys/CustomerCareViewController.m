//
//  CustomerCareViewController.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "CustomerCareViewController.h"
#import "ServiceReviewViewController.h"
#import "Service.h"
#import "SubmitViewController.h"

@interface CustomerCareViewController ()

@end

@implementation CustomerCareViewController


#define LABEL_ADDRESS_MAX_HEIGHT 45


#define LOCATION_FRAME_PORTRAIT CGRectMake(126,20,66,21)
#define LOCATION_FRAME_LANDSCAPE CGRectMake(126,20,66,21)

#define PRODUCT_FRAME_PORTRAIT CGRectMake(273,20,74,21)
#define PRODUCT_FRAME_LANDSCAPE CGRectMake(273,20,74,21)

#define DESCRIPTION_FRAME_PORTRAIT CGRectMake(461,20,107,21)
#define DESCRIPTION_FRAME_LANDSCAPE CGRectMake(461,20,107,21)

#define YAXIS_LANDSCAPE -270-[self additions]
#define MAXIMUM_Y_CONTAINER 524


#define YAXIS_PORTRAIT -212-[self additions]
#define MAXIMUM_Y_CONTAINER_PORTRAIT 821


#define CONTAINER_VIEW_L_FRAME CGRectMake(0,customerCareTable.frame.origin.y+customerCareTable.frame.size.height+15,1024,150)

#define CONTAINER_VIEW_P_FRAME CGRectMake(0,customerCareTable.frame.origin.y+customerCareTable.frame.size.height+15, 768, 150)


#define CUSTOMER_TABLE_P_FRAME CGRectMake(14,headerView.frame.origin.y+headerView.frame.size.height-20+[self additions],740,[customerCareTable tableMaxHeight]- [self additions])

#define CUSTOMER_TABLE_L_FRAME CGRectMake(14,headerView.frame.origin.y+headerView.frame.size.height-20+[self additions],994,[customerCareTable tableMaxHeight]-[self additions])


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
    
    [self addTheSliderView];
    
    [self shiftAdditionalComments];
    
    [stepSliderView selectStep:2];
    
    [self setTableData];
    
    [self getOverlayView];
    
    [self makeRadiusCorner];
    
    [textViewComments setText:self.currentDeficiencyReview.additionalComments];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    Service *service = (Service *)[[self.currentProject serviceTypes] objectAtIndex:self.currentDeficiencyReview.selectedServiceTypeIndex];
    
    
    
    if (self.currentDeficiencyReview.isPDI) {

        [self calculateSelectedOwnersWithServiceName:service.name];
    }
    else{
        
        [self setForAddress:service.name andDetail:[NSString stringWithFormat:@" - %@ - %@",self.currentUnit.unitNumber, self.currentUnit.address]];
    }
    
    [self changedTitle:self.currentDeficiencyReview.isPDI];
    
    if (self.currentDeficiencyReview.lastPageNumber>1) {
        
        [self btnNextClicked:nil];
    }
   
}

- (float)additions{
    
    if ([Utility isiOSVersion6]) {
        
        return 20;
    }
    return 0;
}

- (float)margin{
    
    if ([Utility isiOSVersion6]) {
        
        return -5;
    }
    return 0;
}

- (void)shiftAdditionalComments{
    
    if (![Utility isiOSVersion7]) {
    
        CGRect frame = textViewComments.frame;
        frame.origin.x-=2;
        frame.size.width+=4;
        [textViewComments setFrame:frame];
    }
}

- (void)addOverlay:(NSNotification *)notification{
    
    if ([notification.object isEqualToString:@"YES"]) {
        
        [overlayView setFrame:self.view.frame];
        [self.view addSubview:overlayView];
    }
    else{
        
        [UIView animateWithDuration:1.0 animations:^{
            
            [overlayView removeFromSuperview];
        }];
    }
}

- (void )getOverlayView{
    
    overlayView = [[UIView alloc]initWithFrame:self.view.frame];
    
    [overlayView setAutoresizesSubviews:YES];
    [overlayView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    [overlayView setBackgroundColor:[UIColor darkGrayColor]];
    [overlayView setAlpha:0.3];
    
}


- (void)setTableData{
    
    [customerCareTable setCurrentProject:self.currentProject];
    [customerCareTable setCurrentUnit:self.currentUnit];
    [customerCareTable setParentController:self];
    [customerCareTable setCurrentDeficiencyReview:self.currentDeficiencyReview];
    [customerCareTable setDelegateAndSource];
    
    if (![self.currentDeficiencyReview.deficienceyReviewItems count]) {
        
        [customerCareTable addItem:@"0"];
        
    };
}

- (void)setForAddress:(NSString *)text andDetail:(NSString *)detail{
    
    
    NSMutableAttributedString * headerString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableAttributedString * detailString = [[NSMutableAttributedString alloc] initWithString:detail.length?detail:@""];
    
    [headerString addAttribute:NSFontAttributeName value:[UIFont semiBoldWithSize:14.0f] range:NSMakeRange(0,headerString.length)];
    
    [detailString addAttribute:NSFontAttributeName value:[UIFont regularWithSize:13.0f] range:NSMakeRange(0,detailString.length)];
    
    if (detailString.length) {
        
        [detailString addAttribute:NSFontAttributeName value:[UIFont regularWithSize:13.0f] range:NSMakeRange(0,detailString.length)];
        
    }
    [headerString appendAttributedString:detailString];
    
    [lblViewType setAttributedText:headerString];
    
    [lblViewType sizeToFit];
    
    CGRect frame  = stepSliderView.frame;
    
    float newYAxis = lblViewType.frame.origin.y+ lblViewType.frame.size.height +20;
    
        frame.origin.y = newYAxis;
        [stepSliderView setFrame:frame];
        
        frame = headerView.frame;
        frame.origin.y = stepSliderView.frame.origin.y+stepSliderView.frame.size.height;
        
        [headerView setFrame:frame];
        
        frame = customerCareTable.frame;
        
        frame.origin.y = headerView.frame.origin.y+headerView.frame.size.height-15+[self additions];
    
    frame.size.height -= [self additions];
        [customerCareTable setFrame:frame];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [self addBottomBar];
    [appBottomView enterLastSyncDate];
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addOverlay:) name:OVERLAY_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OVERLAY_NOTIFICATION object:nil];
}


- (void)calculateSelectedOwnersWithServiceName:(NSString *)serviceName{
    
    NSString *nameString = @"";

    for (ReviewOwner *reviewOwner in self.currentDeficiencyReview.reviewOwners) {
        
        if (reviewOwner.isSelectedOwner) {
            
            nameString = [nameString stringByAppendingFormat:@"%@ %@, ", reviewOwner.owner.firstName, reviewOwner.owner.lastName];
        }
    };
    
    if (nameString.length>1) {
        
        nameString = [nameString stringByReplacingCharactersInRange:NSMakeRange(nameString.length-2, 2) withString:@""];
    }
    
    [self setForAddress:serviceName andDetail:[NSString stringWithFormat:@" - %@ - %@ \n%@", self.currentUnit.unitNumber, self.currentUnit.address, nameString]];
        
}


- (void)localizeObjects{
    
    [btnViewAllUnits setTitle:NSLocalizedString(@"Customer_View_All_Units", @"") forState:UIControlStateNormal];
    [lblItem setText:NSLocalizedString(@"Customer_Item", @"")];
    [lblLocation setText:NSLocalizedString(@"Customer_Location", @"")];
    [lblProduct setText:NSLocalizedString(@"Customer_Product", @"")];
    [lblDescription setText:NSLocalizedString(@"Customer_Description", @"")];
    [lblImage setText:NSLocalizedString(@"Customer_Image", @"")];
    [lblAdditionalComments setText:NSLocalizedString(@"Customer_Additional_Comments", @"")];
    
    [self setFonts];
}

- (void)setFonts{
    
    [btnViewAllUnits.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    [lblItem setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblLocation setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblProduct setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblDescription setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblImage setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblAdditionalComments setFont:[UIFont semiBoldWithSize:14.0f]];
    
    [textViewComments setFont:[UIFont regularWithSize:14.0f]];
    
    [btnBack.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [btnNext.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    
}

- (void)makeRadiusCorner{
    
    [textViewComments roundedBorderWithWidth:1.0f radius:10.0f andColor:[UIColor lightGrayColor]];
    
    [bottomView roundedBorderWithWidth:1.0 radius:4.0f andColor:[UIColor clearColor]];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnAllUnitsClicked:(UIButton *)sender{
    
    
    self.currentDeficiencyReview.lastPageNumber = 1;
    [self updateDeficiencyReview:self.currentDeficiencyReview];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[ServiceReviewViewController class]]) {
            
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}


- (void)myNotificationMethod:(NSNotification*)notification
{
       
}

- (void)upTheView:(UIView *)editingView{
    
    
    lastFrame = self.view.frame;
    
    CGRect frame = [self.view frame];
    
    if ([self orientationTypePortrait]) {
        
        if (containerView.frame.origin.y > MAXIMUM_Y_CONTAINER_PORTRAIT + YAXIS_PORTRAIT) {
        
            frame.origin.y = YAXIS_PORTRAIT + MAXIMUM_Y_CONTAINER_PORTRAIT-containerView.frame.origin.y;
        }
    }
    else{
        
        frame.origin.y = YAXIS_LANDSCAPE + MAXIMUM_Y_CONTAINER-containerView.frame.origin.y;
    }
    
    frame.size.width = self.view.frame.size.width;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view setFrame:frame];
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)downTheView:(UIView *)editingView{
   
    lastFrame.size.width = self.view.frame.size.width;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view setFrame:lastFrame];
        
    } completion:^(BOOL finished) {
        
        if (callBackBlock) {
            
            callBackBlock(YES);
            callBackBlock= nil;
        }
    }];
    
    
    self.currentDeficiencyReview.additionalComments = textViewComments.text;
    
    [self updateDeficiencyReview:self.currentDeficiencyReview];
}


- (IBAction)btnNextClicked:(UIButton *)sender{
    
    
    [self.view endEditing:YES];
        
    if (!self.currentDeficiencyReview.deficienceyReviewItems.count) {
        
        [self showCustomAlertWithMessage:NSLocalizedString(@"CustomerCare_DescriptionArray_Null_Message", @"")];
        return;
    }
    for (ReviewItem *reviewItem in self.currentDeficiencyReview.deficienceyReviewItems) {
        
        if (!reviewItem.itemDescription.length) {
            
            [self showCustomAlertWithMessage:NSLocalizedString(@"CustomerCare_Description_Null_Message", @"")];
            
            return;
        }
    }
    
    BOOL animation = sender?YES:NO;
    
    if (animation) {
        
        self.currentDeficiencyReview.itemNextTimeStamp = [[DateFormatter sharedFormatter]getFullStringFromDate:[NSDate date]];

        self.currentDeficiencyReview.additionalComments = textViewComments.text;

        [self updateDeficiencyReview:self.currentDeficiencyReview];
    }
    
    self.currentDeficiencyReview.additionalComments = textViewComments.text;
    
    SubmitViewController *submitView = [[SubmitViewController alloc]initWithNibName:@"SubmitViewController" bundle:nil];
    
    [submitView setCurrentDeficiencyReview:self.currentDeficiencyReview];
    
    [submitView setCurrentProject:self.currentProject];
    [submitView setCurrentUnit:self.currentUnit];
    [self.navigationController pushViewController:submitView animated:animation];
    
}




- (IBAction)btnAddNewItemsClicked:(UIButton *)sender{
    
    [self.view endEditing:YES];
    [customerCareTable addItem:@"0"];
    [self setframes];
}



- (IBAction)backButtonClicked:(UIButton *)sender{
    
    self.currentDeficiencyReview.lastPageNumber = 0;
    [self updateDeficiencyReview:self.currentDeficiencyReview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillLayoutSubviews{
    
    [customerCareTable reloadData];
    [self.view endEditing:YES];
    [self setframes];
    [self adjustFrames];
    
}

- (void)adjustFrames{
    
    [lblLocation setFrame:[self orientationTypePortrait]?LOCATION_FRAME_PORTRAIT:LOCATION_FRAME_LANDSCAPE];
    [lblProduct setFrame:[self orientationTypePortrait]?PRODUCT_FRAME_PORTRAIT:PRODUCT_FRAME_LANDSCAPE];
    [lblDescription setFrame:[self orientationTypePortrait]?DESCRIPTION_FRAME_PORTRAIT:DESCRIPTION_FRAME_LANDSCAPE];
    
}


-(void)setframes
{
    if ([self orientationTypePortrait])
    {
        
        [customerCareTable setFrame:CUSTOMER_TABLE_P_FRAME];
        
        [containerView setFrame:CONTAINER_VIEW_P_FRAME];
    }
    else{
        
        [customerCareTable setFrame:CUSTOMER_TABLE_L_FRAME];
        
        [containerView setFrame:CONTAINER_VIEW_L_FRAME];
    }
    

}

- (void)showAlertWithMessage:(NSString *)message{
    
    [self showCustomAlertWithMessage:message];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self upTheView:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self endEditingWithHandler:nil];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self downTheView:textView];
}

- (void)endEditingWithHandler:(void(^)(BOOL finished))handler{
    
    BOOL responder = [textViewComments isFirstResponder];

    if(responder){
        [self.view endEditing:YES];
        callBackBlock = handler;
    }
    else{
        
        handler(YES);
    }
        
    
}

@end