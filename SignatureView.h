//
//  SignatureView.h
//  Conasys
//
//  Created by abhi on 6/27/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface SignatureView : BaseView
{
    void(^ completionBlock)(id imageString, id data, int buttonTag, BOOL builder);
    
    __weak IBOutlet UIImageView *editImg;
    BOOL callview;
    __weak IBOutlet UIImageView *finalEditImg;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    __weak IBOutlet UITextField *textFieldUserNickName;
    
//    NSString *tempFileName;
    
    IBOutlet UILabel *lblPlaceHolder;
    
    BOOL newImage; //default is no.
    
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblTitle;
    
    IBOutlet UIButton *btnSignatureClear;
    
    IBOutlet UIButton *btnSignatureSave;
    
}

- (void)setCustomerSignText:(NSString *)signatureText;

- (IBAction)btnSave:(id)sender;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@property(nonatomic,weak) UIImageView *editImg;
@property(nonatomic,weak) UIImageView *finalEditImg;

@property(nonatomic,assign)BOOL callview;
@property(nonatomic,assign)BOOL isBuilder;

@property (weak, nonatomic) IBOutlet UIImageView *signatureImg;
@property (weak, nonatomic) IBOutlet UIView *getSignatureView;

@property (nonatomic, retain)NSString *base64String;


- (IBAction)btnClose:(id)sender;
- (IBAction)btnSignatureClear:(id)sender;

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id imageString, id data, int buttonTag, BOOL builder))myBlock;

- (void)setImageForView:(NSString *)image64String andName:(NSString *)name;

- (void)setTitleForLabel:(NSString *)title;


@end
