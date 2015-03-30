//
//  AVCameraManager.h
//  MyCamera
//
//  Created by user on 3/27/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVCamViewController.h"
#import "Macros.h"
#import "BaseManager.h"

@interface AVCameraManager : BaseManager<AVCamFunctionalDelegate>{
    
    void(^ completionHandler)(id data, BOOL result);
}


+ (id)sharedManager;

- (void)recordVideo:(id)controller andCompletionHandler:(void(^)(id data, BOOL result))block;

- (void)capturePhoto:(id)controller andCompletionHandler:(void(^)(id data, BOOL result))block;

@end
