//
//  MyAsset.m
//  MyCamera
//
//  Created by user on 3/28/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "MyAsset.h"
#import "ItemImage.h"

@implementation MyAsset

static MyAsset *myStaticAsset =nil;


+ (id)sharedAsset{
    
    if (!myStaticAsset) {
        
        myStaticAsset = [[MyAsset alloc]init];
    }
    
    return myStaticAsset;
}


- (void)getAllAssetsFromArray:(NSArray *)array withCompletionBlock:(void(^)(id data, BOOL result))block{
    
    NSMutableArray *myAssetArray = [NSMutableArray new];
    
    for (ALAsset *asset in array) {
        
        [myAssetArray addObject:[self getAssetInfo:asset]];
    }
        
    block(myAssetArray, myAssetArray.count?YES:NO);
}


- (id)getAssetInfo:(ALAsset *)asset{
    
    MyAsset *myAsset = [[MyAsset alloc]init];
    
    myAsset.alAsset = asset;
//    myAsset.originalAsset = asset.originalAsset;
    
//    myAsset.thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
    
//    myAsset.UTI = assetRepresentation.UTI;
    
//    myAsset.fullResolutionImage = [UIImage imageWithCGImage:assetRepresentation.fullResolutionImage];
//    
//    myAsset.fullScreenImage = [UIImage imageWithCGImage:assetRepresentation.fullScreenImage];
    
//    myAsset.orientation = assetRepresentation.orientation;
    
//    myAsset.metadata = assetRepresentation.metadata;
    
//    myAsset.dimensions = assetRepresentation.dimensions;
    
//    myAsset.size = assetRepresentation.size;
//    myAsset.scale = assetRepresentation.scale;
    
    
//    myAsset.fileName = assetRepresentation.filename;
//    myAsset.url = assetRepresentation.url;
    
    
//    NSData * data = [UIImageJPEGRepresentation(myAsset.fullScreenImage, 0.1) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    myAsset.base64String = [NSString stringWithUTF8String:[data bytes]];

    myAsset.itemImagePath = [NSString stringWithFormat:@"%@", assetRepresentation.url];
    
    if (self.itemDescription) {

        myAsset.itemDescRowId = self.itemDescription.itemDescRowId;
        myAsset.itemId = self.itemDescription.itemId;

    }
    
    return myAsset;

}


@end
