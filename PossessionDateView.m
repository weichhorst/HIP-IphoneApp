//
//  PossessionDateView.m
//  Conasys
//
//  Created by user on 6/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "PossessionDateView.h"
#import "DateFormatter.h"

@interface PossessionDateView ()

@end

@implementation PossessionDateView

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        completionBlock = myBlock;
        
    }
    
    
    return self;
}

- (void)addNotificationToDatePicker{
    
    [btnSave roundedBorderWithWidth:0.0 radius:4.0 andColor:[UIColor clearColor]];
    [lblPossessionDate setText:NSLocalizedString(@"PossessionDateView_Possession", @"")];
    [lblPossessionDate setFont:[UIFont semiBoldWithSize:16.0f]];
    
    [myDatePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (![Utility isiOSVersion7]) {
        
    }
}

- (void)valueChanged:(UIDatePicker *)datePicker{

    [labelDate setText:[NSString stringWithFormat:@"%@", datePicker.date]];
    
}

- (void)setCurrentDate:(NSString *)dateString{
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(sysVer >= 8.0) {
        [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil]; // for iOS 8
    } else {
        [[UITableViewCell appearanceWhenContainedIn:[UIDatePicker class], [UITableView class], nil] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]]; // for iOS 7
    }
    if (dateString.length>1) {

        [myDatePicker setDate:[[DateFormatter sharedFormatter] getDateFromString:dateString]];
    }

}


- (IBAction)btnCloseClicked:(UIButton *)sender{
    
    
    completionBlock(nil, (int)sender.tag, YES);
}

- (IBAction)btnSaveClicked:(UIButton *)sender{
    
    completionBlock([[DateFormatter sharedFormatter]getDateStringForSubmit:myDatePicker.date], (int)sender.tag, YES);
}
@end
