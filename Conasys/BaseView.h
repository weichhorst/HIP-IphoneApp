//
//  BaseView.h
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderFiles.h"
#import "CategoryHeaderFile.h"
#import "UIImageView+WebCache.h"
#import "Owner.h"
#import "ResponseKeys.h"
#import "ReviewOwner.h"

@interface BaseView : UIView

- (void)setKeyBoardNotifications;
- (void)removeObservers;


- (BOOL)isPortrait;
- (BOOL)isLandscape;
- (int)locationTypePortrait;
@end
