//
//  ItemPhotosPopOverController.m
//  Conasys
//
//  Created by user on 5/20/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ItemPhotosPopOverController.h"
#import "ReviewItemImage.h"
#import "CustomerCareViewController.h"
#import "ZoomedPhotoViewController.h"

@interface ItemPhotosPopOverController ()

@end

@implementation ItemPhotosPopOverController

#define TITLE_SELECT_ALL @"Select All"
#define TITLE_DE_SELECT_ALL @"Deselect All"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCompletionBlock:(void(^)(id data, BOOL hasImage, BOOL shouldHide))myBlock
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        completionBlock = myBlock;
    }
    return self;
}


- (id)initWithCompletionBlock:(void(^)(id data, BOOL hasImage, BOOL shouldHide))myBlock{
    
    self = [super init];
    
    if (self) {
        
        completionBlock = myBlock;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedImageArray = [NSMutableArray new];
    
    if([Utility isiOSVersion8])
    {
        [myScrollView setFrame:CGRectMake(myScrollView.frame.origin.x, 44, myScrollView.frame.size.width, myScrollView.frame.size.height)];
    }
    
    [self addBarButtonItems];
    [self createAndShowImages];
}

- (void)addBarButtonItems{
    
    
    UIBarButtonItem * cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClk:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    
    
    editBtn = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClk:)];
    [self.navigationItem setRightBarButtonItem:editBtn];
    
    [deleteButton setTitleColor:COLOR_BLUE_APP forState:UIControlStateNormal];
}

- (void)cancelButtonClk:(UIBarButtonItem *)sender{
    
    completionBlock(self.allImageArray, YES, YES);
}


- (void)editButtonClk:(UIBarButtonItem *)sender{
    
    CGRect frame = myScrollView.frame;
    [selectedImageArray removeAllObjects];
    
    [self setSelection:NO];
    [btndeSelect setTitle:TITLE_SELECT_ALL forState:UIControlStateNormal];
    
    if ([sender.title isEqualToString:@"Done"]) {
        
        [sender setTitle:@"Edit"];
        [sender setStyle:UIBarButtonItemStylePlain];
			
			float heightTodecrease = bottomView.frame.size.height;
			if([Utility isiOSVersion8])
				heightTodecrease+=44;
			
			
			frame.size.height +=heightTodecrease;
			
			
       // frame.size.height +=bottomView.frame.size.height;
        
    }
    else{
        
        [sender setTitle:@"Done"];
        [sender setStyle:UIBarButtonItemStyleDone];
			
			float heightTodecrease = bottomView.frame.size.height;
			if([Utility isiOSVersion8])
				heightTodecrease+=44;
				
			
        frame.size.height -=heightTodecrease;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [myScrollView setFrame:frame];
    }];
    
}

- (IBAction)deletePressed:(id)sender{
    
    
    if (selectedImageArray.count) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (UIView *view in myScrollView.subviews) {
                
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)view;
                    
                    if ([button isSelected]) {
                        
                        [button removeFromSuperview];
                    }
                }
            }
        });
        
        
        [[ReviewItemImageDatabase sharedDatabase] deleteItemImage:selectedImageArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (ReviewItemImage *asset in selectedImageArray) {
                
                [self.allImageArray removeObject:asset];
            }
            [myScrollView removeAllSubviews];
            
            [self createAndShowImages];
            
            completionBlock(self.allImageArray, self.allImageArray.count?YES:NO, NO);
            
        });
    }
}



- (IBAction)selectAllPressed:(UIButton *)sender{
    
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:TITLE_SELECT_ALL]) {
        
        [self setSelection:YES];
        selectedImageArray = _allImageArray;
        [sender setTitle:TITLE_DE_SELECT_ALL forState:UIControlStateNormal];
    }
    else{
        
        [self setSelection:NO];
        [sender setTitle:TITLE_SELECT_ALL forState:UIControlStateNormal];
        [selectedImageArray removeAllObjects];
    }
}



- (void)setSelection:(BOOL)flag{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (UIView *view in myScrollView.subviews) {
            
            if ([view isKindOfClass:[UIButton class]]) {
                
                UIButton *button = (UIButton *)view;
                [button setSelected:flag];
            }
        }
    });
}



- (void)createAndShowImages{
    
    
    float x = 6;
    float y= 20;
    float height = 100;
    float width = 100;
    int numberOfPhotosInRow = 3;
    
    float allowedSpacing = (self.view.frame.size.width/numberOfPhotosInRow)-width;
    
    float startXPoint = allowedSpacing/2;

    
    for (int i=0; i<[_allImageArray count]; i++) {

        
        if (i%numberOfPhotosInRow==0) {
            
            if(i>0){
                y=y+height+allowedSpacing;
            }
            
            x=startXPoint;
            
        }else {
            
            x=x+width+allowedSpacing;
        }
        
        ReviewItemImage *reviewItemImage  = (ReviewItemImage *)[_allImageArray objectAtIndex:i];
                
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(x, y, width, height)];
        
        [button setBackgroundColor:[UIColor lightGrayColor]];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:@"overlay_popOverImage.png"] forState:UIControlStateSelected];
        
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:[NSURL URLWithString:reviewItemImage.itemImagePath] resultBlock: ^(ALAsset *asset){
            
            
        [button setBackgroundImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];

        } failureBlock:^(NSError *error) {
            
        }];
        
        [button setTag:i];
        
        [myScrollView addSubview:button];

    }
    
    [myScrollView setContentSize:CGSizeMake(0, y+130)];
    
}

- (void)buttonClicked:(UIButton *)sender{
    
    if ([editBtn.title isEqualToString:@"Edit"]) {
        
        [self showFullImage:sender];
        return;
    }
    
    [sender setSelected:!sender.isSelected];
    
    if ([sender isSelected]) {
        
        [selectedImageArray addObject:[_allImageArray objectAtIndex:sender.tag]];
    }
    else{
        
        [selectedImageArray removeObject:[_allImageArray objectAtIndex:sender.tag]];
    }
}


- (void)showFullImage:(UIButton *)sender{
    
    completionBlock(self.allImageArray, YES, YES);
    
    ReviewItemImage *reviewItemImage  = (ReviewItemImage *)[_allImageArray objectAtIndex:sender.tag];
    
    CustomerCareViewController *obj = (CustomerCareViewController *)self.mainController;
    
    ZoomedPhotoViewController *zoomedVC = [[ZoomedPhotoViewController alloc]initWithNibName:@"ZoomedPhotoViewController" bundle:nil];
    
    [zoomedVC setBase64String:reviewItemImage.base64String];
    [zoomedVC setImagePath:reviewItemImage.itemImagePath];
    
    [obj.navigationController pushViewController:zoomedVC animated:YES];
    
    return;
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
