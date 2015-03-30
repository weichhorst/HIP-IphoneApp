//
//  CustomerCareCell.h
//  Conasys
//
//  Created by user on 5/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseCell.h"
#import "PopOverHeaderFiles.h"
#import "PCPopoverController.h"
#import "SYPopoverController.h"


@interface CustomerCareCell : BaseCell{
    
    IBOutlet UILabel *lblItemNumber;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblProduct;
    IBOutlet UILabel *lblLocation;
    
    
    IBOutlet UIButton *btnCamera;
    IBOutlet UIButton *btnProduct;
//    IBOutlet UIButton *btnLocation;
    IBOutlet UIButton *btnImageFolder;
    
    void(^completionBlock)(UIButton * button, BOOL result, id data);
    
    UIPopoverController *descriptionPopOver, *itemPhotosPopOver;
    
	PCPopoverController  *productPopOver;
	PCPopoverController *locationPopOver;
	
//    SYPopoverController *locationPopOver;
	
    
    IBOutlet UILabel *lblHelperLocation, *lblHelperProduct, *lblHelperDescription;
    RNBlurModalView *modalView;
    
    IBOutlet UILabel *lblImageCount;
    IBOutlet UILabel *helperLabel;
}

//@property (nonatomic, retain)Product *currentProduct;
@property (nonatomic, retain)Unit *currentUnit;

@property (nonatomic, retain)IBOutlet UILabel *lblItemDescNumber;
@property (nonatomic, retain)id controller;
@property (nonatomic, retain)id parentController;
@property (nonatomic, retain)NSMutableArray *imageArray;
@property (nonatomic, retain)ReviewItem *currentReviewItem;
@property (nonatomic, readwrite)int currentProductId;

- (void)addTapGestures;
- (CGFloat)rowSize:(NSString *)string;
+ (CGFloat)heightForCell:(NSString *)data;

- (IBAction)btnCameraClicked:(UIButton *)sender;
- (IBAction)btnProductClicked:(UIButton *)sender;
- (IBAction)btnImageFolderClicked:(UIButton *)sender;


- (void)setCellDataForItemDescription:(ReviewItem *)reviewItem andUnit:(Unit *)unit WithClickEvent:(void(^)(UIButton * button, BOOL result, id data))block;

+ (CGFloat)heightForCell:(NSString *)location product:(NSString *)product andDescription:(NSString *)description;

- (void)setFramesAccordingly:(BOOL)isPortrait;

@end
