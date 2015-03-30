//
//  SubmitReviewCell.h
//  Conasys
//
//  Created by user on 7/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseCell.h"

@interface SubmitReviewCell : BaseCell
{
    
    IBOutlet UILabel *lblItemNumber;
    IBOutlet UILabel *lblProduct;
    IBOutlet UILabel *lblDescription;
}


- (void)setData:(id)data;
+ (CGFloat)heightForCell:(ReviewItem *)reviewItem;
- (CGFloat)maxRowSize:(ReviewItem *)reviewItem;

@end
