//
//  LoginViewController.h
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"
#import "ConasysRequestManager.h"


@interface LoginViewController : BaseViewController{
    
    IBOutlet UITextField *textFieldUsername, *textFieldPassword;
    RNBlurModalView *modalView;
    
    IBOutlet UIImageView *backgroundImageView;

    int currentImageNumber;
    
    NSArray *imageNumberArray;
    __weak IBOutlet UIButton *btnCheckBox;    
    __weak IBOutlet UIView *loginView;
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblGetStarted;
    __weak IBOutlet UILabel *lblRemember;
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UIScrollView *scrView;

}

- (void)localizeTheObjects;
- (IBAction)btnCheckBox:(id)sender;
- (IBAction)buttonLoginTapped:(UIButton *)sender;
- (IBAction)buttonForgotPassTapped:(UIButton *)sender;

@end
