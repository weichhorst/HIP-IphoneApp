//
//  MyAsset.h
//  MyCamera
//
//  Created by user on 3/28/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "ItemDescription.h"

@interface MyAsset : BaseModel


@property (nonatomic, retain)ALAsset *alAsset;
@property (nonatomic, retain)NSString *UTI;
@property (nonatomic, readwrite)float scale;
@property (nonatomic ,readwrite)long long size;
@property (nonatomic, retain)NSString *fileName;
@property (nonatomic, readwrite)int orientation;
@property (nonatomic, readwrite)CGSize dimensions;
@property (nonatomic, retain)UIImage *fullScreenImage;
@property (nonatomic, retain)UIImage *fullResolutionImage;
@property (nonatomic, retain)NSDictionary *metadata;
@property (nonatomic, retain)NSURL *url;
@property (nonatomic, retain)ALAsset *originalAsset;
@property (nonatomic, retain)UIImage *thumbnail;
@property (nonatomic, readwrite)BOOL isSelectedAsset;

// New parameters
@property (nonatomic, readwrite)long long itemDescRowId;
@property (nonatomic, readwrite)int itemId;
@property (nonatomic, retain)NSString *itemImagePath;
@property (nonatomic, retain)NSString *base64String;

@property (nonatomic, retain)ItemDescription *itemDescription;

+ (id)sharedAsset;

- (id)getAssetInfo:(ALAsset *)asset;

- (void)getAllAssetsFromArray:(NSArray *)array withCompletionBlock:(void(^)(id data, BOOL result))block;

@end
