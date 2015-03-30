//
//  DescriptionPopOverController.h
//  Conasys
//
//  Created by user on 5/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryHeaderFile.h"

@interface DescriptionPopOverController : UIViewController<UITextViewDelegate>
{
    
    void(^completionBlock)(id data, BOOL result);
    
    __weak IBOutlet UITextView *txtView;
    
}
@property (nonatomic, retain)NSString *descriptionText;

- (id)initWithCompletionBlock:(void(^)(id data, BOOL result))myBlock;

@end
