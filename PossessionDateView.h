//
//  PossessionDateView.h
//  Conasys
//
//  Created by user on 6/2/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface PossessionDateView : BaseView{
    
    
    void(^ completionBlock)(id data, int buttonTag, BOOL result);
    
    IBOutlet UIDatePicker *myDatePicker;
    
    IBOutlet UILabel *labelDate;
    IBOutlet UILabel *lblPossessionDate;
    
    __weak IBOutlet UIButton *btnSave;
}

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

- (IBAction)btnCloseClicked:(UIButton *)sender;

- (void)addNotificationToDatePicker;

- (IBAction)btnSaveClicked:(UIButton *)sender;

- (void)setCurrentDate:(NSString *)date;
@end
