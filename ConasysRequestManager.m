//
//  ConasysRequestManager.m
//  Conasys
//
//  Created by user on 4/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysRequestManager.h"
#import "SynthesizeSingleton.h"
#import "Requests.h"
#import "ConasysBaseRequest.h"
#import "SubmitRequestManager.h"

@interface ConasysRequestManager ()

@property (nonatomic,strong) ASINetworkQueue  *networkQueue;

@end


@implementation ConasysRequestManager

// creating singleton
SYNTHESIZE_SINGLETON_FOR_CLASS(ConasysRequestManager)


// initializing the queue
-(id)init {
    if (self = [super init])
    {
        
        self.networkQueue = [[ASINetworkQueue alloc] init];
        self.networkQueue.shouldCancelAllRequestsOnFailure = NO;
        self.networkQueue.delegate = self;
        self.networkQueue.requestDidFinishSelector = @selector(requestDone:);
        self.networkQueue.requestDidFailSelector = @selector(requestWentWrong:);
        self.networkQueue.queueDidFinishSelector = @selector(queueFinished:);
        [self.networkQueue go];
    }
    return self;
}


// called only when request is finished
- (void)requestDone:(ConasysBaseRequest *)request
{
    
    [request processTheResponse];
}

// called when request is failed due to any error
- (void)requestWentWrong: (ConasysBaseRequest *)request
{
    
//#if DEBUGGIN_ON
//    NSLog(@"requestWentWrong ==%@", request.error.description);
//#endif

    [request processFailed];
}

// called only when queue is finished
- (void)queueFinished:(ASINetworkQueue *)queue
{
    
//#if DEBUGGIN_ON
//    NSLog(@"queueFinished== ");
//#endif

}


// Requesting server for loggin user with credentials.
- (void)loginUser:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block{
   
    LoginRequest *request = [LoginRequest loginWithDetails:userInfo completionHandler:block];

    [self.networkQueue addOperation:request];
}



// Requesting server for all project list.
- (void)getAllProjectList:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block{
    
    ProjectListRequestManager *request = [ProjectListRequestManager getAllProjectsList:userInfo completionHandler:block];
    NSLog(@"userInfo %@",userInfo);
    [self.networkQueue addOperation:request];
}


- (void)registerOwnerWithDetails:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block{
    
    
//#if DEBUGGIN_ON
    NSLog(@"login user== %@", userInfo);
//#endif
    
    OwnerRequestManager *request = [OwnerRequestManager registerNewOwner:userInfo completionHandler:block];
    [self.networkQueue addOperation:request];
    
}


- (void)editOwnerWithDetails:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block{
    
    
//#if DEBUGGIN_ON
//    NSLog(@"login user== %@", userInfo);
//#endif
    
    OwnerRequestManager *request = [OwnerRequestManager editOwner:userInfo completionHandler:block];
    [self.networkQueue addOperation:request];
    
}

- (void)submitReview:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block{
    

//#if DEBUGGIN_ON
//    NSLog(@"submitReviewToServer == %@", dict);
//#endif
    
    SubmitRequestManager *request = [SubmitRequestManager submitReviewToServer:dict completionHandler:block];
    
    [self.networkQueue addOperation:request];
}

@end
