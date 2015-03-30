//
//  RegisterOwnerView.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "RegisterOwnerView.h"
#import "AlertViewShow.h"
#import "Macros.h"


#define BOTTOM_VIEW_FRAME_PORTRAIT CGRectMake(0, 267, 320, 215)
#define BOTTOM_VIEW_FRAME_LANDSCAPE CGRectMake(320, 98, 320, 175)

#define SELF_VIEW_FRAME_PORTRAIT CGRectMake(352, 170, 320, 535)
#define SELF_VIEW_FRAME_LANDSCAPE CGRectMake(192, 160, 640, 335)


#define DESCRIPTION_FRAME_PORTRAIT CGRectMake(10, 45, 300, 85)

#define EMAIL_TEXTFIELD_FRAME_PORTRAIT CGRectMake(10, 365, 300, 35)

#define FIELD_GAP 11

//#define DESCRIPTION_FRAME_LANDSCAPE CGRectMake(192, 160, 640, 380)

@implementation RegisterOwnerView

CGFloat animatedDistance;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        completionBlock = myBlock;
    }
    return self;
}

- (IBAction)btnRegisterClicked:(UIButton *)sender{
    
    
    if ([self areAllFieldsValid]) {
        
        //12-sept-2014
//        if (isConnected) {
        
            completionBlock([NSMutableDictionary dictionaryWithObjectsAndKeys: textFieldUsername.text,REGISTER_OWNER_USERNAME,textFieldPassword.text,REGISTER_OWNER_PASSWORD,textFieldEmail.text,REGISTER_OWNER_EMAIL,CURRENT_USER_TOKEN,REGISTER_OWNER_TOKEN,textFieldFirstName.text,REGISTER_OWNER_FIRSTNAME,textFieldLastName.text,REGISTER_OWNER_LASTNAME,textFieldPhoneNumber.text,REGISTER_OWNER_PHONE_NUMBER,btnUserPermission.isSelected?@"true":@"false",REGISTER_OWNER_EMAIL_PERMISSION,CURRENT_USERNAME,REGISTER_OWNER_BUILDER_USERNAME, nil], 1, YES);
//        }
//        else{
//            
//            [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Register_Owner_Network_Error", @"") onView:containerView]];
//        }
        
    }
}

- (IBAction)btnUserPermissionClicked:(UIButton *)sender{
    
    [sender setSelected:!sender.isSelected];
}


- (BOOL)areAllFieldsValid{

    BOOL result = YES;
    
    [self endEditing:YES];
    
     NSString *phoneString = [textFieldPhoneNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (!textFieldUsername.text.length || !textFieldFirstName.text.length || !textFieldLastName.text.length || !textFieldPassword.text.length || !textFieldConfirmPassword.text.length || !textFieldEmail.text.length) {
        
        [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Register_Owner_Blank_Error", @"") onView:containerView]];
        result = NO;
    }
    
    
    
    else if (textFieldPassword.text.length<3) {
        
        [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Register_Owner_Password_Short_Error", @"") onView:containerView]];
        
        result = NO;
    }
    
   else if (![textFieldPassword.text isEqualToString:textFieldConfirmPassword.text]) {
       
       [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Register_Owner_Password_Error", @"") onView:containerView]];
       
       result = NO;
    }
    
   else if (![Utility validateEmail:textFieldEmail.text]){
       
       [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Register_Owner_Invalid_Email_Error", @"") onView:containerView]];
       
       result = NO;
       
   }
    
   else if (phoneString.length && phoneString.length != 10) {
       
       [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(phoneString.length>10?@"Register_Owner_Invalid_PhoneNumber_Error":@"Register_Owner_Invalid_PhoneNumber_Lesser_Error" , @"") onView:containerView]];
       
       result = NO;
   }
    
    return result;
}


- (void)addLeftLabelsForTextFields{
    
  
    [textFieldUsername addLeftLabelToMyTextField:NSLocalizedString(@"Register_Owner_Label_Username", @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    [textFieldFirstName addLeftLabelToMyTextField:NSLocalizedString(@"Register_Owner_Label_FirstName" , @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    [textFieldLastName addLeftLabelToMyTextField:NSLocalizedString(@"Register_Owner_Label_LastName" , @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    [textFieldPassword addLeftLabelToMyTextField:NSLocalizedString(@"Register_Owner_Label_Password" , @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    [textFieldEmail addLeftLabelToMyTextField:NSLocalizedString(@"Register_Owner_Label_Email" , @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    [textFieldConfirmPassword addLeftLabelToMyTextField:@"    " andWidth:95];
    
    [textFieldPhoneNumber addLeftLabelToMyTextField:@"    " andWidth:95];
        
    [btnRegister roundedBorderWithWidth:0.0 radius:4.0 andColor:[UIColor clearColor]];
    
    
    [self localizeObjects];
}




- (void)localizeObjects{
    
    
    textFieldUsername.placeholder = textFieldFirstName.placeholder = textFieldLastName.placeholder = textFieldPassword.placeholder = textFieldEmail.placeholder = textFieldConfirmPassword.placeholder = NSLocalizedString(@"Register_Owner_Label_Required" , @"");
    
    textFieldPhoneNumber.placeholder = NSLocalizedString(@"Register_Owner_Label_Optional" , @"");
    
    
    [lblHeader setText:NSLocalizedString(@"Register_Owner_Label_Header" , @"")];
    [lblDescription setText:NSLocalizedString(@"Register_Owner_Label_Description" , @"")];
    
    [lblConfirmPassword setText:NSLocalizedString(@"Register_Owner_Label_Confirm" , @"")];
    
    [lblPhoneNumber setText:NSLocalizedString(@"Register_Owner_Label_Phone" , @"")];
    
    [lblRecieveEmail setText:NSLocalizedString(@"Register_Owner_Label_Receive_Email" , @"")];
    
    [btnRegister setTitle:NSLocalizedString(@"Register_Owner_Btn_Register", @"") forState:UIControlStateNormal];
    
    [self setFonts];
}

- (void)setFonts{
    
    textFieldUsername.font = textFieldFirstName.font = textFieldLastName.font = textFieldPassword.font = textFieldEmail.font = textFieldConfirmPassword.font = textFieldPhoneNumber.font= [UIFont regularWithSize:14.0f];
    
    [lblHeader setFont:[UIFont semiBoldWithSize:17.0f]];
    [lblDescription setFont:[UIFont regularWithSize:14.0f]];
    [lblPhoneNumber setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblConfirmPassword setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblRecieveEmail setFont:[UIFont lightWithSize:12.0f]];
    
}


- (IBAction)btnCloseClicked:(UIButton *)sender{
    
//    [self removeObservers];
    completionBlock(nil, 0, YES);
}


- (void)upTheView:(UIView *)editingView{

   
}


- (void)downTheView:(UIView *)editingView{
    
}

- (void)keyboardFrameUp:(NSNotification *)notification{
    
    
    CGRect frame = [self frame];
    frame.origin.y = [self isPortrait]?self.frame.origin.y-70:15;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self setFrame:frame];
    }];
}


- (void)keyboardFrameDown:(NSNotification *)notification{
    
    
    UIView *superView = (UIView *)[self superview];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self setCenter:superView.center];;
    }];
}



- (void)rotateView:(BOOL)isPortrait{
    
    if (isPortrait) {
        
        [bottomView setFrame:BOTTOM_VIEW_FRAME_PORTRAIT];
        [containerView setFrame:SELF_VIEW_FRAME_PORTRAIT];
        
        [lblDescription setFrame:DESCRIPTION_FRAME_PORTRAIT];
    }
    else{
        
        
        CGRect frame = lblDescription.frame;
        frame.size.height = 50;
        [lblDescription setFrame:frame];
        
        [bottomView setFrame:BOTTOM_VIEW_FRAME_LANDSCAPE];
        [containerView setFrame:SELF_VIEW_FRAME_LANDSCAPE];
        
    }
    
    [self changeFramesForOthers];
    [self changeEmailFrame:isPortrait];
    [self changeCustomAlert];
}

- (void)changeEmailFrame:(BOOL)isPortrait{
    
    if (isPortrait) {
        
        [textFieldEmail setFrame:EMAIL_TEXTFIELD_FRAME_PORTRAIT];
        
        CGRect frame = lblPhoneNumber.frame;
        frame.origin.y = textFieldConfirmPassword.frame.origin.y+(textFieldConfirmPassword.frame.size.height + FIELD_GAP)*2;
        [lblPhoneNumber setFrame:frame];
        frame = textFieldPhoneNumber.frame;
        frame.origin.y = textFieldConfirmPassword.frame.origin.y+(textFieldConfirmPassword.frame.size.height + FIELD_GAP)*2;
        [textFieldPhoneNumber setFrame:frame];

    }
    else{

        CGRect frame = textFieldEmail.frame;
        frame.origin.y = textFieldLastName.frame.origin.y+textFieldLastName.frame.size.height+11;
        [textFieldEmail setFrame:frame];
        
        frame = lblPhoneNumber.frame;
        frame.origin.y = textFieldConfirmPassword.frame.origin.y+textFieldConfirmPassword.frame.size.height + FIELD_GAP;
        [lblPhoneNumber setFrame:frame];
        frame = textFieldPhoneNumber.frame;
        frame.origin.y = textFieldConfirmPassword.frame.origin.y+textFieldConfirmPassword.frame.size.height + FIELD_GAP;
        [textFieldPhoneNumber setFrame:frame];
    }
}

- (void)changeFramesForOthers{
    
    int addition=0;
    for (int i=1; i<4; i++) {
        
        UIView *lastView;
        
        if (i==1) {
            
            lastView = (UIView *)lblDescription;
            addition = 20;
        }
        else{
            
            lastView = (UIView *)[containerView viewWithTag:i-1];
            addition = 10;
        }
        
        UIView *currentView = (UIView *)[containerView viewWithTag:i];
        
        CGRect frame = currentView.frame;
        
        frame.origin.y = lastView.frame.origin.y+lastView.frame.size.height+10;
        
        [currentView setFrame:frame];
    }
    
    
}

- (void)changeCustomAlert{
        
    for (UIView *view in containerView.subviews) {
        
        if ([view isKindOfClass:[AlertViewShow class]]) {
            
            [view setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2)];
            
            break;
        }
    }
}

@end
