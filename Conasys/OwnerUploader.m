//
//  OwnerUploader.m
//  Conasys
//
//  Created by user on 9/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerUploader.h"
#import "OwnerDBManager.h"
#import "Owner.h"
#import "OwnerRequestManager.h"
#import "ConasysRequestManager.h"

@implementation OwnerUploader


- (void)checkAndUploadOwnersWithCompletionBlock:(void(^)(id data, BOOL result))myBlock{

    counter = 0;
    
    NSMutableArray *owners = [[OwnerDBManager sharedManager]allOfflineOwners];
    
    if (owners.count) {
        
        NSLog(@"here ");
        completionBlock = myBlock;
        [self uploadOwners:owners];
    }
    else{
        
        NSLog(@"else here");
        myBlock(nil, YES);
    }
}


- (void)uploadOwners:(NSMutableArray *)owners{
    
    NSLog(@"uploading owners");
    
    for (Owner *owner in owners) {
    
        owner.isSyncing = YES;
        
        [[OwnerDBManager sharedManager] updateOwner:[NSMutableArray arrayWithObject:owner]];
        
        if (owner.isNewOwner) {
            
            NSLog(@"new owner");
            
            [[ConasysRequestManager sharedConasysRequestManager] registerOwnerWithDetails:[self getNewOwnerDict:owner] completionHandler:^(id response, NSError *error, BOOL result) {
                
                if (!error) {

                    owner.isEdited = 0;
                    owner.isNewOwner = 0;
                }
                owner.isSyncing = NO;

                [[OwnerDBManager sharedManager] updateOwner:[NSMutableArray arrayWithObject:owner]];
                
                [self checkCounter:owners.count];
                
            }];
        }
        else{
            
            NSLog(@"edit owner");
            [[ConasysRequestManager sharedConasysRequestManager] editOwnerWithDetails:[self getEditOwnerDict:owner] completionHandler:^(id response, NSError *error, BOOL result) {
                
                if (!error) {
                    
                    owner.isEdited = 0;
                    owner.isNewOwner = 0;
                }
                owner.isSyncing = NO;
                
                [[OwnerDBManager sharedManager] updateOwner:[NSMutableArray arrayWithObject:owner]];
                
                [self checkCounter:owners.count];
            }];
        }
    }
}

- (void)checkCounter:(int)total{
    
    counter++;
    
    if (counter>=total) {
        
        completionBlock(nil, YES);
    }
}


- (NSMutableDictionary *)getNewOwnerDict:(Owner *)owner{
    
//    [infoDict setValue:@"true" forKey:@"IsOnline"];
    
    
   return [NSMutableDictionary dictionaryWithObjectsAndKeys: owner.userName,REGISTER_OWNER_USERNAME,owner.password,REGISTER_OWNER_PASSWORD,owner.email,REGISTER_OWNER_EMAIL,owner.builderToken,REGISTER_OWNER_TOKEN,owner.firstName,REGISTER_OWNER_FIRSTNAME,owner.lastName,REGISTER_OWNER_LASTNAME,owner.phoneNumber,REGISTER_OWNER_PHONE_NUMBER,owner.enableEmailNotification?@"true":@"false",REGISTER_OWNER_EMAIL_PERMISSION,owner.builderName,REGISTER_OWNER_BUILDER_USERNAME, @"false", @"IsOnline", owner.unitId, @"UnitId", nil];
    
//    [infoDict setValue:self.deficiencyReview.unitId forKey:@"UnitId"];
    
}


- (NSMutableDictionary *)getEditOwnerDict:(Owner *)owner{
    
//    [infoDict setValue:@"true" forKey:@"IsOnline"];
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:owner.builderToken, EDIT_OWNER_TOKEN,owner.builderName , EDIT_OWNER_BUILDER_NAME_KEY, owner.email , EDIT_OWNER_EMAIL_KEY,owner.firstName , EDIT_OWNER_FIRST_NAME_KEY,owner.enableEmailNotification?@"true":@"false" ,EDIT_OWNER_EMAIL_PERMISS_KEY,owner.lastName , EDIT_OWNER_LAST_NAME_KEY,owner.phoneNumber , EDIT_OWNER_PHONE_NUMBER_KEY,owner.userName , EDIT_OWNER_USERNAME_KEY , @"false", @"IsOnline",nil];
}

@end
