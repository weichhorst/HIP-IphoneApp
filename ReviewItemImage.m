//
//  ReviewItemImage.m
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewItemImage.h"

@implementation ReviewItemImage


static ReviewItemImage *reviewItemImage =nil;

+ (id)sharedAsset{
    
    if (!reviewItemImage) {
        
        reviewItemImage = [[ReviewItemImage alloc]init];
    }
    
    return reviewItemImage;
}


- (void)getAllAssetsFromArray:(NSArray *)array withCompletionBlock:(void(^)(id data, BOOL result))block{
    
    NSMutableArray *myAssetArray = [NSMutableArray new];
    
    for (ALAsset *asset in array) {
        
        [myAssetArray addObject:[self getImageInfo:asset]];
    }
    
    block(myAssetArray, myAssetArray.count?YES:NO);
}



- (id)getImageInfo:(ALAsset *)asset{
    
    ReviewItemImage *reviewItemImage = [[ReviewItemImage alloc]init];
    
    reviewItemImage.alAsset = asset;
    
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
    
    reviewItemImage.itemImagePath = [NSString stringWithFormat:@"%@", assetRepresentation.url];
    
    if (self.reviewItemRowId) {
        
        reviewItemImage.reviewItemRowId = self.reviewItemRowId;
    }
    
    return reviewItemImage;    
}



@end
