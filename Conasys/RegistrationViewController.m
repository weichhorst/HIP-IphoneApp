//
//  RegistrationViewController.m
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark- View LifeCycle

- (void)viewDidLoad
{

    [super viewDidLoad];
}


// Login button event. Will be called when login button is pressed.
- (IBAction)buttonRegisterTapped:(UIButton *)sender{
    
    if (isConnected) {
        
        ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
        
        __weak id weakSelf = self;
        
        [requestManager loginUser:nil completionHandler:^(id response, NSError *error, BOOL result) {
            
            if (result) {
                
                [weakSelf performSegueWithIdentifier:@"loggedIn" sender:nil];
            }
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end