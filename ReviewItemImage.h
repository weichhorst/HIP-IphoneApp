//
//  ReviewItemImage.h
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface ReviewItemImage : BaseModel

@property (nonatomic, retain)NSString *base64String;
@property (nonatomic, readwrite)long long reviewItemImageRowId;
@property (nonatomic, readwrite)int reviewItemRowId;
@property (nonatomic, retain)NSString *itemImagePath;

@property (nonatomic, retain)ALAsset *alAsset;
@property (nonatomic, readwrite)BOOL isSelectedAsset;

+ (id)sharedAsset;
- (void)getAllAssetsFromArray:(NSArray *)array withCompletionBlock:(void(^)(id data, BOOL result))block;
- (id)getImageInfo:(ALAsset *)asset;

@end
