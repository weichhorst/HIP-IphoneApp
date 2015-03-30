//
//  BuilderProjectTileView.m
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BuilderProjectTileView.h"


@implementation BuilderProjectTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, BOOL result))myBlock
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        completionBlock = myBlock;
    }
    return self;
}


- (void)setDataToView:(Project *)project{
    
    
    [imageViewBuilding setImageWithURL:[NSURL URLWithString:[project.logohref stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    [addressLabel setText:project.address];
    [addressLabel sizeToFit];
    CGRect frame = addressLabel.frame;

    frame.size.height = addressLabel.frame.size.height;
    [addressLabel setFrame:frame];
    
    [self localizeObjects];
}


- (void)localizeObjects{
    
    [staticAddressLabel setText:NSLocalizedString(@"Builder_Project_Tile_Address", @"")];
    [staticAddressLabel setFont:[UIFont semiBoldWithSize:13.0f]];
    
    [addressLabel setFont:[UIFont regularWithSize:13.0f]];
}


- (IBAction)projectTileClicked:(UIButton *)sender{
    
    completionBlock(nil, YES);
}


@end
