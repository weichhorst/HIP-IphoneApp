//
//  OwnerUploader.h
//  Conasys
//
//  Created by user on 9/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerUploader : NSObject{
    
    void(^ completionBlock)(id data, BOOL result);
    int counter;
}


- (void)checkAndUploadOwnersWithCompletionBlock:(void(^)(id data, BOOL result))myBlock;

@end
