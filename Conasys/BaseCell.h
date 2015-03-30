//
//  BaseCell.h
//  Blongo
//
//  Created by user on 3/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Unit.h"
#import "Owner.h"
#import "Product.h"
#import "Location.h"
#import "UIView+customization.h"
#import "CategoryHeaderFile.h"
#import "ReviewOwner.h"
#import "ReviewItem.h"


@interface BaseCell : UITableViewCell<UIActionSheetDelegate, UIPopoverControllerDelegate>{
    
}

+ (int)orientationTypePortrait;

@end
