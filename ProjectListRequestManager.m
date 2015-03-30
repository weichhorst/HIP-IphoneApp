//
//  ProjectListRequestManager.m
//  Conasys
//
//  Created by user on 6/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ProjectListRequestManager.h"
#import "Project.h"
#import "BuilderUser.h"
#import "DateFormatter.h"

@implementation ProjectListRequestManager

#define PROJECT_LIST_REQUEST @"projectList"


// Returns "All_project_data" request to be processed by ConasysRequestManager.
+(id)getAllProjectsList:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block{
    
    id request = [self getRequestForURL:URL_PROJECT_LIST requestName:PROJECT_LIST_REQUEST infoDict:dict];
    [request setCallBackBlock:block];
    return request;
}


// Processing the response got from server and calling the completion handler.
- (void)processTheResponse{
    
//    NSLog(@"Processing the response");
    NSDictionary *dict = [self validateResponse];
    if (dict && [self isValidRequest]) {
        
        
        AppDelegate *appDelegate = DELEGATE;
        
        appDelegate.currentBuilder.performedEmail = [dict objectForKey:RESPONSE_PERFORMED_EMAIL];
        
        appDelegate.currentBuilder.performedName = [dict objectForKey:RESPONSE_PERFORMED_NAME];
        
        appDelegate.currentBuilder.lastSyncDate = [[DateFormatter sharedFormatter] getSyncStringFromDate:[NSDate date]];
        
        [[BuilderUsersDB sharedDatabase] updateBuilderUser:appDelegate.currentBuilder];
        
        self.callBackBlock([Project projectsFromArray:[dict objectForKey:RESPONSE_PROJECTS_KEY] andConstructionDict:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:RESPONSE_PERFORMED_EMAIL], @"PerformedByEmail", [dict objectForKey:RESPONSE_PERFORMED_NAME], @"PerformedByName", nil]], nil, YES);

    }
    else{
        
        self.callBackBlock(nil, nil, NO);
    }
    
}

// Will be called if process fails
- (void)processFailed{
    
    self.callBackBlock(nil, nil, NO);
}

@end
