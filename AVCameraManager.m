//
//  AVCameraManager.m
//  MyCamera
//
//  Created by user on 3/27/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "AVCameraManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AVCamViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ReviewItemImage.h"

@implementation AVCameraManager


static AVCameraManager *avCameraManager = nil;

+ (id)sharedManager{
    
    if (!avCameraManager) {
        
        avCameraManager = [[AVCameraManager alloc]init];
    }
    
    return avCameraManager;
}


- (void)recordVideo:(id)controller andCompletionHandler:(void(^)(id data, BOOL result))block{

    
    completionHandler = block;
    
    [self openAvcamOnController:controller isVideo:YES];
    
}


- (void)capturePhoto:(id)controller andCompletionHandler:(void(^)(id data, BOOL result))block{
    
    completionHandler=block;
    [self openAvcamOnController:controller isVideo:NO];
}

- (void)openAvcamOnController:(UIViewController *)controller isVideo:(BOOL)isVideoType{
    
    UIViewController *controller1 = (UIViewController *)controller;
    
    AVCamViewController *avCamViewController = [[UIStoryboard storyboardWithName:@"AVCam_Main_iPad" bundle:Nil] instantiateViewControllerWithIdentifier:@"avCam"];
    
    avCamViewController.avCamFunctionalDelegate = self;
    
    [avCamViewController setIsRecording:isVideoType];
    
    [avCamViewController setCameraPresetSession:[self getPreset:2]]; // rightnow it's low.
    
    if ([Utility isiOSVersion7]) {
    
        [controller1 presentViewController:avCamViewController animated:YES completion:^{
            
        }];
    }
    else{
        
        [controller1 presentModalViewController:avCamViewController animated:YES];
    }
}


#pragma mark - Camera Delegate


- (void)assetSavedAtURL:(NSURL *)mediaURL isSuccessful:(BOOL)result{
    

    if (!result) {
        
        completionHandler(nil, result);
        return;
    }
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:mediaURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        
        ReviewItemImage *myAsset = [[ReviewItemImage sharedAsset] getImageInfo:asset];
        
        NSData * data = UIImageJPEGRepresentation([UIImage imageWithCGImage:assetRepresentation.fullScreenImage], 0.1);
        
        myAsset.base64String =  [data base64EncodedString];

        completionHandler(result?myAsset:nil, result);
        
        
    } failureBlock:^(NSError *error) {
        
        completionHandler(nil, result);

    }];
}


- (NSString *)getPreset:(int)qualityType{
    
    switch (qualityType) {
        case 0:
            
            return AVCaptureSessionPresetPhoto;
        case 1:
            
            return AVCaptureSessionPresetHigh;
        case 2:
            
            return AVCaptureSessionPresetMedium;
        case 3:
            
            return AVCaptureSessionPresetLow;
        case 4:
            
            return AVCaptureSessionPreset352x288;
        case 5:
            
            return AVCaptureSessionPreset640x480;
        case 6:
            
            return AVCaptureSessionPreset1280x720;
        case 7:
            
            return AVCaptureSessionPresetiFrame960x540;
        case 8:
            
            return AVCaptureSessionPresetiFrame1280x720;
            
        default:
            break;
    }
    
    return AVCaptureSessionPresetPhoto;
}


@end
