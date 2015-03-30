//
//  ServiceReviewCell.h
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseCell.h"

@interface ServiceReviewCell : BaseCell{
    
    __weak IBOutlet UILabel *lblUnitNumber, *lblOwnerReg, *lblCompletionDate,  *lblPossessionDate;
    
    IBOutlet UILabel *lblAddress;
    __weak IBOutlet UIButton *startButton;
    
    void(^clickHandler)(id data, BOOL isClicked);
}

- (IBAction)startButtonClicked:(UIButton *)sender;

- (void)setCellData:(Unit *)unit withStartHandler:(void(^)(id data, BOOL isClicked))block;

+ (CGFloat)maxHeightOfCell:(NSString *)address;

@end
