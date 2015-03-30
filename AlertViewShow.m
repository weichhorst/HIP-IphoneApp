//
//  AlertViewShow.m
//  Conasys
//
//  Created by abhi on 7/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "AlertViewShow.h"
#import "UIFont+Gibson.h"
#import "UIView+customization.h"

@implementation AlertViewShow

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/

-(void)showText:(NSString *)name
{
    
    [textViewAlert setFont:[UIFont regularWithSize:14.0f]];
    [textViewAlert setText:[NSString stringWithFormat:@"%@",name]];
    
    [btnOk.titleLabel setFont:[UIFont semiBoldWithSize:17.0f]];
    [btnOk.titleLabel setText:NSLocalizedString(@"Custom_Alert_Ok", @"")];
    
    [btnOk roundedBorderWithWidth:0.0 radius:4.0 andColor:[UIColor clearColor]];
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        completionBlock = myBlock;
    }
    return self;
}


- (void)viewChanged:(NSNotification *)notification{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)btnAlertOkClicked:(id)sender
{
     completionBlock(nil, 0, YES);
}
- (IBAction)btnAlertClose:(id)sender
{
     completionBlock(nil, 0, YES);
}
@end
