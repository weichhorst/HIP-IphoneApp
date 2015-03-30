//
//  SubmitReviewUploader.h
//  Conasys
//
//  Created by user on 7/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConasysRequestManager.h"

#import "Unit.h"
#import "Project.h"
#import "DeficiencyReview.h"

@interface SubmitReviewUploader : NSObject

@property (nonatomic, retain)DeficiencyReview *currentDeficiencyReview;


- (void)uploadReviewInBackground:(NSMutableDictionary *)dict;

@end
