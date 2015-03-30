//
//  UnitEnrollmentView.m
//  Conasys
//
//  Created by user on 6/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UnitEnrollmentView.h"

@interface UnitEnrollmentView ()

@end

@implementation UnitEnrollmentView


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        completionBlock = myBlock;
        
    }
    return self;
}

- (IBAction)btnCloseClicked:(UIButton *)sender{
    
    
    completionBlock(@"", (int)sender.tag, YES);
}


- (void)setEnrollmentNumber:(NSString *)enrollmentNumber{
    
    [textFieldEnrollmentNumber setText:enrollmentNumber];
    
    [textFieldEnrollmentNumber setPlaceholder:NSLocalizedString(@"UnitEnrollmentView_Enroll_PlaceHolder", @"")];
    [lblEnrollmentNumber setText:NSLocalizedString(@"UnitEnrollmentView_Label_Enrollment", @"")];
    
    [btnSave setTitle:NSLocalizedString(@"UnitEnrollmentView_Btn_Title", @"") forState:UIControlStateNormal];
    
    [btnSave roundedBorderWithWidth:0.0 radius:4.0 andColor:[UIColor clearColor]];
    
    [lblEnterNumber setFont:[UIFont semiBoldWithSize:11.0f]];
    
    [textFieldEnrollmentNumber addLeftLabelToMyTextField:@"        " andWidth:70.0f];
    
    [lblEnterNumber setTextColor:[UIColor darkGrayColor]];
    [lblEnrollmentNumber setTextColor:[UIColor darkGrayColor]];
    [textFieldEnrollmentNumber setTextColor:[UIColor darkGrayColor]];
    
    [self setFonts];
}

- (void)setFonts{
    
    [textFieldEnrollmentNumber setFont:[UIFont regularWithSize:14.0f]];
    [lblEnrollmentNumber setFont:[UIFont semiBoldWithSize:17.0f]];
    [btnSave.titleLabel setFont:[UIFont semiBoldWithSize:17.0F]];
}

- (IBAction)btnSaveClicked:(UIButton *)sender{
    
    completionBlock(textFieldEnrollmentNumber.text, (int)sender.tag, YES);
    return;
}

@end
