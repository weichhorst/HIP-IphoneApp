//
//  DescriptionPopOverController.m
//  Conasys
//
//  Created by user on 5/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "DescriptionPopOverController.h"
#import "UIView+customization.h"
#import "Utility.h"
#define TEXTVIEW_TAG 100

@interface DescriptionPopOverController ()

@end

@implementation DescriptionPopOverController

#define TEXTVIEW_WIDTH 290
#define TEXTVIEW_HEIGHT 145

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCompletionBlock:(void(^)(id data, BOOL result))myBlock{
    
    self = [super init];
    
    if (self) {
        
        completionBlock = myBlock;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view sett] ;
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [txtView setTag:TEXTVIEW_TAG];
    
    [txtView setText:_descriptionText];
    
    [txtView setContentInset:UIEdgeInsetsZero];
    
    [txtView roundedBorderWithWidth:1.0f radius:5.0f andColor:[UIColor lightGrayColor]];
    [txtView setFont:[UIFont regularWithSize:15.0f]];
    
    [self addBarButtonItems];
    
    if(![Utility isiOSVersion8])
    {
        [txtView setFrame:CGRectMake(txtView.frame.origin.x, 5, txtView.frame.size.width, txtView.frame.size.height)];
    }
    
    if([Utility isiOSVersion6])
    {
        [txtView setFrame:CGRectMake(txtView.frame.origin.x, 7, txtView.frame.size.width, txtView.frame.size.height+5)];
    }
    //[self createTextView];

}


- (void)addBarButtonItems{
    
    UIBarButtonItem * cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(barButtonClk:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    
    
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonClk:)];
    [doneBtn setTag:1];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
}


- (void)createTextView{
    
    float origin = 5;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(5, origin, TEXTVIEW_WIDTH, TEXTVIEW_HEIGHT)];
    
    [textView setDelegate:self];
    
    [textView setTag:TEXTVIEW_TAG];
    
    [textView setText:_descriptionText];
    
    [textView roundedBorderWithWidth:1.0f radius:5.0f andColor:[UIColor lightGrayColor]];
    [textView setFont:[UIFont regularWithSize:15.0f]];
    
    [self.view addSubview:textView];
}


- (void)barButtonClk:(UIBarButtonItem *)barButton{
    
    UITextView *textView = (UITextView *)[self.view viewWithTag:TEXTVIEW_TAG];
    completionBlock(textView.text, barButton.tag);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
