//
//  SubmitReviewCell.m
//  Conasys
//
//  Created by user on 7/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "SubmitReviewCell.h"

@interface SubmitReviewCell ()

@end

@implementation SubmitReviewCell

- (void)setData:(ReviewItem *)data{
    
    [self setFonts];
    [lblItemNumber setText:[NSString stringWithFormat:@"%d", data.reviewItemNumber]];
    [lblItemNumber sizeToFit];

    if ([data.itemProduct isEqualToString:@"Select Product"])
        goto here;
    [lblProduct setText:data.itemProduct];
    [lblProduct sizeToFit];
    
here:
    [lblDescription setText:data.itemDescription];
    [lblDescription sizeToFit];
}


+ (CGFloat)heightForCell:(ReviewItem *)data{
    
    SubmitReviewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SubmitReviewCell" owner:nil options:nil] objectAtIndex:0];
    return [cell maxRowSize:data];
}


- (void)setFonts{
    
    lblProduct.font = lblItemNumber.font = lblDescription.font = [UIFont regularWithSize:13.0f];
}

- (CGFloat)maxRowSize:(ReviewItem *)data{
    
    [self setFonts];
    [lblProduct setText:data.itemProduct];
    [lblProduct sizeToFit];
    
    [lblDescription setText:data.itemDescription];
    [lblDescription sizeToFit];
    
    float max = lblProduct.frame.size.height+lblProduct.frame.origin.y*2;
    float second = lblDescription.frame.size.height+lblDescription.frame.origin.y*2;
    
    if(second>max){
        
        max = second;
    }
        
    return max>60?max:60;
}

@end
