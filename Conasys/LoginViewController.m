//
//  LoginViewController.m
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "BuilderProjectViewController.h"
#import "UserDefaults.h"
#import "BuilderUser.h"



#define ERROR_MESSAGE NSLocalizedString(@"LOGIN_ERROR_MESSAGE", @"")
#define LOGIN_FAILED NSLocalizedString(@"LOGIN_FAILED", @"")



@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UITextField *activeField;
}
#define FORGOT_VIEW_X 0
#define FORGOT_VIEW_Y 0
#define FORGOT_VIEW_WIDTH 320
#define FORGOT_VIEW_HEIGHT 185

#define FORGOT_VIEW_TAG 100

#define LOGIN_VIEW_PORTRAIT CGRectMake(220, 319, 329, 256)
#define LOGIN_VIEW_LANDSCAPE CGRectMake(self.view.frame.size.width/2, 200, 329, 256)


#define LABEL_PORTRAIT CGRectMake(220, 319, 329, 256)
#define LABEL_LANDSCAPE CGRectMake(self.view.frame.size.width/2, 280, 329, 256)


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
    
    imageNumberArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    [self localizeTheObjects];
    
    scrView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)localizeTheObjects{
    
    [textFieldUsername setPlaceholder:NSLocalizedString(@"Login_Username", @"")];
    [textFieldPassword setPlaceholder:NSLocalizedString(@"Login_Password", @"")];
    [lblGetStarted setText:NSLocalizedString(@"Login_Get_Started", @"")];
    [lblRemember setText:NSLocalizedString(@"Login_RememberMe", @"")];
    [btnLogin setTitle:NSLocalizedString(@"Login_Button_Title", @"") forState:UIControlStateNormal];
    [lblHeader setText:NSLocalizedString(@"Login_Header_Title", @"")];
    
    [textFieldUsername setFont:[UIFont regularWithSize:14.0f]];
    [textFieldPassword setFont:[UIFont regularWithSize:14.0f]];
    [lblRemember setFont:[UIFont regularWithSize:12.0f]];
    [btnLogin.titleLabel setFont:[UIFont semiBoldWithSize:16.0f]];
    [lblHeader setFont:[UIFont semiBoldWithSize:45.0f]];
    [lblGetStarted setFont:[UIFont semiBoldWithSize:22.0f]];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    currentImageNumber = [self getRandomImageNumber];
    [self setBackgroundImage];
    [self checkRememberMe];
    
//    [textFieldUsername setText:@"testbuilder"];
//    [textFieldPassword setText:@"Buildteam"];
}



// checking if user is already logged in with "Remember me" option.
- (void)checkRememberMe{
    
    if ([UserDefaults valueForKey:REMEMBER_ME_USERNAME]) {
        
        textFieldUsername.text = [UserDefaults valueForKey:REMEMBER_ME_USERNAME];
        textFieldPassword.text = [UserDefaults valueForKey:REMEMBER_ME_PASSWORD];
        [btnCheckBox setSelected:YES];
    }
}


// This will generate sequenced image number
- (int)getImageNumber{
    
    int count =1;
    int helper=1;
    
    if ([UserDefaults valueForKey:LOGIN_IMAGE_NAME_KEY]) {
        
       helper = count= [[UserDefaults valueForKey:LOGIN_IMAGE_NAME_KEY] intValue];
        
        [UserDefaults saveObject:[NSString stringWithFormat:@"%d", count<5?count+1:1] forKey:LOGIN_IMAGE_NAME_KEY];
    }
    else{
        
        [UserDefaults saveObject:[NSString stringWithFormat:@"%d", count++] forKey:LOGIN_IMAGE_NAME_KEY];
    }
    
    return helper;
}



// this will generate random Image number
- (int)getRandomImageNumber
{
    
    return [[imageNumberArray objectAtIndex: arc4random() % [imageNumberArray count]] intValue];
}



// setting background image here
- (void)setBackgroundImage{
    
    [backgroundImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_%d_%@.jpg",currentImageNumber,[self orientationTypePortrait]?@"portrait":@"landscape"]]];
}


// Will be called when "Remember me" is tapped
- (IBAction)btnCheckBox:(UIButton *)sender
{
    
    [sender setSelected:!sender.isSelected];
}

// Login button event. Will be called when login button is pressed.
- (IBAction)buttonLoginTapped:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    BuilderUser *user = [[BuilderUsersDB sharedDatabase] fetchSavedUser:textFieldUsername.text andPassword:textFieldPassword.text];
    
    if (user && user.userId) {
        
        AppDelegate *appDelegate = DELEGATE;
        appDelegate.currentBuilder  = user;
        
        [UserDefaults saveObject:user.username forKey:CURRENT_USERNAME_KEY];
        [UserDefaults saveObject:user.userToken forKey:CURRENT_USER_TOKEN_KEY];
        
        [self saveForRemember];
        [self pushToNewScreen];
    }
    else if ([self networkAvailable])
    {
        
        [self showLoader:SPINNER_WAIT_TITLE];
        
        if (textFieldUsername.text.length && textFieldPassword.text.length) {
            
            ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
            
            __weak id weakSelf = self;
            
            [requestManager loginUser:[NSMutableDictionary dictionaryWithObjectsAndKeys:textFieldUsername.text, LOGIN_USERNAME_KEY, textFieldPassword.text, LOGIN_PASSWORD_KEY, nil]  completionHandler:^(id response, NSError *error, BOOL result) {
                
                if (result) {
                    
                    [weakSelf saveCredentials:response];
                    
                    [self pushToNewScreen];
                }
                else{
                    
                    [self showCustomAlertWithMessage:LOGIN_FAILED];
                }
                
                [self hideLoader];
            }];

        }
        else{
            
            [self showCustomAlertWithMessage:ERROR_MESSAGE];
            [self hideLoader];
        }
        
    }
    else{
            [self showCustomAlertWithMessage:NSLocalizedString(@"Login_Offline_User_Not_Exist_Error", @"")];
        }
    
}




- (void)pushToNewScreen{
    
    BuilderProjectViewController *obj = [[BuilderProjectViewController alloc]initWithNibName:@"BuilderProjectViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

// Saving Current User Credentials

- (void)saveCredentials:(NSMutableDictionary *)responseDict{
    
    
    [UserDefaults saveObject:textFieldUsername.text forKey:CURRENT_USERNAME_KEY];
    [UserDefaults saveObject:[responseDict objectForKey:LOGIN_TOKEN_DATA_KEY] forKey:CURRENT_USER_TOKEN_KEY];
    
    [self saveForRemember];
    [self saveBuilder:responseDict];
}


- (void)saveBuilder:(NSMutableDictionary *)dictionary{
    
    BuilderUser *user = [[BuilderUser alloc]init];
    //
    user.userId = [NSString stringWithFormat:@"%ld", [[dictionary objectForKey:@"UserId"] longValue]];
    user.username = textFieldUsername.text;
    user.userToken = [dictionary objectForKey:LOGIN_TOKEN_DATA_KEY];
    user.password = textFieldPassword.text;
    
    AppDelegate *appDelegate = DELEGATE;
    
    [[BuilderUsersDB sharedDatabase]insertIntoUserTable:user];
    appDelegate.currentBuilder = user;
    
}


- (void)saveForRemember{
    
    if ([btnCheckBox isSelected]) {
        
        [UserDefaults saveObject:textFieldUsername.text forKey:REMEMBER_ME_USERNAME];
        [UserDefaults saveObject:textFieldPassword.text forKey:REMEMBER_ME_PASSWORD];
    }
    else{
        
        [UserDefaults removeValueForKey:REMEMBER_ME_USERNAME];
        [UserDefaults removeValueForKey:REMEMBER_ME_PASSWORD];
        
    }
}

// Forgot Password button event. Will be called when "Forgot password?" button is pressed.
- (IBAction)buttonForgotPassTapped:(UIButton *)sender{
    
    [loginView setHidden:YES];
    ForgotPasswordView *forgotPasswordView = [[ForgotPasswordView alloc]initWithFrame:CGRectMake(FORGOT_VIEW_X, FORGOT_VIEW_Y, FORGOT_VIEW_WIDTH, FORGOT_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide) {
        
        if (shouldHide) {
            
            [modalView hide];
            [loginView setHidden:NO];
        }
        
    }];
    
    NSString *nibName = @"ForgotPasswordView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:forgotPasswordView options:nil];
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [forgotPasswordView setTag:FORGOT_VIEW_TAG];
    [forgotPasswordView addSubview:viewFromXib];
    [forgotPasswordView setCenter:self.view.center];
    [forgotPasswordView addLeftLabelsForTextFields];
    
    modalView = [[RNBlurModalView alloc]initWithViewController:self view:forgotPasswordView];
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:OVERLAY_BACKGROUND_IMAGENAME]]];
    [modalView show];
    
}


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [self setBackgroundImage];
    
    [self checkAndSetFrame];
    
}

- (void)checkAndSetFrame{
    
   
    if ([self orientationTypePortrait]) {
        
        [loginView setFrame:LOGIN_VIEW_PORTRAIT];
        
    }
    else {

        [loginView setFrame:LOGIN_VIEW_LANDSCAPE];
        
        [loginView setCenter:CGPointMake(self.view.frame.size.width/2, loginView.center.y)];
        
    }
    
    [lblHeader setCenter:CGPointMake(self.view.frame.size.width/2, loginView.frame.origin.y/2)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
 
    return YES;
}

#pragma mark - Keyboard handling
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    // scroll to the text view
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 10, 0.0);
    scrView.contentInset = contentInsets;
    scrView.scrollIndicatorInsets = contentInsets;
    scrView.scrollEnabled = YES;
    
    // If active text field is hidden by keyboard, scroll it so it's visible.
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGRect thisFrame = [scrView convertRect:activeField.frame toView:self.view];
    if (!CGRectContainsPoint(aRect, thisFrame.origin) ) {
        [scrView scrollRectToVisible:activeField.frame animated:YES];
    }
}

/**
 *  Called when the UIKeyboardWillHideNotification is received.
 *
 *  @param aNotification The received notification.
 */
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    // scroll back..
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrView.contentInset = contentInsets;
    scrView.scrollIndicatorInsets = contentInsets;
    scrView.scrollEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    // Unregister the view for keyboard notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

@end
