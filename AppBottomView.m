//
//  AppBottomView.m
//  Conasys
//
//  Created by user on 6/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "AppBottomView.h"
#import "DeficiencyReviewDatabase.h"


@implementation AppBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)internetConnectedNow:(BOOL)flag{
    
    if (flag) {
        
        [netImageView setImage:[UIImage imageNamed:@"online.png"]];
        [lblOnline setText:NSLocalizedString(@"AppBottomView_Online", @"")];
    }
    else{
        
        [netImageView setImage:[UIImage imageNamed:@"offline.png"]];
        [lblOnline setText:NSLocalizedString(@"AppBottomView_Offline", @"")];
    }
    
    AppDelegate *delegate = DELEGATE;
    [lblLastSync setText:delegate.currentBuilder.lastSyncDate];
    
    [lblStaticLastSync setText:NSLocalizedString(@"AppBottomView_Last_Sync", @"")];
    
    
    [lblStaticLastSync setFont:[UIFont regularWithSize:14.0f]];
    [lblLastSync setFont:[UIFont regularWithSize:14.0f]];
    [lblOnline setFont:[UIFont regularWithSize:14.0f]];
    
    [lblStaticCount setFont:[UIFont regularWithSize:14.0f]];
    [lblPendingForms setFont:[UIFont regularWithSize:14.0f]];
    
}


- (void)enterLastSyncDate{
    
    NSLog(@"Entering last syncing date");
    AppDelegate *delegate = DELEGATE;
    [lblLastSync setText:delegate.currentBuilder.lastSyncDate];
    
    [lblPendingForms setText:[NSString stringWithFormat:@"%d", [[DeficiencyReviewDatabase sharedDatabase] pendingProjectsForUser:CURRENT_BUILDER_ID]]];
}


- (void)changeFrameForLandscape{
    
    CGRect frame = logoImgView.frame;
    frame.origin.x = 1024-frame.size.width-10;
    [logoImgView setFrame:frame];
    
    CGRect frame1 = backGroundImgView.frame;
    frame1.size.width = 1024;
    [backGroundImgView setFrame:frame1];
}

@end
