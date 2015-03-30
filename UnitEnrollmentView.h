//
//  UnitEnrollmentView.h
//  Conasys
//
//  Created by user on 6/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface UnitEnrollmentView : BaseView{
    
    IBOutlet UITextField *textFieldEnrollmentNumber;
    void(^ completionBlock)(id data, int buttonTag, BOOL result);
    
    IBOutlet UILabel *lblEnrollmentNumber;
    IBOutlet UIButton *btnSave;
    __weak IBOutlet UILabel *lblEnterNumber;
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

- (IBAction)btnCloseClicked:(UIButton *)sender;

- (IBAction)btnSaveClicked:(UIButton *)sender;

- (void)setEnrollmentNumber:(NSString *)enrollmentNumber;

@end
