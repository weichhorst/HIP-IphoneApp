//
//  ZoomedPhotoViewController.m
//  Conasys
//
//  Created by user on 7/21/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ZoomedPhotoViewController.h"

@interface ZoomedPhotoViewController ()

@end

@implementation ZoomedPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [imageView setImage:[UIImage imageWithData:[NSData dataFromBase64String:self.base64String]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
