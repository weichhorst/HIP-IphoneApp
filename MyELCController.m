//
//  MyELCController.m
//  ELCImagePickerDemo
//
//  Created by user on 6/30/14.
//  Copyright (c) 2014 ELC Technologies. All rights reserved.
//

#import "MyELCController.h"
#import "MyAsset.h"


@implementation MyELCController


static MyELCController *myELCController=nil;

+ (id)shareController{
    
    if (!myELCController) {
        
        myELCController = [[MyELCController alloc]init];
    }
    
    return myELCController;
    
}

- (void)openGalleryAndGetAssetsOnController:(id)controller withSelectedItem:(NSMutableArray *)array withCompletionBlock:(void(^)(id data, BOOL result))block{
    
    completionBlock = block;
    self.controller = controller;
    [self launchController:array];
    
    myAssetArray = [[NSMutableArray alloc]initWithArray:array];

}


- (IBAction)launchController:(NSMutableArray *)allAssetsArray
{
    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePickerWithArray:allAssetsArray];
    elcPicker.maximumImagesCount = 4;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
	elcPicker.imagePickerDelegate = self;
    elcPicker.previouslySelectedAsset = allAssetsArray;
    
    [self.controller presentViewController:elcPicker animated:YES completion:nil];
    
}



#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    [self.controller dismissViewControllerAnimated:YES completion:nil];
	
    MyAsset *myAsset = [MyAsset sharedAsset];
    [myAsset setItemDescription:self.itemDescription];
    [myAsset getAllAssetsFromArray:info withCompletionBlock:^(id data, BOOL result) {
            
        completionBlock(data, result);
    }];
    
}



- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
    
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    completionBlock(myAssetArray, NO);
}



@end
