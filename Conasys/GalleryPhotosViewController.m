//
//  GalleryPhotosViewController.m
//  TestingPurposeApp
//
//  Created by user on 7/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "GalleryPhotosViewController.h"
#import "ReviewItemImage.h"
#import "CategoryHeaderFile.h"

#define CELL_WIDTH 120
#define CELL_HEIGHT 120

@interface GalleryPhotosViewController ()

@end

@implementation GalleryPhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    previousArray = [NSMutableArray new];
    _myAssetArray = [NSMutableArray new];
    
    [previousArray addObjectsFromArray:_checkedAssetsArray];
    [self getAllPictures];
    [self getCollectionView];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}


- (void)setArrayWithCompletionBlock:(NSMutableArray *)asset completionHandler:(void(^) (id response, NSError *error, BOOL result))block{
    
    completionBlock = block;
}


- (void)done:(UIBarButtonItem *)button{
    
    int counter = 0;
    for (ReviewItemImage *asset in _myAssetArray) {
       
        counter++;
        ALAssetRepresentation *assetRepresentation = [asset.alAsset defaultRepresentation];
        NSData * data = UIImageJPEGRepresentation([UIImage imageWithCGImage:assetRepresentation.fullScreenImage], 0.1);
        asset.base64String = [data base64EncodedString];
    }
    
    completionBlock(_myAssetArray, nil, YES);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)cancel:(UIBarButtonItem *)button{
    
    completionBlock(previousArray, nil, NO);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}


#pragma mark - Photo Gallery

-(void)getAllPictures
{
    self.assetsArray = [[NSMutableArray alloc]init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.assetLibrary = library;
    NSMutableArray *groups = [NSMutableArray array];
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {

            [self displayPickerForGroup:[groups objectAtIndex:0]];
        }
    } failureBlock:^(NSError *error) {
        
        
        [Utility showAlert:NSLocalizedString(@"Gallery_Album_Error", @"") andMessage:@""];
        
    }];
}


//=================================================================================
- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    self.assetsGroup = group;
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    [self preparePhotos];
}


//==================================================================================

-(void)preparePhotos{
    
    
    ReviewItemImage *sharedObject = [ReviewItemImage sharedAsset];
    
    [sharedObject setReviewItemRowId:self.reviewItem.reviewItemRowId];
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if(result == nil) {
            
            return;
        }
        
        [self.assetsArray addObject:[[ReviewItemImage sharedAsset] getImageInfo:result]];
    }];
    
    [self compareArray];
    
    [collectionTable reloadData];
}


- (void)compareArray{
    
    
    for (ReviewItemImage *existingAsset in _checkedAssetsArray) {
        
        for (ReviewItemImage *asset in self.assetsArray) {
            
            if ([existingAsset.itemImagePath isEqualToString:asset.itemImagePath]) {
                
                asset.isSelectedAsset = YES;
                
                [_myAssetArray addObject:asset];
            }
            
        }
    }
    
}



#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.assetsArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    ReviewItemImage *reviewItemImage  = (ReviewItemImage *)[self.assetsArray objectAtIndex:indexPath.row];
    
    [cell.overlayView setHidden:!reviewItemImage.isSelectedAsset];
    cell.imageView.image = [UIImage imageWithCGImage:reviewItemImage.alAsset.thumbnail];
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    ReviewItemImage *reviewItemImage  = (ReviewItemImage *)[self.assetsArray objectAtIndex:indexPath.item];

    reviewItemImage.isSelectedAsset = !reviewItemImage.isSelectedAsset;
    
    [cell.overlayView setHidden:!reviewItemImage.isSelectedAsset];
    
    if (reviewItemImage.isSelectedAsset) {
        
        [_myAssetArray addObject:reviewItemImage];
    }
    else{
        
        [_myAssetArray removeObject:reviewItemImage];
    }
    
    [self.assetsArray replaceObjectAtIndex:indexPath.row withObject:reviewItemImage];
}



-(void)getCollectionView
{
    
    UINib *cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [collectionTable registerNib:cellNib forCellWithReuseIdentifier:@"CollectionViewCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CELL_WIDTH, CELL_HEIGHT)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [collectionTable setCollectionViewLayout:flowLayout];
}

@end
