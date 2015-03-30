//
//  EditOwnerView.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "EditOwnerView.h"
#import "OwnerDBManager.h"
#import "ConasysRequestManager.h"
#import "Utility.h"
#import "AlertViewShow.h"


#define BOTTOM_VIEW_FRAME_PORTRAIT CGRectMake(0, 165, 320, 129)
#define BOTTOM_VIEW_FRAME_LANDSCAPE CGRectMake(320, 33, 320, 129)

#define SELF_VIEW_FRAME_PORTRAIT CGRectMake(352, 181, 320, 352)
#define SELF_VIEW_FRAME_LANDSCAPE CGRectMake(190, 261, 640, 223)



@implementation EditOwnerView


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


- (void)setDataForView:(Owner *)owner{
    
    self.owner = owner;
    
    [lblUsername setText:owner.userName];
    [textFieldFirstName setText:owner.firstName];
    [textFieldLastName setText:owner.lastName];
    [textFieldEmail setText:owner.email];
    [textFieldPhoneNumber setText:owner.phoneNumber];
    [btnCheckBox setSelected:owner.enableEmailNotification.intValue];
    
    [btnSave roundedBorderWithWidth:0.0 radius:4.0 andColor:[UIColor clearColor]];
}


- (void)addLeftLabelsForTextFields{


    [textFieldFirstName addLeftLabelToMyTextField:NSLocalizedString(@"Edit_Owner_Label_First_Name", @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    [textFieldLastName addLeftLabelToMyTextField:NSLocalizedString(@"Edit_Owner_Label_Last_Name", @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    [textFieldEmail addLeftLabelToMyTextField:NSLocalizedString(@"Edit_Owner_Label_Email", @"") andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    [textFieldPhoneNumber addLeftLabelToMyTextField:@"    " andWidth:95 bold:YES andColor:[UIColor darkGrayColor]];
    
    textFieldFirstName.placeholder = textFieldLastName.placeholder = textFieldEmail.placeholder = textFieldPhoneNumber.placeholder = NSLocalizedString(@"Edit_Owner_Label_Required", @"");
    
//    [self setKeyBoardNotifications];
    
    [self localizeObjects];
}

- (void)localizeObjects{
    
    
    [lblHeader setText:NSLocalizedString(@"Edit_Owner_Header", @"")];
    
    [lblStaticUsername setText:NSLocalizedString(@"Edit_Owner_Label_Username", @"")];
    [lblPhonenumber setText:NSLocalizedString(@"Edit_Owner_Label_Phone_Number", @"")];
    [lblRecieveEmail setText:NSLocalizedString(@"Edit_Owner_Label_Receive_Email", @"")];
    [btnSave setTitle:NSLocalizedString(@"Edit_Owner_Btn_Save", @"") forState:UIControlStateNormal];
    
    [self setFonts];
    
}

- (void)setFonts{
    
    [lblHeader setFont:[UIFont semiBoldWithSize:17.0f]];
    [lblStaticUsername setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblPhonenumber setFont:[UIFont semiBoldWithSize:12.0f]];
    [lblRecieveEmail setFont:[UIFont lightWithSize:12.0f]];
    
    [btnSave.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    
    [lblUsername setFont:[UIFont regularWithSize:14.0f]];
    
    [textFieldEmail setFont:[UIFont regularWithSize:14.0f]];
    [textFieldFirstName setFont:[UIFont regularWithSize:14.0f]];
    [textFieldLastName setFont:[UIFont regularWithSize:14.0f]];
    [textFieldPhoneNumber setFont:[UIFont regularWithSize:14.0f]];
    
    [buttonClose.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];

}


- (IBAction)btnCloseClicked:(UIButton *)sender{
    
//    [self removeObservers];
    completionBlock(nil, (int)sender.tag, YES);
}


- (IBAction)saveButtonClicked:(UIButton *)sender{
    
    
    if ([self validFields]) {
    //15-sept-2014        
//        if (isConnected) {
        
            
            
            NSMutableDictionary *dict  = [NSMutableDictionary dictionaryWithObjectsAndKeys:CURRENT_USER_TOKEN, EDIT_OWNER_TOKEN,CURRENT_USERNAME , EDIT_OWNER_BUILDER_NAME_KEY, textFieldEmail.text , EDIT_OWNER_EMAIL_KEY,textFieldFirstName.text , EDIT_OWNER_FIRST_NAME_KEY,btnCheckBox.isSelected?@"true":@"false" ,EDIT_OWNER_EMAIL_PERMISS_KEY,textFieldLastName.text , EDIT_OWNER_LAST_NAME_KEY,textFieldPhoneNumber.text , EDIT_OWNER_PHONE_NUMBER_KEY,lblUsername.text , EDIT_OWNER_USERNAME_KEY ,nil];
            
            completionBlock(dict, sender.tag, YES);
            
//        }
//        else{
//            
//            [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Edit_Owner_Save_Network_Error", @"") onView:containerView]];
//            
//        }
    }
    
}


- (BOOL)validFields{
    
    NSString *phoneString = [textFieldPhoneNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    BOOL result = YES;
    
    [self endEditing:YES];
    
    if(textFieldFirstName.text.length==0||textFieldEmail.text.length==0||textFieldLastName.text.length==0)
    {
        
        [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Edit_Owner_Blank_Error", @"") onView:containerView]];
        
        result = NO;
    }
    else if (![Utility validateEmail:textFieldEmail.text]){
        
        
        [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(@"Edit_Owner_Invalid_Email_Error", @"") onView:containerView]];
        result = NO;
    }
    
    else if (phoneString.length && phoneString.length != 10) {
        
        [containerView addSubview:[Utility showCustomAlertWithMessage:NSLocalizedString(phoneString.length>10?@"Register_Owner_Invalid_PhoneNumber_Error":@"Register_Owner_Invalid_PhoneNumber_Lesser_Error" , @"") onView:containerView]];
        
        result = NO;
    }
    
    return result;
}




- (void)changeCustomAlert{
        
    for (UIView *view in containerView.subviews) {
        
        if ([view isKindOfClass:[AlertViewShow class]]) {
            
            [view setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2)];
            
            break;
        }
    }
}

- (IBAction)btnCheckboxClicked:(UIButton *)sender{
    
    [sender setSelected:!sender.isSelected];
}

- (void)upTheView:(UIView *)editingView{
    
    
}

- (void)downTheView:(UIView *)editingView{
    
}


- (void)keyboardFrameUp:(NSNotification *)notification{
    
    CGRect frame = [self frame];
    frame.origin.y = [self locationTypePortrait]?self.frame.origin.y:100;
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
    }
    else{

        [bottomView setFrame:BOTTOM_VIEW_FRAME_LANDSCAPE];
        [containerView setFrame:SELF_VIEW_FRAME_LANDSCAPE];
        
    }
    
    [self changeCustomAlert];
}

@end
