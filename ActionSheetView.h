//
//  ActionSheetView.h
//  Conasys
//
//  Created by user on 7/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@interface ActionSheetView : BaseView{
    
    IBOutlet UITableView *optionTableView;
    void(^ completionBlock)(id data, int buttonTag, BOOL shouldEdit);
    NSMutableArray *optionsArray;
    IBOutlet UILabel *headerLabel;
}


- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock;

- (void)setAndReloadData;

@end
