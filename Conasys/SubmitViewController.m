//
//  SubmitViewController.m
//  Conasys
//
//  Created by user on 7/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "SubmitViewController.h"
#import "ServiceReviewViewController.h"
#import "OwnerSignatureView.h"
#import "SignatureView.h"
#import "ReviewOwner.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SubmitReviewUploader.h"
#import "ReviewOwnerDatabase.h"

#define OWNER_SIGN_VIEW_WIDTH 340
#define OWNER_SIGN_VIEW_HEIGHT 185

#define SIGNATURE_VIEW_WIDHT 700
#define SIGNATURE_VIEW_HEIGHT 680+[self additions]

#define STATIC_POLICY_NUMBER @"Unit Enrolment/Policy #: "
#define STATIC_POSSESSION_DATE @"Possession Date: "
#define STATIC_DATE_PERFORMED @"Date Performed: "
#define STATIC_BUILDER_REF_NUMBER  @"Builder Reference #: "
#define STATIC_PERFORMED_BY @"Performed by: "

@interface SubmitViewController ()

@end

@implementation SubmitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFonts];
    [self localizeObjects];
    [self addTheSliderView];
    [stepSliderView selectStep:3];
    
    if ([Utility isiOSVersion6]) {
        
        CGRect frame = scrollView.frame;
        frame.origin.y+=20;
        frame.size.height-=20;
        [scrollView setFrame:frame];
    }
    
    [self settingTableData];
    
    if (self.currentDeficiencyReview.additionalComments.length) {

        [textviewComments setText:self.currentDeficiencyReview.additionalComments];
        
        if ([Utility isiOSVersion6]) {
            
            CGRect frame = textviewComments.frame;
            frame.origin.x-=3;
            frame.size.width+=3;
            [textviewComments setFrame:frame];
        }
    }
    else{
        
        CGRect frame = additionCommentsView.frame;
        frame.size.height = 0;
        [additionCommentsView setFrame:frame];
        [additionCommentsView setHidden:YES];
    }
    
    [imageViewLogo setImageWithURL:[NSURL URLWithString:[self.currentProject.builderLogo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
    
    
    if (self.currentDeficiencyReview.isPDI) {
        
        [self setPDIDetailContainerView];
    }
    else{
        
        [self setConstructionDataView];
    }
    
    [constructionDetailContainerView setHidden:self.currentDeficiencyReview.isPDI?YES:NO];
    [pdiDetailContainerView setHidden:!constructionDetailContainerView.isHidden];
  
    [self changedTitle:self.currentDeficiencyReview.isPDI];
    // fetching current developer here.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [self addBottomBar];
    [appBottomView enterLastSyncDate];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

// calculating selected owners here.
- (NSString *)calculateSelectedOwners{
    
    NSString *nameString = @"";
    for (ReviewOwner *reviewOwner in self.currentDeficiencyReview.reviewOwners) {
        
        if (reviewOwner.isSelectedOwner) {
            
            nameString = [nameString stringByAppendingFormat:@"%@ %@, ", reviewOwner.owner.firstName, reviewOwner.owner.lastName];
        }
    };
    
    if (nameString.length>=2) {
        
        nameString = [nameString stringByReplacingCharactersInRange:NSMakeRange(nameString.length-2, 2) withString:@""];
    }
    
    return nameString;
    
}



// setting for PDI view.
- (void)setPDIDetailContainerView{
    
    
    [lblAddressLabel setText:[NSString stringWithFormat:@"%@ - %@ \n%@ \n%@", self.currentUnit.unitNumber, self.currentUnit.address, [self calculateSelectedOwners], self.currentUnit.unitLegalDes]];
    
    Service *service = [self.currentProject.serviceTypes objectAtIndex:self.currentDeficiencyReview.selectedServiceTypeIndex];
    [lblHeaderPDI setText:service.name];
    
    [lblAddressLabel sizeToFit];
    
    [lblPossesionDate setAttributedText:[self setAttributedTextFor:STATIC_POSSESSION_DATE andDetal:self.currentDeficiencyReview.possessionDate]];
    [lblDatePerformed setAttributedText:[self setAttributedTextFor:STATIC_DATE_PERFORMED andDetal:[[DateFormatter sharedFormatter]getDateStringForSubmit:[NSDate date]]]];
    
    NSString *string = STATIC_POLICY_NUMBER;

    [lblEnrollmentNumber setAttributedText:[self setAttributedTextFor:string andDetal:self.currentDeficiencyReview.unitEnrolmentPolicy]];
    
    if (lblEnrollmentNumber.text.length>string.length) {

        [lblEnrollmentNumber sizeToFit];
        
        CGRect frame = lblEnrollmentNumber.frame;
        
        frame.origin.x = pdiDetailContainerView.frame.size.width-lblEnrollmentNumber.frame.size.width-(pdiDetailContainerView.frame.size.width-(lblDatePerformed.frame.origin.x+lblDatePerformed.frame.size.width));
        
        [lblEnrollmentNumber setFrame:frame];
    }
    else{
        
        [lblEnrollmentNumber setText:@""];
        CGRect frame = lblEnrollmentNumber.frame;
        frame.size.height=0;
        [lblEnrollmentNumber setFrame:frame];
    }
    

    CGRect frame = [lblBuilderRefNumber frame];
    
    frame.origin.y = lblEnrollmentNumber.frame.origin.y+lblEnrollmentNumber.frame.size.height+5;
    
    [lblBuilderRefNumber setFrame:frame];
    

    NSString *stringStatic = STATIC_BUILDER_REF_NUMBER;
    [lblBuilderRefNumber setAttributedText:[self setAttributedTextFor:stringStatic andDetal:self.currentProject.builderRefNum]];
    
    if (lblBuilderRefNumber.text.length>stringStatic.length) {

        [lblBuilderRefNumber sizeToFit];
        
        CGRect frame = lblBuilderRefNumber.frame;
        frame.origin.x = pdiDetailContainerView.frame.size.width-lblBuilderRefNumber.frame.size.width-(pdiDetailContainerView.frame.size.width-(lblDatePerformed.frame.origin.x+lblDatePerformed.frame.size.width));
        [lblBuilderRefNumber setFrame:frame];
        
    }
    else{
        
        [lblBuilderRefNumber setText:@""];
        CGRect frame = lblBuilderRefNumber.frame;
        frame.size.height=0;
        [lblBuilderRefNumber setFrame:frame];
    }
    
    [self adjustingFramesForPDI];
    
    //above we are making page level scroll by setting frames for different objects.
    
    
    // here we are creating all signatures views.
    [self createTheSignatureView:15 andYAxis:30];
    
    [lblConfirmation setBackgroundColor:COLOR_BLUE_APP];
    
    
    NSString *htmlString =
    [NSString stringWithFormat:@"<font face='Gibson-Regular' size='2' color=#4F4F4F>%@", service.legalTerms];
    
    [confirmationWebView loadHTMLString:htmlString baseURL:nil];
    
}

- (void)checkFrameFor{
    
    
}

- (void)adjustingFramesForPDI{
    
    
    CGRect frame = [pdiDetailContainerView frame];
    
    float first = lblAddressLabel.frame.origin.y+lblAddressLabel.frame.size.height;
    
    float second = lblBuilderRefNumber.frame.origin.y+lblBuilderRefNumber.frame.size.height;
    
    float lblFrameHeight = first>second?first:second;
    
    if (lblFrameHeight+10>frame.size.height) {
        
        frame.size.height = lblFrameHeight+(lblFrameHeight+10 - frame.size.height);
        [pdiDetailContainerView setFrame:frame];
    }
    
    frame = [headerContainerView frame];
    frame.origin.y = pdiDetailContainerView.frame.origin.y+pdiDetailContainerView.frame.size.height+10;
    [headerContainerView setFrame:frame];

    [self adjustReviewTableHeightAndFrames];
}


- (void)adjustingFramesForConstructionView{
    
    
    CGRect frame = [constructionDetailContainerView frame];
    
    float lblFrameHeight = lblConstUnitAddress.frame.origin.y+lblConstUnitAddress.frame.size.height;
    if (lblFrameHeight>frame.size.height) {
        
        frame.size.height = lblFrameHeight+10;
        [constructionDetailContainerView setFrame:frame];
    }
    
    frame = [headerContainerView frame];
    frame.origin.y = constructionDetailContainerView.frame.origin.y+constructionDetailContainerView.frame.size.height+10;
    [headerContainerView setFrame:frame];
    
    
    [self adjustReviewTableHeightAndFrames];
}


- (void)adjustReviewTableHeightAndFrames{
    

    CGRect frame = [submitReviewTable frame];
    
    frame.origin.y =  headerContainerView.frame.origin.y+headerContainerView.frame.size.height;
    frame.size.height = [submitReviewTable tableMaxHeight];
    
    [submitReviewTable setFrame:frame];
    
    frame = [additionCommentsView frame];
    frame.origin.y = submitReviewTable.frame.origin.y+submitReviewTable.frame.size.height+15;
    [additionCommentsView setFrame:frame];
    
    
    frame = [confirmationView frame];
    frame.origin.y = additionCommentsView.frame.origin.y+additionCommentsView.frame.size.height+30;
    [confirmationView setFrame:frame];
    
    [self setFrame];
    frame = seperatorView.frame;
    frame.size.width = self.view.frame.size.width;
    if (textviewComments.hasText) {
        
        frame.origin.y = confirmationView.frame.origin.y-(confirmationView.frame.origin.y - (additionCommentsView.frame.origin.y+ additionCommentsView.frame.size.height))/2;
       
    }
    else{
        
        frame.origin.y = confirmationView.frame.origin.y-(confirmationView.frame.origin.y - (submitReviewTable.frame.origin.y+ submitReviewTable.frame.size.height))/2;
    }
    
    [additionCommentsView setBackgroundColor:[UIColor clearColor]];
    [seperatorView setFrame:frame];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGRect frame = webView.frame;
    frame.size.height = webView.scrollView.contentSize.height;
    [webView setFrame:frame];
    
    [self reframeSignatureViews:frame.origin.y + frame.size.height- 30];
    
    [webView setBackgroundColor:[UIColor redColor]];
}


- (void)reframeSignatureViews:(float)yAxis{
    
    
    float height = 0.0;
    
    for (UIView *view in confirmationView.subviews) {
        
        if ([view isKindOfClass:[OwnerSignatureView class]]) {
            
            CGRect frame = [view frame];
            frame.origin.y+= yAxis;
            [view setFrame:frame];
            
            height = frame.origin.y+frame.size.height+20;
        }
    }
    
    CGRect frame = [confirmationView frame];
    frame.size.height = height;
    [confirmationView setFrame:frame];
    
    [self setFrame];
}

// setting for Construction view.
- (void)setConstructionDataView{
    
    [ConfirmationContainerView setHidden:YES];
    [lblConstUnitAddress setText:[NSString stringWithFormat:@"%@ - %@", self.currentUnit.unitNumber ,self.currentUnit.address]];
    
    [lblConstUnitAddress sizeToFit];
    
    [self adjustingFramesForConstructionView];
    
    // adjusting frames above to make page level scrolling.
    
    [lblConstDatePerformed setAttributedText:[self setAttributedTextFor:STATIC_DATE_PERFORMED andDetal:[[DateFormatter sharedFormatter] getDateStringForSubmit:[NSDate date]]]];
    
    [lblConstPerformedBy setAttributedText:[self setAttributedTextFor:STATIC_PERFORMED_BY andDetal:self.currentDeficiencyReview.performedByName]];
    
    Service *service = [self.currentProject.serviceTypes objectAtIndex:self.currentDeficiencyReview.selectedServiceTypeIndex];
    
    [lblHeaderConstruction setText:service.name];
    
    NSString *name = self.currentDeficiencyReview.isPDI?CURRENT_USERNAME:self.currentDeficiencyReview.performedByName;
    
    
    OwnerSignatureView *ownerSignatureView = [self createDeveloperSignView:15 andYAxis:10];
    
    [confirmationView addSubview:ownerSignatureView];
    
    [ownerSignatureView setDataForView:name andTitle:@"Builder Signature"];
    [ownerSignatureView setBoldTitle];
    [ownerSignatureView setSignatureForView:self.currentDeficiencyReview.performedBySignature];
    CGRect frame = confirmationView.frame;
    frame.size.height = ownerSignatureView.frame.origin.y + OWNER_SIGN_VIEW_HEIGHT+20;
    
    frame.size.width = ownerSignatureView.frame.origin.x*2 + OWNER_SIGN_VIEW_WIDTH;
    [confirmationView setFrame:frame];
    
    [self setFrame];
}


- (NSAttributedString *)setAttributedTextFor:(NSString *)text andDetal:(NSString *)detail{
    
    NSMutableAttributedString * headerString = [[NSMutableAttributedString alloc] initWithString:text];
    

    NSMutableAttributedString * detailString = [[NSMutableAttributedString alloc] initWithString:detail.length?detail:@""];
    
    [headerString addAttribute:NSFontAttributeName value:[UIFont semiBoldWithSize:14.0f] range:NSMakeRange(0,headerString.length)];
    
    if (detailString.length) {
    
        [detailString addAttribute:NSFontAttributeName value:[UIFont regularWithSize:13.0f] range:NSMakeRange(0,detailString.length)];

    }
    
    [headerString appendAttributedString:detailString];
    
    return headerString;
}

- (void)settingTableData{
    
    [submitReviewTable setCurrentDeficiencyReview:self.currentDeficiencyReview];
    [submitReviewTable setDelegateAndDataSource];
    [submitReviewTable manageItemData];
}

- (void)localizeObjects{
    
    [lblHeader setText:NSLocalizedString(@"Submit_Header", @"")];
    [btnViewAllUnits setTitle:NSLocalizedString(@"Submit_View_AllUnits", @"") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnViewAllUnitsClicked:(id)sender{
    
    self.currentDeficiencyReview.lastPageNumber=2;
    [self updateDeficiencyReview:self.currentDeficiencyReview];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[ServiceReviewViewController class]]) {
            
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [scrollView setContentSize:CGSizeMake(0, confirmationView.frame.origin.y+confirmationView.frame.size.height+200)];
    
    [submitReviewTable reloadData];
    
    [self reframeButtons];
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    
    [self updateDeficiencyReview:self.currentDeficiencyReview];
    [self.navigationController popViewControllerAnimated:YES];
}


// creating signature views here for PDI views.
- (void)createTheSignatureView:(int)xAxis andYAxis:(int)yAxis{
    
    int x = xAxis;
    int y = yAxis;
    
    int counter = 0;
    
    NSMutableArray *selectedOwners = [NSMutableArray new];
    
    for (ReviewOwner *reviewOwner in self.currentDeficiencyReview.reviewOwners) {
        
        if (reviewOwner.isSelectedOwner) {
            
            [selectedOwners addObject:reviewOwner];
        }
    }
    
    
    for (ReviewOwner *reviewOwner in selectedOwners) {
    
        if (counter%2==0) {
            
            if (counter>0) {
                
                y += OWNER_SIGN_VIEW_HEIGHT+20;
            }
            
            x = xAxis;
        }
        
        else {
            
            x+=OWNER_SIGN_VIEW_WIDTH+30;
        }
        
        
        OwnerSignatureView *ownerSignatureView = [self createDeveloperSignView:x andYAxis:y];
        
        [ownerSignatureView setDataForView:reviewOwner.printName.length?reviewOwner.printName:[NSString stringWithFormat:@"%@ %@", reviewOwner.owner.firstName, reviewOwner.owner.lastName] andTitle:@"Purchaser Signature"];
        
        [ownerSignatureView setReviewOwner:reviewOwner];
        
        [ownerSignatureView setIsOwnerSignView:YES];
        
        [ownerSignatureView setSignatureForView:reviewOwner.ownerSignature];
        
        [confirmationView addSubview:ownerSignatureView];
        
        counter++;
        
        
        if (counter>=selectedOwners.count) {
            
            if (counter%2==0) {
                
                if (counter>0) {
                    
                    y += OWNER_SIGN_VIEW_HEIGHT+30;
                }
                
                x = xAxis;
            }
            
            else {
                
                x+=OWNER_SIGN_VIEW_WIDTH+30;
            }
            OwnerSignatureView *ownerSignatureView = [self createDeveloperSignView:x andYAxis:y];
            [ownerSignatureView setIsOwnerSignView:NO];
            [ownerSignatureView setDataForView:self.currentDeficiencyReview.developerName andTitle:@"Developer Representative"];
            [ownerSignatureView setSignatureForView:self.currentDeficiencyReview.developerSignature];
            
            [confirmationView addSubview:ownerSignatureView];
        
        }
    }
    
    CGRect frame = confirmationView.frame;
    frame.size.height = y+OWNER_SIGN_VIEW_HEIGHT+20;
    [confirmationView setFrame:frame];
    
    [self setFrame];
}


- (void)setFrame{
    
    CGRect frame = btnBack.frame;
    frame.origin.y = confirmationView.frame.size.height+confirmationView.frame.origin.y+25;
    [btnBack setFrame:frame];
    
    frame = btnSubmit.frame;
    frame.origin.y=btnBack.frame.origin.y;
    [btnSubmit setFrame:frame];
    
    [scrollView setContentSize:CGSizeMake(0,btnSubmit.frame.origin.y+btnSubmit.frame.size.height+200)];
    
    [self reframeButtons];
}


-(void)reframeButtons{
    
    CGRect frame  = confirmationView.frame;
    
    if (!self.currentDeficiencyReview.isPDI) {
        
        [btnBack setFrame:CGRectMake(btnBack.frame.origin.x, frame.origin.y+frame.size.height-btnBack.frame.size.height, btnBack.frame.size.width, btnBack.frame.size.height)];
        
        [btnSubmit setFrame:CGRectMake(btnSubmit.frame.origin.x, frame.origin.y+frame.size.height-btnBack.frame.size.height, btnBack.frame.size.width, btnBack.frame.size.height)];
        
        return;
    }
    
    
    if ([self orientationTypePortrait]) {
        
        int addition = 70;
        
        [btnBack setFrame:CGRectMake(530, frame.origin.y+frame.size.height-btnBack.frame.size.height+addition, btnBack.frame.size.width, btnBack.frame.size.height)];
        
        [btnSubmit setFrame:CGRectMake(651, frame.origin.y+frame.size.height-btnBack.frame.size.height+addition, btnBack.frame.size.width, btnBack.frame.size.height)];
    }
    else{
        
        [btnBack setFrame:CGRectMake(786, frame.origin.y+frame.size.height-btnBack.frame.size.height, btnBack.frame.size.width, btnBack.frame.size.height)];
        
        [btnSubmit setFrame:CGRectMake(907, frame.origin.y+frame.size.height-btnBack.frame.size.height, btnBack.frame.size.width, btnBack.frame.size.height)];
    }
    
    
}


// creating signature views.
- (OwnerSignatureView *)createDeveloperSignView:(int)xAxis andYAxis:(int)yAxis{
    
    OwnerSignatureView *ownerSignatureView = [[OwnerSignatureView alloc]initWithFrame:CGRectMake(xAxis, yAxis, OWNER_SIGN_VIEW_WIDTH, OWNER_SIGN_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL isOwner) {
        
        [self openSignatureView:data isOwner:isOwner];
        
    }];
    
    NSString *nibName = @"OwnerSignatureView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:ownerSignatureView options:nil];
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [ownerSignatureView addSubview:viewFromXib];
    
    return ownerSignatureView;
    
}

- (float)additions{
    
    if ([Utility isiOSVersion6]) {
        
        return 40;
    }
    return 0;
}


// opening signature view where one can edit signature.
- (void)openSignatureView:(OwnerSignatureView *)ownerS isOwner:(BOOL)isOwner{
    
    
    SignatureView *signatureView = [[SignatureView alloc]initWithFrame:CGRectMake(0, 0, SIGNATURE_VIEW_WIDHT, SIGNATURE_VIEW_HEIGHT) andCompletionBlock:^(id imageString, id data, int buttonTag, BOOL isBuilder) {
        
        [modalView hide];
        
        if (buttonTag) {
            
            
            
            [self updateOwnerSign:ownerS andName:data isBuilder:isBuilder andImageString:imageString];
        }
    }];
    
    NSString *nibName = @"SignatureView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:signatureView options:nil];
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [signatureView addSubview:viewFromXib];

    [self.view addSubview:signatureView];
    
    [signatureView setIsBuilder:!isOwner];
    [signatureView setTitleForLabel:ownerS.lblTitle.text];
    
    
    
    if (isOwner) {
        
        [signatureView setImageForView:ownerS.reviewOwner.ownerSignature andName:ownerS.reviewOwner.printName];

    }
    else if(self.currentDeficiencyReview.isPDI){
        
        [signatureView setImageForView:self.currentDeficiencyReview.developerSignature andName:self.currentDeficiencyReview.developerName];
    }
    else{
        
        [signatureView setImageForView:self.currentDeficiencyReview.performedBySignature andName:self.currentDeficiencyReview.performedByName];
    }

    
    modalView = [[RNBlurModalView alloc]initWithViewController:self view:signatureView];
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay-0.25.png"]]];
    [modalView show];
}

// owner signview is updating here.
- (void)updateOwnerSign:(OwnerSignatureView *)ownerSView andName:(NSString *)printName isBuilder:(BOOL)isBuilder andImageString:(NSString *)base64String{

    
    [ownerSView changeNickName:printName];
    
    if(isBuilder){
        
        if (self.currentDeficiencyReview.isPDI) {
            
            self.currentDeficiencyReview.developerName = printName;
        
            self.currentDeficiencyReview.developerSignature = base64String;
        }
        else{
            
            self.currentDeficiencyReview.performedByName = printName;
            self.currentDeficiencyReview.performedBySignature = base64String;
            
            [lblConstPerformedBy setAttributedText:[self setAttributedTextFor:STATIC_PERFORMED_BY andDetal:self.currentDeficiencyReview.performedByName]];
        }
        
        [self updateDeficiencyReview:self.currentDeficiencyReview];

    }
    else{

        ownerSView.reviewOwner.ownerSignature = base64String;
        ownerSView.reviewOwner.printName = printName;
        [[ReviewOwnerDatabase sharedDatabase]updateReviewOwnerTable:ownerSView.reviewOwner];
    }
    
    [ownerSView setSignatureForView:base64String];
}


// Submitting the review to server.
- (IBAction)submitButtonClicked:(UIButton *)sender{
    
    [sender setUserInteractionEnabled:NO]; // protecting double tap.
    
    
    self.currentDeficiencyReview.confirmationSubmitTimestamp = [[DateFormatter sharedFormatter]getFullStringFromDate:[NSDate date]];
    
    self.currentDeficiencyReview.isPending = NO;
    
    [[DeficiencyReviewDatabase sharedDatabase]updateDeficiencyReview:self.currentDeficiencyReview];
    
    self.currentUnit.isPendingUnit = NO;
    [[UnitsDBManager sharedManager] updateUnit:self.currentUnit];
    
    if([[OwnerDBManager sharedManager] sycingOwnerCount]){
        
        goto here;
    }
    
    if ([self networkAvailable]) {
    
        NSLog(@"Submit [self networkAvailable]");
        self.currentDeficiencyReview.isSyncing = YES;
        [[DeficiencyReviewDatabase sharedDatabase]updateDeficiencyReview:self.currentDeficiencyReview];
        
        SubmitReviewUploader *submitUploader = [[SubmitReviewUploader alloc]init];
        submitUploader.currentDeficiencyReview = self.currentDeficiencyReview;
        
        [submitUploader performSelectorInBackground:@selector(uploadReviewInBackground:) withObject:[self getTheDict]];
    }
    
here:
    
    [self popView];
}



- (void)popView{
    
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[ServiceReviewViewController class]]) {
            
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

// getting complete dictionary to be  uploaded while submitting a review.
- (NSMutableDictionary *)getTheDict{
    


    NSMutableDictionary *dictionary =  [self getMainDict];
    
    NSMutableArray *itemListArray = [NSMutableArray new];
    
    for (ReviewItem *reviewItem in self.currentDeficiencyReview.deficienceyReviewItems) {
        
        NSMutableArray *imageArray = [NSMutableArray new];
        
        for (ReviewItemImage *reviewItemImage in reviewItem.reviewItemImages) {
            
            [imageArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:reviewItemImage.base64String, @"ImageStream",@"image.png", @"ImageName", nil]];
            
        }
        
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:reviewItem.itemDescription, @"Description", reviewItem.itemLocation ,@"Location", reviewItem.productId, @"ProductId", imageArray, @"Files", nil];
        
        [itemListArray addObject:itemDict];
    }
    
    NSMutableArray *ownersArray = [NSMutableArray new];

    if (!self.currentDeficiencyReview.isPDI) {
        
        goto here;
    }
    
    for (ReviewOwner *reviewOwner in self.currentDeficiencyReview.reviewOwners) {
        
        if (reviewOwner.isSelectedOwner) {
         
            [ownersArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:reviewOwner.userName, @"userName", reviewOwner.ownerSignature, @"signatureImage", reviewOwner.printName, @"printName", reviewOwner.email, @"userEmail", nil]];
            
        }
    }
    
here:
    [dictionary setObject:ownersArray forKey:@"IncludeOwnerList"];
    
    [dictionary setObject:itemListArray forKey:@"ItemList"];
    
    
    return dictionary;
}


// creating the dictionary to be uploaded.
- (NSMutableDictionary *)getMainDict{
    
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:self.currentDeficiencyReview.isPDI?@"false":@"true", @"IsConstructionReview", CURRENT_USERNAME, @"BuilderUserName", self.currentDeficiencyReview.unitId, @"UnitId", CURRENT_USER_TOKEN, @"AuthanticationToken", self.currentDeficiencyReview.performedByName,@"PerformedByName",self.currentDeficiencyReview.performedByEmail, @"PerformedByEmail", self.currentDeficiencyReview.performedBySignature, @"PerformedBySignature", self.currentDeficiencyReview.additionalComments, @"AdditionalComments", self.currentDeficiencyReview.unitEnrolmentPolicy, @"UnitEnrolmentNo", self.currentDeficiencyReview.possessionDate, @"PossessionDate", self.currentDeficiencyReview.serviceTypeId, @"ServiceTypeId", self.currentDeficiencyReview.reviewInitiationTimeStamp, @"ReviewInitiationTimeStamp", self.currentDeficiencyReview.ownerNextTimeStamp, @"OwnerNextTimeStamp", self.currentDeficiencyReview.itemNextTimeStamp, @"ItemNextTimeStamp", self.currentDeficiencyReview.confirmationSubmitTimestamp, @"ConfirmationSubmitTimestamp",  self.currentDeficiencyReview.developerName, @"DeveloperPrintName", self.currentDeficiencyReview.developerSignature, @"DeveloperSignImage",nil];
}



- (void)setFonts{
    
    [btnSubmit.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [btnBack.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    
    lblHeaderItem.font = lblHeaderProduct.font = lblHeaderDescription.font = [UIFont semiBoldWithSize:13.0f];
    
    [lblAdditionalComments setFont:[UIFont semiBoldWithSize:13.0f]];
    [textviewComments setFont:[UIFont regularWithSize:14.0f]];
    
    [lblConfirmation setFont:[UIFont semiBoldWithSize:13.0f]];
    
    [lblHeader setFont:[UIFont semiBoldWithSize:21.0f]];
    [btnViewAllUnits.titleLabel setFont:[UIFont regularWithSize:14.0f]];
    
    [lblHeaderPDI setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblAddressLabel setFont:[UIFont regularWithSize:14.0f]];
    
    [lblHeaderConstruction setFont:[UIFont semiBoldWithSize:14.0f]];
    [lblConstUnitAddress setFont:[UIFont regularWithSize:14.0f]];
}

@end
