//
//  BuilderProjectTileView.h
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"
#import "Project.h"

@interface BuilderProjectTileView : BaseView{
    
    id targetSelector;
    
    void(^ completionBlock)(id data, BOOL result);
    
    IBOutlet UIButton *buttonTile;
    
    IBOutlet UIImageView *imageViewBuilding;
    
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *staticAddressLabel;
}


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, BOOL result))myBlock;

- (IBAction)projectTileClicked:(UIButton *)sender;

- (void)setDataToView:(Project *)project;


@end
