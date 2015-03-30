//
//  UIView+customization.m
//  Celebrity
//
//  Created by user on 3/3/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UIView+customization.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+Gibson.h"


@implementation UIView (customization)

#define Default_Radius 5.0f



- (void)roundedBorderWithWidth:(float )width andColor:(UIColor *)color{
    
    
    [self roundedBorderWithWidth:width radius:Default_Radius andColor:color];
//    [self roundedBordertoView:view width:width radius:Default_Radius andColor:color];
    
}


- (void)roundedBorderWithWidth:(float )width radius:(float)radius andColor:(UIColor *)color{
    
    
    CALayer *layer = [self layer];
    
    [layer setCornerRadius:radius];
    [layer setBorderWidth:width];
    
    if (color) {
        
        [layer setBorderColor:[color CGColor]];
        
    }
}


- (void)addTapGestureWithTarget:(id)target andSelector:(SEL)selector{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    [tapGesture setNumberOfTapsRequired:1];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapGesture];
}

- (void)addLeftLabelToMyTextField{
    
    [self addLeftLabelToMyTextField:@"  " andWidth:10];
}



- (void)addLeftLabelToMyTextField:(NSString *)string andWidth:(float)width{
    
    
    if ([self isKindOfClass:[UITextField class]]) {
        
        [self addLeftLabelToMyTextField:string andWidth:width bold:NO andColor:nil];
    }
}

- (void)addLeftLabelToMyTextField:(NSString *)string andWidth:(float)width bold:(BOOL)isBold{
    
    if ([self isKindOfClass:[UITextField class]]) {
        
        [self addLeftLabelToMyTextField:string andWidth:width bold:bold andColor:nil];
    }
}

- (void)addLeftLabelToMyTextField:(NSString *)string andWidth:(float)width bold:(BOOL)isBold andColor:(UIColor *)color{
    
    
    if ([self isKindOfClass:[UITextField class]]) {
        
        UITextField *textField = (UITextField *)self;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, width, 40)];
        label.text= string;
        label.font =  isBold?[UIFont semiBoldWithSize:12.0f]:[UIFont regularWithSize:12.0f];
        label.numberOfLines = 0;
        [label setTextColor:color?color:[UIColor blackColor]];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = label;
        
    }
}

- (void)removeAllSubviews{
    
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview];
    }
}

@end
