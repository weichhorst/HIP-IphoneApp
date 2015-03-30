//
//  ItemPhotosPopOverController.h
//  Conasys
//
//  Created by user on 5/20/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemPhotosPopOverController : UIViewController

{
    
    void(^completionBlock)(id data, BOOL hasImage, BOOL shouldHide);
    IBOutlet UIScrollView *myScrollView;
    
    BOOL editingMode;
    IBOutlet UIView *bottomView;
    NSMutableArray *selectedImageArray;
    UIBarButtonItem * editBtn;
    IBOutlet UIButton *btndeSelect;
    
    IBOutlet UIButton *deleteButton;
}


@property (nonatomic, retain)id mainController;
@property (nonatomic, retain)NSMutableArray *allImageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCompletionBlock:(void(^)(id data, BOOL hasImage, BOOL shouldHide))myBlock;

@end
