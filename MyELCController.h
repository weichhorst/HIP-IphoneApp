//
//  MyELCController.h
//  ELCImagePickerDemo
//
//  Created by user on 6/30/14.
//  Copyright (c) 2014 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELCImagePickerController.h"
#import "ItemDescription.h"



@interface MyELCController : NSObject<ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>{
    
    void(^ completionBlock)(id data, BOOL result);
    
    NSMutableArray *myAssetArray;

}

@property (nonatomic, retain)id controller;
@property (nonatomic, retain) ItemDescription *itemDescription;

+ (id)shareController;

- (void)openGalleryAndGetAssetsOnController:(id)controller withSelectedItem:(NSMutableArray *)array withCompletionBlock:(void(^)(id data, BOOL result))block;

- (IBAction)launchController:(NSMutableArray *)allAssetsArray;


@end
