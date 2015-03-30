//
//  OwnerIdentificationViewController.h
//  Conasys
//
//  Created by user on 5/15/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"
#import "PCPopoverController.h"
#import "DeficiencyReview.h"
#import "ReviewOwner.h"


@interface OwnerIdentificationViewController : BaseViewController<UIPopoverControllerDelegate>
{
    
      SYPopoverController *viewSelectionPopOver;
//    PCPopoverController *viewSelectionPopOver;
    RNBlurModalView *modalView;
    IBOutlet OwnerIdentificationTable *ownerIdentificationTable;
    IBOutlet UILabel *lblPossessionData;
    IBOutlet UILabel *lblEnrollmentNumber;
    IBOutlet UILabel *lblViewName;
    __weak IBOutlet UILabel *lblLegalDescription;
    __weak IBOutlet UILabel *lblBuilderRefNum;
    
    IBOutlet UIView *pdiView;
    IBOutlet UIView *constructionView;
    
    IBOutlet UITextField *textFieldPerformedEmail, *textFieldPerformedName;
    __weak IBOutlet UITextView *textViewUnitAddress;
    
    
    __weak IBOutlet UIButton *btnViewAllUnits;
    __weak IBOutlet UILabel *lblInReport;
    __weak IBOutlet UILabel *lblOwnerName;
    __weak IBOutlet UILabel *lblEmail;
    __weak IBOutlet UILabel *lblPhone;
    __weak IBOutlet UILabel *lblEdit;
    __weak IBOutlet UILabel *lblPerformedByName;
    __weak IBOutlet UILabel *lblPerformedByEmail;
    __weak IBOutlet UILabel *lblStaticLegalDescription;
    __weak IBOutlet UILabel *lblStaticBuilderRefNum;
    __weak IBOutlet UILabel *lblStaticPossessionDate;
    __weak IBOutlet UILabel *lblStaticEnrollmentNumber;
    
    __weak IBOutlet UIButton *btnPossessionDate;
    __weak IBOutlet UIButton *btnEnrollment;
    __weak IBOutlet UIButton *btnRegisterOwner;
    __weak IBOutlet UIButton *btnNext;
    __weak IBOutlet UIButton *btnBack;
    __weak IBOutlet UIView *ownerDetailsView;
    
    __weak IBOutlet UIButton *constBackButton;
    __weak IBOutlet UIButton *constNextButton;

    __weak IBOutlet UIButton *btnServiceDropDown;
    __weak IBOutlet UIView *viewTableHeader;
}

- (IBAction)btnViewSelectionClicked:(UIButton *)sender;
- (IBAction)btnNextClicked:(UIButton *)sender;
- (IBAction)btnPreviousClicked:(UIButton *)sender;
- (IBAction)btnRegisterOwnerClicked:(UIButton *)sender;

- (IBAction)btnUnitEnrollmentClicked:(UIButton *)sender;
- (IBAction)btnPossessionDateClicked:(UIButton *)sender;

@property (nonatomic, retain)Unit *currentUnit;
@property (nonatomic, retain)Project *currentProject;

@property (nonatomic, retain)DeficiencyReview *deficiencyReview;

//- (void)updateOwner:(NSMutableDictionary *)dict;

- (void)updateOwner:(NSMutableDictionary *)dict withCompletionHandler:(void (^)(id response, BOOL hasInternet, BOOL result))block;

- (void)rotateRegisterOwnerView;

@end
