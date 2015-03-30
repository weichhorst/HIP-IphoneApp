//
//  CustomerCareCell.m
//  Conasys
//
//  Created by user on 5/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "CustomerCareCell.h"
#import "AVCameraManager.h"
#import "CustomerCareViewController.h"
#import "SYPopoverController.h"
#import "GalleryPhotosViewController.h"
#import "PopoverBackgroundView.h"
#import "ProductDBManager.h"

#define ACTION_SHEET_TAG 99
#define POPOVER_WIDTH 100
#define POPOVER_HEIGHT 350
#define MAX_POP_WIDTH 758

#define LOCATION_POPOVER_WIDTH 270
#define LOCATION_POPOVER_HEIGHT 250

#define DESCRIPTION_POPOVER_WIDTH 300
#define DESCRIPTION_POPOVER_HEIGHT 200

#define ITEM_PHOTOS_POPOVER_WIDTH 320
#define ITEM_PHOTOS_POPOVER_HEIGHT 400


#define LBL_LOC_X_P 78
#define LBL_PRO_X_P 227
#define LBL_DESC_X_P 418

#define LBL_LOC_WIDTH_P 125
#define LBL_PRO_WIDTH_P 160
#define LBL_DESC_WIDTH_P 194


#define LBL_LOC_X_L 93
#define LBL_PRO_X_L 355
#define LBL_DESC_X_L 594

#define LBL_LOC_WIDTH_L 214
#define LBL_PRO_WIDTH_L 188
#define LBL_DESC_WIDTH_L 270


#define ACTION_SHEET_VIEW_X 0
#define ACTION_SHEET_VIEW_Y 0
#define ACTION_SHEET_VIEW_WIDTH 250
#define ACTION_SHEET_VIEW_HEIGHT 170


#define EMPTY_MESSAGE NSLocalizedString(@"Location_Alert_Message", @"")
#define  MISC NSLocalizedString(@"Miscellaneous", @"")

#define PLACEHOLDER_TEXT @"Enter Text Here"


#define SELECT_LOCATION @"Select Location"
#define SELECT_PRODUCT @"Select Product"

@implementation CustomerCareCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGFloat)heightForCell:(NSString *)location product:(NSString *)product andDescription:(NSString *)description{
    
    CustomerCareCell *cell = [[[NSBundle mainBundle]loadNibNamed:[self orientationTypePortrait]?@"CustomerCareCell":@"CustomerCareCell_Landscape" owner:nil options:nil] objectAtIndex:0];
    
    return [cell maxRowSize:location product:product andDescription:description];
}

- (CGFloat)maxRowSize:(NSString *)location product:(NSString *)product andDescription:(NSString *)description{
    
    [lblLocation setText:location];
    [lblLocation sizeToFit];
//
    [lblProduct setText:product];
    [lblProduct sizeToFit];
    
    [lblDescription setText:description];
    [lblDescription sizeToFit];
    
    float max = lblLocation.frame.size.height+(lblLocation.frame.origin.y+lblHelperLocation.frame.origin.y);
    float second = lblProduct.frame.size.height+(lblProduct.frame.origin.y+lblHelperProduct.frame.origin.y);
    float third = lblDescription.frame.size.height+(lblDescription.frame.origin.y+lblHelperDescription.frame.origin.y);
    
    
    if (second>max) {
        
         max = second;
    }
    if(third>max){
        
        max = third;
    }

    return max>70?max:70;
}


- (void)setCellDataForItemDescription:(ReviewItem *)reviewItem andUnit:(Unit *)unit WithClickEvent:(void(^)(UIButton * button, BOOL result, id data))block{
    
    
    self.currentUnit = unit;
    self.currentReviewItem = reviewItem;
    
    completionBlock = block;
    [self setDataToCellObjects:reviewItem];
    
    [btnImageFolder setHidden:reviewItem.reviewItemImages.count?NO:YES];
    
    [lblImageCount setText:reviewItem.reviewItemImages.count?[NSString stringWithFormat:@"%d", reviewItem.reviewItemImages.count]:@""];
}

- (void)setFonts{
    
    [lblItemNumber setFont:[UIFont regularWithSize:14.0f]];
    [lblProduct setFont:[UIFont regularWithSize:14.0f]];
    [lblDescription setFont:[UIFont regularWithSize:14.0f]];
    [lblImageCount setFont:[UIFont regularWithSize:10.0f]];
    [lblLocation setFont:[UIFont regularWithSize:14.0f]];
}


- (void)setDataToCellObjects:(ReviewItem *)reviewItem{
    
    [self setFonts];
    [lblLocation setText:reviewItem.itemLocation];
    [lblProduct setText:reviewItem.itemProduct];
    

    [lblDescription setText:reviewItem.itemDescription.length?reviewItem.itemDescription:PLACEHOLDER_TEXT];
    if(!reviewItem.itemDescription.length){
        
        [lblDescription setTextColor:[UIColor lightGrayColor]];
    }
    
    
    [lblLocation sizeToFit];
    [lblProduct sizeToFit];
    [lblDescription sizeToFit];
    
    
    CGRect frameDesc = [lblHelperDescription frame];
    frameDesc.size.height = lblDescription.frame.size.height+(lblDescription.frame.origin.y-lblHelperDescription.frame.origin.y)*2;
    
    [lblHelperDescription setFrame:frameDesc];
    
    frameDesc = [lblHelperProduct frame];
    frameDesc.size.height = lblProduct.frame.size.height+(lblProduct.frame.origin.y-lblHelperProduct.frame.origin.y)*2;
    [lblHelperProduct setFrame:frameDesc];
    
    
    frameDesc = [lblHelperLocation frame];
    frameDesc.size.height = lblLocation.frame.size.height+(lblLocation.frame.origin.y-lblHelperLocation.frame.origin.y)*2;
    [lblHelperLocation setFrame:frameDesc];
    
    
    [btnImageFolder setHidden:!reviewItem.reviewItemImages.count];
    
    [lblImageCount setText:reviewItem.reviewItemImages.count?[NSString stringWithFormat:@"%d", reviewItem.reviewItemImages.count]:@""];
    
    if (!reviewItem.reviewItemImages.count) {
        
        CGRect frame = btnCamera.frame;
        [btnCamera setCenter:CGPointMake(frame.origin.x+frame.size.width/2, self.contentView.frame.size.height/2)];
        
    }
}


- (void)addTapGestures{
    
    UITapGestureRecognizer *descriptionGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblDescriptionTapped:)];
    [descriptionGesture setNumberOfTapsRequired:1];
    [lblDescription addGestureRecognizer:descriptionGesture];
    [lblHelperDescription addGestureRecognizer:descriptionGesture];
    
    UITapGestureRecognizer *productGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblProductTapped:)];
    [productGesture setNumberOfTapsRequired:1];
    [lblProduct addGestureRecognizer:productGesture];
    [lblHelperProduct addGestureRecognizer:productGesture];
    
    UITapGestureRecognizer *locationGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblLocationTapped:)];
    [locationGesture setNumberOfTapsRequired:1];
    [lblLocation addGestureRecognizer:locationGesture];
    [lblHelperLocation addGestureRecognizer:locationGesture];
}


- (void)lblDescriptionTapped:(UITapGestureRecognizer *)tapGesture{

    [self addDescriptionPopOver:[lblDescription.text isEqualToString:PLACEHOLDER_TEXT]?@"":lblDescription.text];
}


- (void)lblProductTapped:(UITapGestureRecognizer *)tapGesture{
    
    [self addProductPopOver];
}

- (void)lblLocationTapped:(UITapGestureRecognizer *)tapGesture{
    
    
    CustomerCareViewController *obj = (CustomerCareViewController *)self.controller;
    
    [obj endEditingWithHandler:^(BOOL finished) {

        [self showLocationPopOver:tapGesture];
    }];
    
}

- (void)showLocationPopOver:(UITapGestureRecognizer *)tapGesture{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(sysVer < 8.0)
        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"YES"];
    else
    {
        AppDelegate *delegate = DELEGATE;
        delegate.lockOrientation = YES;
    }
    
    UILabel *gestureView = (UILabel *)tapGesture.view;
    [DELEGATE setPopOverMargin:gestureView.frame.size.width/2 - 13];
    
    LocationPopOverViewController *locationPopOverViewController = [[LocationPopOverViewController alloc] initWithCompletionBlock:^(id data, NSIndexPath *indexPath, BOOL result) {
        
        [locationPopOver dismissPopoverAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"NO"];
        
        AppDelegate *delegate = DELEGATE;
        delegate.lockOrientation = NO;
        
        Location *location = (Location *)[self.currentUnit.locationList objectAtIndex:indexPath.row];
						
        if (![self.currentReviewItem.itemLocation isEqualToString:location.locationName]) {
            

            self.currentReviewItem.itemLocationRowId = location.locationRowId;
            self.currentReviewItem.itemLocation = location.locationName;
            self.currentReviewItem.itemProduct = MISC;
            self.currentReviewItem.itemProductRowId = 0;
            self.currentReviewItem.productId = @"-1";
            
            if([location.locationName isEqualToString:SELECT_LOCATION]){
                
                self.currentReviewItem.itemLocationRowId = 0;
                self.currentReviewItem.itemLocation = SELECT_LOCATION;
                self.currentReviewItem.itemProduct = SELECT_PRODUCT;
                self.currentReviewItem.productId = @"0";
            }
            
            [self updateTheChanges:self.currentReviewItem];
        }
        
    }];
    
    [locationPopOverViewController setCurrentUnit:self.currentUnit];
    
    locationPopOver=[[PCPopoverController alloc]initWithContentViewController:locationPopOverViewController andTintColor:[UIColor whiteColor]];
	
	  //locationPopOver=[[SYPopoverController alloc]initWithContentViewController:locationPopOverViewController andTintColor:[UIColor whiteColor]];
	
    //    locationPopOver = [[UIPopoverController alloc]initWithContentViewController:locationPopOverViewController];
    
    locationPopOver.popoverContentSize = CGSizeMake(LOCATION_POPOVER_WIDTH, LOCATION_POPOVER_HEIGHT);
    locationPopOver.delegate=self;
    
    CGRect frame = gestureView.frame;
    [locationPopOver presentPopoverFromRect:frame inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}



+ (CGFloat)heightForCell:(NSString *)data{
    
    
    CustomerCareCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomerCareCell" owner:nil options:nil] objectAtIndex:0];
    
    return [cell rowSize:data];
}


- (CGFloat)rowSize:(NSString *)string{
    
    [self setFonts];
    [lblDescription setText:string];
    [lblDescription sizeToFit];
    
    return lblDescription.frame.origin.y+lblDescription.frame.size.height+15;
}


#pragma mark- Button Methods


- (IBAction)btnProductClicked:(UIButton *)sender{
    
    [self addProductPopOver];
}

// Open an option actionSheet for user to choose from.
- (IBAction)btnCameraClicked:(UIButton *)sender{
    
    
    [self showCustomActionSheet:sender];
}

// Depending of above selection it will open the camera view or gallery view where user can take new picture or select from gallery.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
}

// will be called when user wants to see the attached photos
- (IBAction)btnImageFolderClicked:(UIButton *)sender{
    
    [self showItemPhotosPopOver];
}



#pragma mark - Update DB

- (void)updateTheChanges:(ReviewItem *)reviewItem{
    
    CustomerCareTable *table = (CustomerCareTable *)self.parentController;
    
    [table itemCellUpdated:self withObject:reviewItem];
    
}


#pragma mark - POPOVER Methods
// calling different popOvers on various selections.
-(void)addProductPopOver
{
    
    CustomerCareViewController *obj = (CustomerCareViewController *)self.controller;
    
    [obj endEditingWithHandler:^(BOOL finished) {

        [self showTheProductPopOver];
    }];
    
}

- (void)showTheProductPopOver{

    if (!self.currentReviewItem.itemLocationRowId) {
        
        CustomerCareViewController *obj = (CustomerCareViewController *)self.controller;
        [obj showAlertWithMessage:EMPTY_MESSAGE];
        
        return;
    }
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(sysVer < 8.0)
        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"YES"];
    else
    {
        AppDelegate *delegate = DELEGATE;
        delegate.lockOrientation = YES;
    }
    
    NSMutableArray *allProducts = [[ProductDBManager sharedManager] getAllProductsForLocation:self.currentReviewItem.itemLocationRowId];
	
	
	
    NSString *string = @"";
    for (Product *product in allProducts) {
        
        
        if (product.productName.length>string.length) {
            
            string = product.productName;
        }
    }
    
    [helperLabel setText:string];
    [helperLabel sizeToFit];
    float popWidth = POPOVER_WIDTH;
    if (helperLabel.frame.size.width>POPOVER_WIDTH) {
        
        popWidth = helperLabel.frame.size.width+80;
    }
    
    if(popWidth>MAX_POP_WIDTH){
        
        popWidth = MAX_POP_WIDTH;
    }
    
    CGRect frame = lblHelperProduct.frame;
    [DELEGATE setPopOverMargin:frame.size.width/2 - 13];
    
    ProductPopOverViewController *productPopOverViewController=[[ProductPopOverViewController alloc]initWithCompletionBlock:^(id data, NSIndexPath *indexPath, BOOL result) {
        
        [productPopOver dismissPopoverAnimated:YES];
        
        AppDelegate *delegate = DELEGATE;
        delegate.lockOrientation = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"NO"];
        
        Product *product = (Product *)data;
        self.currentReviewItem.itemProductRowId = product.productRowId;
        
        self.currentReviewItem.itemProduct = [NSString stringWithFormat:@"%@%@", product.category.length?product.category:@"", product.productName];
        
        self.currentReviewItem.productId = product.productId;
        
        [self updateTheChanges:self.currentReviewItem];
        
    }];
    
    [productPopOverViewController setLocationId:self.currentReviewItem.itemLocationRowId];
  	productPopOverViewController.currentUnitID = self.currentUnit.unitId;
	  productPopOverViewController.currentUnit = self.currentUnit;
    productPopOver=[[PCPopoverController alloc]initWithContentViewController:productPopOverViewController andTintColor:[UIColor whiteColor]];
    productPopOver.popoverContentSize = CGSizeMake(popWidth, POPOVER_HEIGHT);
    productPopOver.delegate=self;
    
    //    productPopOver.popoverBackgroundViewClass = [PopoverBackgroundView class];
    
    [productPopOver presentPopoverFromRect:frame inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


- (void)addDescriptionPopOver:(NSString *)text{
    
    AppDelegate *delegate = DELEGATE;
    delegate.lockOrientation = YES;
    DescriptionPopOverController *descriptionPopOverController=[[DescriptionPopOverController alloc]initWithCompletionBlock:^(id data, BOOL result) {
        
        [descriptionPopOver dismissPopoverAnimated:YES];
        delegate.lockOrientation = NO;
        
        if (result) {
            
//            [lblDescription setText:data];
            
            self.currentReviewItem.itemDescription = data;
            
            CustomerCareTable *customerCareTable = (CustomerCareTable *)self.parentController;
            
            [customerCareTable itemCellUpdated:self withObject:self.currentReviewItem];

          }
    }];
    
//    [descriptionPopOver setDelegate:self];
    
    
    [descriptionPopOverController setDescriptionText:text];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:descriptionPopOverController];
    
    descriptionPopOver=[[UIPopoverController alloc]initWithContentViewController:navController];
    descriptionPopOver.popoverContentSize = CGSizeMake(DESCRIPTION_POPOVER_WIDTH, DESCRIPTION_POPOVER_HEIGHT);
    descriptionPopOver.delegate=self;
    
    [descriptionPopOver presentPopoverFromRect:lblHelperDescription.frame inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}


- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    
    AppDelegate *delegate = DELEGATE;
    delegate.lockOrientation = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"NO"];
    return YES;
}


- (void)showItemPhotosPopOver{
    
    
    AppDelegate *delegate = DELEGATE;
    delegate.lockOrientation = YES;
    
    ItemPhotosPopOverController *itemPhotosPopOverController = [[ItemPhotosPopOverController alloc]initWithNibName:@"ItemPhotosPopOverController" bundle:nil andCompletionBlock:^(id data, BOOL hasImage, BOOL shouldHide) {
       
        delegate.lockOrientation = NO;
        if (shouldHide) {
            
            [itemPhotosPopOver dismissPopoverAnimated:YES];

        }
        
        if (!hasImage) {
            
            [btnImageFolder setHidden:YES];
            CGPoint center = btnCamera.center;
            center.y = self.contentView.center.y;
            [btnCamera setCenter:center];
            
        }
        
        NSArray *array = (NSArray *)data;
        [lblImageCount setText:array.count?[NSString stringWithFormat:@"%d", array.count]:@""];
    }];
    
    [itemPhotosPopOverController setMainController:self.controller];
    itemPhotosPopOverController.allImageArray = self.currentReviewItem.reviewItemImages;
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:itemPhotosPopOverController];
    
    itemPhotosPopOver=[[UIPopoverController alloc]initWithContentViewController:navController];
    itemPhotosPopOver.popoverContentSize = CGSizeMake(ITEM_PHOTOS_POPOVER_WIDTH, ITEM_PHOTOS_POPOVER_HEIGHT);
    itemPhotosPopOver.delegate=self;
    
    [itemPhotosPopOver presentPopoverFromRect:btnImageFolder.frame inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


- (void)hidePopOvers{
    
    if ([locationPopOver isPopoverVisible]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"NO"];
        [locationPopOver dismissPopoverAnimated:YES];
    }
    if ([productPopOver isPopoverVisible]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:OVERLAY_NOTIFICATION object:@"NO"];
        [productPopOver dismissPopoverAnimated:YES];
    }
}

-(void)showCustomActionSheet:(UIButton *)sender
{
    
    [sender setEnabled:NO];
    
    ActionSheetView *actionSheetView = [[ActionSheetView alloc]initWithFrame:CGRectMake(ACTION_SHEET_VIEW_X, ACTION_SHEET_VIEW_Y, ACTION_SHEET_VIEW_WIDTH, ACTION_SHEET_VIEW_HEIGHT) andCompletionBlock:^(id data, int index, BOOL shouldHide) {
        
        [modalView hide];
        [self selectionsMade:index];
        
    }];
    
    NSString *nibName = @"ActionSheetView";
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:actionSheetView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [actionSheetView setTag:ACTION_SHEET_TAG];
    [actionSheetView addSubview:viewFromXib];
    [actionSheetView setAndReloadData];
    
    CustomerCareViewController *obj = (CustomerCareViewController *)self.controller;
    
    [actionSheetView roundedBorderWithWidth:4.0 andColor:[UIColor clearColor]];
    
    [actionSheetView setCenter:obj.view.center];
    modalView = [[RNBlurModalView alloc]initWithViewController:obj view:actionSheetView];
    [modalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay-0.25.png"]]];
    [modalView show];
    
    [self performSelector:@selector(enableButton) withObject:nil afterDelay:0.5];
}

- (void)enableButton{
    
    [btnCamera setEnabled:YES];
}

- (void)selectionsMade:(int)index{
    
    switch (index) {
        case 0:
        {
            
            GalleryPhotosViewController *object = [[GalleryPhotosViewController alloc]initWithNibName:@"GalleryPhotosViewController" bundle:nil];
            
            UINavigationController *myController = [[UINavigationController alloc]initWithRootViewController:object];
            
            [object setReviewItem:self.currentReviewItem];
            
            NSMutableArray *array = self.currentReviewItem.reviewItemImages;
            
            [object setCheckedAssetsArray:self.currentReviewItem.reviewItemImages?array:[NSMutableArray new]];
            
            [object setArrayWithCompletionBlock:self.currentReviewItem.reviewItemImages completionHandler:^(id response, NSError *error, BOOL result) {
                
                
                if(result){
                    
                    [[ReviewItemImageDatabase sharedDatabase] deleteFromItemImageTable:self.currentReviewItem.reviewItemRowId];
                    
                    [[ReviewItemImageDatabase sharedDatabase] insertItemImages:response];
                    
                    NSMutableArray *arr = (NSMutableArray *)response;
                    
                    if (arr.count) {
                        
                        [btnImageFolder setHidden:NO];
                        CGRect frame = [btnCamera frame];
                        frame.origin.y = btnImageFolder.frame.origin.y+btnImageFolder.frame.size.height+10;
                        [btnCamera setFrame:frame];
                        [lblImageCount setText:[NSString stringWithFormat:@"%d", arr.count]];
                        
                    }
                    else{
                        
                        [btnImageFolder setHidden:YES];
                        CGPoint center = btnCamera.center;
                        center.y = self.contentView.center.y;
                        [btnCamera setCenter:center];
                        
                        [lblImageCount setText:@""];
                        
                    }
                    
                }
                
                self.currentReviewItem.reviewItemImages = response;
                
            }];
            
            [self.controller presentViewController:myController animated:YES completion:^{
                
            } ];
        }
            break;
            
        case 1:
            
        {
            
            [[AVCameraManager sharedManager] capturePhoto:_controller andCompletionHandler:^(id data, BOOL result) {
                
                if (result) {
                    
                    
                    ReviewItemImage *reviewItemImage = (ReviewItemImage *)data;
                    reviewItemImage.reviewItemRowId = self.currentReviewItem.reviewItemRowId;
                    
                    [[ReviewItemImageDatabase sharedDatabase] insertItemImages:[NSMutableArray arrayWithObject:reviewItemImage]];
                    
                    [self.currentReviewItem.reviewItemImages addObject:reviewItemImage];

                    [lblImageCount setText:[NSString stringWithFormat:@"%d", self.currentReviewItem.reviewItemImages.count]];
                    
                    [btnImageFolder setHidden:NO];
                    CGRect frame = [btnCamera frame];
                    frame.origin.y = btnImageFolder.frame.origin.y+btnImageFolder.frame.size.height+10;
                    [btnCamera setFrame:frame];
                    
                }
                
            }];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state{
    
    [super didTransitionToState:state];

}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    
    if (state == UITableViewCellStateDefaultMask) {
        

        
    } else if ((state & UITableViewCellStateShowingEditControlMask) && (state & UITableViewCellStateShowingDeleteConfirmationMask)) {
        

        
        if ([Utility isiOSVersion6]) {
            
            if (self.currentReviewItem.reviewItemImages.count) {
                
                [lblImageCount setHidden:YES];
                [btnImageFolder setHidden:YES];
            }
            [btnCamera setHidden:YES];
        }
                
    } else if (state & UITableViewCellStateShowingEditControlMask) {
        

        
        if ([Utility isiOSVersion6]) {
            
            if (self.currentReviewItem.reviewItemImages.count) {
                
                [lblImageCount setHidden:NO];
                [btnImageFolder setHidden:NO];
            }
            [btnCamera setHidden:NO];
        }
        
    }
    else if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        

    }

}



@end
