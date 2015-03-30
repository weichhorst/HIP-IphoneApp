//
//  AlertViewShow.h
//  Conasys
//
//  Created by abhi on 7/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewShow : UIView
{
      void(^ completionBlock)(id data, int buttonTag, BOOL result);

    __weak IBOutlet UITextView *textViewAlert;
    __weak IBOutlet UIButton *btnOk;
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

- (IBAction)btnAlertOkClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAlertClose;
- (IBAction)btnAlertClose:(id)sender;
-(void)showText:(NSString *)name;

@end
