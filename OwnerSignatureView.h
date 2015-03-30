//
//  OwnerSignatureView.h
//  Conasys
//
//  Created by user on 7/5/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface OwnerSignatureView : BaseView{
    
    void(^ completionBlock)(id data, int buttonTag, BOOL isOwner);
}


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL isOwner))myBlock;

@property (weak, nonatomic) IBOutlet UIImageView *confirmSignImg;
@property (weak, nonatomic) IBOutlet UIImageView *confirmSignImg2;
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain)ReviewOwner *reviewOwner;
@property (nonatomic, readwrite)BOOL isOwnerSignView;

- (void)setDataForView:(NSString *)nickName andTitle:(NSString *)title;

- (void)setSignatureForView:(NSString *)imageBase64String;

- (IBAction)btnConfirmEdit:(id)sender;

- (void)changeNickName:(NSString *)nickName;
- (void)setBoldTitle;

@end
