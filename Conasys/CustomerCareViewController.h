//
//  CustomerCareViewController.h
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"


@interface CustomerCareViewController : BaseViewController<UITextViewDelegate>{
    
    IBOutlet CustomerCareTable *customerCareTable;

    IBOutlet UITextView *textViewComments;
//    IBOutlet UITextView *textViewAddress;
    IBOutlet UILabel *lblAddress;
    
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UILabel *lblViewType;
    
    __weak IBOutlet UIView *headerView;
    
    CGRect lastFrame;
    
    IBOutlet UIView *containerView;
    
    __weak IBOutlet UIButton *btnViewAllUnits;
    __weak IBOutlet UILabel *lblItem;
    __weak IBOutlet UILabel *lblLocation;
    __weak IBOutlet UILabel *lblProduct;
    __weak IBOutlet UILabel *lblDescription;
    __weak IBOutlet UILabel *lblImage;
    __weak IBOutlet UILabel *lblAdditionalComments;
    
    int additionalFrame;
    
    __weak IBOutlet UIButton *btnNext;
    __weak IBOutlet UIButton *btnBack;
    
    UIView *overlayView;
    
//    IBOutlet UIScrollView *scrollView;

    void(^callBackBlock)(BOOL finish);

}

@property (nonatomic, retain)Unit *currentUnit;
@property (nonatomic, retain)Project *currentProject;
@property (nonatomic, retain)DeficiencyReview *currentDeficiencyReview;

@property (nonatomic, retain)NSMutableArray *ownerListArray;

- (IBAction)btnNextClicked:(UIButton *)sender;
- (IBAction)btnAllUnitsClicked:(UIButton *)sender;
- (IBAction)btnAddNewItemsClicked:(UIButton *)sender;

- (void)showAlertWithMessage:(NSString *)message;
-(void)setframes;


- (void)endEditingWithHandler:(void(^)(BOOL finished))handler;

@end
