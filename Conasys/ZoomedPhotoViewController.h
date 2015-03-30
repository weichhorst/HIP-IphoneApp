//
//  ZoomedPhotoViewController.h
//  Conasys
//
//  Created by user on 7/21/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"

@interface ZoomedPhotoViewController : BaseViewController{
    
    IBOutlet UIImageView *imageView;
}

@property (nonatomic, retain)NSString *imagePath;
@property (nonatomic, retain)NSString *base64String;

@end
