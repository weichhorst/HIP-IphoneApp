//
//  OwnerSignatureView.m
//  Conasys
//
//  Created by user on 7/5/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerSignatureView.h"

@implementation OwnerSignatureView


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        completionBlock = myBlock;
    }
    return self;
}

- (IBAction)btnConfirmEdit:(UIButton *)sender
{
    [sender setUserInteractionEnabled:NO];
    [self performSelector:@selector(enableButton:) withObject:sender afterDelay:0.5];
    completionBlock(self, sender.tag, _isOwnerSignView?YES:NO);
}

- (void)enableButton:(UIButton *)sender{
    
    [sender setUserInteractionEnabled:YES];
}

- (void)setSignatureForView:(NSString *)imageBase64String{
    
    if (imageBase64String.length>10) {
        
        [_confirmSignImg setImage:[UIImage imageWithData:[NSData dataFromBase64String:imageBase64String]]];
        
    }
    else{
        [_confirmSignImg setImage:[UIImage imageNamed:@""]];
    }
}

- (void)setDataForView:(NSString *)nickName andTitle:(NSString *)title{
    
    [_lblTitle setText:title];
    [_lblNickName setText:nickName];
    
    [_lblTitle setFont:[UIFont semiBoldWithSize:13.0f]];
    [_lblNickName setFont:[UIFont regularWithSize:13.0f]];
    
    [_lblTitle setTextColor:[UIColor darkGrayColor]];
    [_lblNickName setTextColor:[UIColor darkGrayColor]];
}

- (void)setBoldTitle{
    
    [_lblTitle setFont:[UIFont semiBoldWithSize:13.0f]];
}

- (void)changeNickName:(NSString *)nickName{
    
    [_lblNickName setText:nickName];
    
}

@end
