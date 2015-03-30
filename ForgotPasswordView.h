//
//  ForgotPasswordView.h
//  Conasys
//
//  Created by user on 6/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface ForgotPasswordView : BaseView{
    
    IBOutlet UITextField *textFieldEmail;
    
    void(^ completionBlock)(id data, int buttonTag, BOOL result);
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

- (IBAction)sendButtonTapped:(UIButton *)sender;
- (void)addLeftLabelsForTextFields;

@end
