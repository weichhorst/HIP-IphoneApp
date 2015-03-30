//
//  OwnerIdentificationCell.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerIdentificationCell.h"

@implementation OwnerIdentificationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// setting cell data here.
- (void)setCellData:(ReviewOwner *)reviewOwner withClickHandler:(void(^)(id data, BOOL isClicked))block andOwnerSelectionHandler:(void(^)(id data, BOOL isSelected))checkBlock{

    Owner *owner = reviewOwner.owner;
    
    [self setFonts];
    [labelOwnerName setText:[NSString stringWithFormat:@"%@ %@", owner.firstName, owner.lastName]];
    [labelEmail setText:owner.email];
    [labelPhone setText:owner.phoneNumber];
    [buttonCheck setSelected:reviewOwner.isSelectedOwner];
    clickHandler = block;
    selectionHandler = checkBlock;
}


- (void)setFonts{
    
    [labelOwnerName setFont:[UIFont regularWithSize:14.0f]];
    [labelEmail setFont:[UIFont regularWithSize:14.0f]];
    [labelPhone setFont:[UIFont regularWithSize:14.0f]];
}

// Block will be called to open the editing view in it's parent tableview.
- (IBAction)buttonEditClicked:(UIButton *)sender{
    
    [sender setEnabled:NO];
    clickHandler(nil, YES);
    [self performSelector:@selector(enableButton) withObject:nil afterDelay:1.0];
}

- (void)enableButton{
    
    [btnEdit setEnabled:YES];
}

// Selection of various owners.
- (IBAction)buttonCheckClicked:(UIButton *)sender{
    
    [sender setSelected:!sender.isSelected];
    selectionHandler(nil, sender.isSelected);
}

@end
