//
//  AppBottomView.h
//  Conasys
//
//  Created by user on 6/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface AppBottomView : BaseView{
    
//    void(^ completionBlock)(id data, int buttonTag, BOOL result);
    
    IBOutlet UIImageView *netImageView;
    //IBOutlet UIImageView *syncImageView;
    IBOutlet UILabel *lblOnline;
    IBOutlet UILabel *lblLastSync;
    
    IBOutlet UIImageView *backGroundImgView;
    IBOutlet UIImageView *logoImgView;
    IBOutlet UILabel *lblStaticLastSync;
    
    __weak IBOutlet UILabel *lblStaticCount;
    __weak IBOutlet UILabel *lblPendingForms;
    
}


- (void)internetConnectedNow:(BOOL)flag;
- (void)enterLastSyncDate;

- (void)changeFrameForLandscape;


//- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

@end
