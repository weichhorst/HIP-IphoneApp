//
//  ForgotPasswordView.m
//  Conasys
//
//  Created by user on 6/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ForgotPasswordView.h"

@interface ForgotPasswordView ()

@end

@implementation ForgotPasswordView


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        completionBlock = myBlock;
        
    }
    return self;
}



- (void)addLeftLabelsForTextFields{
    
    [textFieldEmail addLeftLabelToMyTextField:@"     " andWidth:55];
}


- (IBAction)sendButtonTapped:(UIButton *)sender{
    
    
}

- (IBAction)btnCloseClicked:(UIButton *)sender{
    
    
    completionBlock(nil, (int)sender.tag, YES);
}

@end
