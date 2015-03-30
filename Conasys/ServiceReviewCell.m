//
//  ServiceReviewCell.m
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ServiceReviewCell.h"

@implementation ServiceReviewCell

#define SERVICE_NIB @"ServiceReviewCell"

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (IBAction)startButtonClicked:(UIButton *)sender{
    
    clickHandler(nil, YES);
}


//setting cell data here.
- (void)setCellData:(Unit *)unit withStartHandler:(void(^)(id data, BOOL isClicked))block{
    
    [self setCustomFonts];
    
    [lblCompletionDate setHidden:YES];
    [lblUnitNumber setText:unit.unitNumber];
    [lblAddress setText:unit.address];
    [lblAddress sizeToFit];
    
    [lblCompletionDate setText:unit.completionDate];
    [lblPossessionDate setText:unit.possessionDate];
    [lblOwnerReg setText:unit.ownersList.count?NSLocalizedString(@"Service_Cell_YES", @""):NSLocalizedString(@"Service_Cell_NO", @"")];
    clickHandler = block;
    
    if (unit.isPendingUnit) {

        [startButton setImage:[UIImage imageNamed:@"btn_inprogress.png"] forState:UIControlStateNormal];
    }
    [self reframeSubviews];
}


- (void)reframeSubviews{
    
    CGPoint center;
    for (UIView *view in self.contentView.subviews) {
        
        center = view.center;
        center.y = self.contentView.frame.size.height/2;
        [view setCenter:center];
    }
}

- (void)setCustomFonts{
    
    [lblUnitNumber setFont:[UIFont regularWithSize:14.0f]];
    [lblAddress setFont:[UIFont regularWithSize:14.0f]];
    [lblOwnerReg setFont:[UIFont regularWithSize:14.0f]];
    [lblCompletionDate setFont:[UIFont regularWithSize:14.0f]];
    [lblPossessionDate setFont:[UIFont regularWithSize:14.0f]];
}

//Getting cell height here.
+ (CGFloat)maxHeightOfCell:(NSString *)address{
    
    ServiceReviewCell *cell = [[[NSBundle mainBundle]loadNibNamed:SERVICE_NIB owner:nil options:nil] objectAtIndex:0];
    return [cell getHeight:address];
}


- (CGFloat)getHeight:(NSString *)address{
    
    [self setCustomFonts];
    [lblAddress setText:address];
    [lblAddress sizeToFit];
    [self reframeSubviews];
    return (lblAddress.frame.origin.y*2) + lblAddress.frame.size.height;
}

@end
