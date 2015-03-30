//
//  StepSliderView.h
//  Conasys
//
//  Created by user on 5/15/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface StepSliderView : BaseView{
    
    IBOutlet UIButton *firstButton, *secondButton, *thirdButton;
    IBOutlet UILabel *lblOwnerIdentification, *lblReviewItems, *lblConfirmation;
    void(^ completionBlock)(id data, int buttonTag, BOOL result);
}

- (void)makeButtonsRounded;

- (void)selectStep:(int)stepNumber;

- (IBAction)btnStepsClicked:(UIButton *)sender;

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL result))myBlock;

- (void)changeTitleIsPDI:(BOOL)flag;

@end
