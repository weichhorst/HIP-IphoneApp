//
//  RegisterOwnerView.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface RegisterOwnerView : BaseView{
    
    IBOutlet UITextField *textFieldUsername, *textFieldFirstName, *textFieldLastName, *textFieldPassword, *textFieldConfirmPassword, *textFieldEmail, *textFieldPhoneNumber;
    
    void(^ completionBlock)(id data, int buttonTag, BOOL result);
    
    IBOutlet UIButton *btnUserPermission;
    
    
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblDescription;
    __weak IBOutlet UILabel *lblConfirmPassword;
    __weak IBOutlet UILabel *lblPhoneNumber;
    __weak IBOutlet UILabel *lblRecieveEmail;
    
    __weak IBOutlet UIButton *btnRegister;
    
    __weak IBOutlet UIView *bottomView;
    
    
    __weak IBOutlet UIView *containerView;
    
    
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

- (IBAction)btnCloseClicked:(UIButton *)sender;

- (IBAction)btnRegisterClicked:(UIButton *)sender;

- (void)addLeftLabelsForTextFields;

- (IBAction)btnUserPermissionClicked:(UIButton *)sender;

- (void)rotateView:(BOOL)isPortrait;

@end
