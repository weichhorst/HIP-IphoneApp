//
//  GalleryPhotosViewController.h
//  TestingPurposeApp
//
//  Created by user on 7/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CollectionViewCell.h"
#import "BaseViewController.h"


@interface GalleryPhotosViewController : UIViewController{
    
    IBOutlet UITableView *photoTable;
    
    __weak IBOutlet UICollectionView *collectionTable;

    NSMutableArray *previousArray;
    void(^completionBlock)(id response,NSError* error, BOOL result);
    

}

//@property (nonatomic, retain) NSMutableArray *selectedAssetsArray;

@property (nonatomic, retain)NSMutableArray *myAssetArray;

@property (nonatomic, retain) NSMutableArray *checkedAssetsArray;
@property (nonatomic, retain) ALAssetsGroup *assetsGroup;
@property (nonatomic,strong) NSMutableArray* assetsArray;
@property (nonatomic, retain) ALAssetsLibrary* assetLibrary;
@property (nonatomic, retain)NSMutableArray *selectedPhotos;

@property (nonatomic, retain)id controller;
@property (nonatomic, retain)ReviewItem *reviewItem;

- (void)setArrayWithCompletionBlock:(NSMutableArray *)userInfo completionHandler:(void(^) (id response, NSError *error, BOOL result))block;


@end
