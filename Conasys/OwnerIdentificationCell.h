//
//  OwnerIdentificationCell.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseCell.h"

@interface OwnerIdentificationCell : BaseCell{
    
    IBOutlet UILabel *labelOwnerName, *labelEmail, *labelPhone;
    IBOutlet UIButton *buttonEdit, *buttonCheck;
    void(^clickHandler)(id data, BOOL isClicked);
    void(^selectionHandler)(id data, BOOL isSelected);
    
    IBOutlet UIButton *btnEdit;
}

- (void)setCellData:(ReviewOwner *)owner withClickHandler:(void(^)(id data, BOOL isClicked))block andOwnerSelectionHandler:(void(^)(id data, BOOL isSelected))checkBlock;

- (IBAction)buttonEditClicked:(UIButton *)sender;
- (IBAction)buttonCheckClicked:(UIButton *)sender;

@end
