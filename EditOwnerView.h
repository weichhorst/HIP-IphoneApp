//
//  EditOwnerView.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface EditOwnerView : BaseView{
    
    IBOutlet UITextField  *textFieldFirstName, *textFieldLastName, *textFieldEmail, *textFieldPhoneNumber;
    
    IBOutlet UIButton *btnClose;
    
    IBOutlet UILabel *lblUsername;

    void(^ completionBlock)(id data, int buttonTag, BOOL result);
    
    
    IBOutlet UIButton *btnCheckBox;
    
    IBOutlet UILabel *lblHeader;
    IBOutlet UILabel *lblStaticUsername;
    IBOutlet UILabel *lblPhonenumber;
    IBOutlet UILabel *lblRecieveEmail;
    IBOutlet UIButton *btnSave;
    
    IBOutlet UIView *bottomView;
    IBOutlet UIView *containerView;
    
    __weak IBOutlet UIButton *buttonClose;
    
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

@property (nonatomic, retain)Owner *owner;

- (void)setDataForView:(Owner *)owner;

- (IBAction)btnCloseClicked:(UIButton *)sender;

- (IBAction)saveButtonClicked:(UIButton *)sender;

- (IBAction)btnCheckboxClicked:(UIButton *)sender;

- (void)addLeftLabelsForTextFields;

- (void)rotateView:(BOOL)isPortrait;

@end
