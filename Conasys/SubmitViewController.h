//
//  SubmitViewController.h
//  Conasys
//
//  Created by user on 7/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitReviewTable.h"

@interface SubmitViewController : BaseViewController{
    
    IBOutlet SubmitReviewTable *submitReviewTable;
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UIButton *btnViewAllUnits;
    
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *pdiDetailContainerView;

    IBOutlet UILabel *lblStaticPossessionDate;
    IBOutlet UILabel *lblStaticDatePerformed;
    IBOutlet UILabel *lblStaticEnrollmentNumber;
    IBOutlet UILabel *lblStaticBuilderRefNumber;
    IBOutlet UILabel *lblOwnerNames;
    IBOutlet UILabel *lblAddressLabel;
    IBOutlet UILabel *lblLegalDescription;
    IBOutlet UILabel *lblHeaderPDI;
    IBOutlet UILabel *lblPossesionDate;
    IBOutlet UILabel *lblDatePerformed;
    IBOutlet UILabel *lblEnrollmentNumber;
    IBOutlet UILabel *lblBuilderRefNumber;
    
    IBOutlet UIView *headerContainerView;
    IBOutlet UILabel *lblHeaderItem;
    IBOutlet UILabel *lblHeaderProduct;
    IBOutlet UILabel *lblHeaderDescription;
    
    
    IBOutlet UITextView *textviewComments;
    
    IBOutlet UIView *confirmationView;
    
    IBOutlet UIView *constructionDetailContainerView;
    IBOutlet UILabel *lblConstDatePerformed;
    IBOutlet UILabel *lblConstPerformedBy;
    IBOutlet UILabel *lblHeaderConstruction;
    IBOutlet UILabel *lblConstUnitAddress;
    IBOutlet UILabel *lblConstStaticPerformedBy;
    IBOutlet UILabel *lblConstStaticDatePerformed;
    
    
    IBOutlet UIButton *btnSubmit;
    IBOutlet UIButton *btnBack;
    
    IBOutlet UIView *ConfirmationContainerView;
    RNBlurModalView *modalView;
    
    IBOutlet UIImageView *imageViewLogo;
    IBOutlet UILabel *lblConfirmation;
    IBOutlet UIWebView *confirmationWebView;
    
    IBOutlet UIView *additionCommentsView;
    
    
    IBOutlet UIView *seperatorView;
    
    __weak IBOutlet UILabel *lblAdditionalComments;
}


@property (nonatomic, retain)id controller;

@property (nonatomic, retain)Unit *currentUnit;
@property (nonatomic, retain)Project *currentProject;

@property (nonatomic, retain)DeficiencyReview *currentDeficiencyReview;

- (IBAction)btnViewAllUnitsClicked:(UIButton *)sender;
- (IBAction)backButtonClicked:(UIButton *)sender;
- (IBAction)submitButtonClicked:(UIButton *)sender;


@end
