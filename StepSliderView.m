//
//  StepSliderView.m
//  Conasys
//
//  Created by user on 5/15/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "StepSliderView.h"
#import "HeaderFiles.h"

@implementation StepSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL result))myBlock
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        completionBlock = myBlock;
        
    }
    return self;
}




- (void)selectStep:(int)stepNumber{
    
    [self localizeObjects];
    
    NSArray *subViews = [[self.subviews objectAtIndex:0] subviews];
    
    for (UIView *view in subViews) {
        
         if([view isKindOfClass:[UILabel class]]){
            
            UILabel *lbl = (UILabel *)view;
            [UIView animateWithDuration:0.5f animations:^{
                
                [lbl setTextColor:view.tag<stepNumber?COLOR_BLUE_APP:[UIColor lightGrayColor]];
                
            }];
        }
         else if(view.tag!=-1){
             
             [UIView animateWithDuration:0.5f animations:^{
                 

                 [view setBackgroundColor:view.tag<stepNumber?COLOR_BLUE_APP:COLOR_PAGENUMBER_BROWN];
                 
             }];
         }
    }
}


- (void)localizeObjects{
    
    [lblReviewItems setText:NSLocalizedString(@"Step_Slider_Review_Item", @"")];
    [lblConfirmation setText:NSLocalizedString(@"Step_Slider_Confirmation", @"")];
    [lblOwnerIdentification setText:NSLocalizedString(@"Step_Slider_Identification", @"")];
    
    [lblReviewItems setFont:[UIFont regularWithSize:14.0f]];
    [lblConfirmation setFont:[UIFont regularWithSize:14.0f]];
    [lblOwnerIdentification setFont:[UIFont regularWithSize:14.0f]];
    
    [firstButton.titleLabel setText:NSLocalizedString(@"Step_Slider_Review_First", @"")];
    [secondButton.titleLabel setText:NSLocalizedString(@"Step_Slider_Review_Second", @"")];
    [thirdButton.titleLabel setText:NSLocalizedString(@"Step_Slider_Review_Third", @"")];
    
    [firstButton.titleLabel setFont:[UIFont semiBoldWithSize:14.0f]];
    [secondButton.titleLabel setFont:[UIFont semiBoldWithSize:14.0f]];
    [thirdButton.titleLabel setFont:[UIFont semiBoldWithSize:14.0f]];
    
}

- (void)changeTitleIsPDI:(BOOL)flag{
    
    [lblOwnerIdentification setText:flag?NSLocalizedString(@"Step_Slider_Identification", @""):NSLocalizedString(@"Step_Slider_Identification_Construction", @"")];
}

- (void)makeButtonsRounded{
    
    NSArray *subViews = [[self.subviews objectAtIndex:0] subviews];

    for (UIView *view in subViews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            [view roundedBorderWithWidth:0.0f radius:view.frame.size.width/2 andColor:[UIColor clearColor]];
        }
    }
}


- (IBAction)btnStepsClicked:(UIButton *)sender{
    
    completionBlock(nil, (int)sender.tag, YES);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
