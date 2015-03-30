//
//  ActionSheetView.m
//  Conasys
//
//  Created by user on 7/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ActionSheetView.h"

@implementation ActionSheetView

- (id)initWithFrame:(CGRect)frame andCompletionBlock:(void(^)(id data, int buttonTag, BOOL shouldHide))myBlock
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        completionBlock = myBlock;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [optionsArray count];
}

- (void)setAndReloadData{
    
    [headerLabel setText:NSLocalizedString(@"Customer_Cell_Select_Option", @"")];
    [headerLabel setFont:[UIFont regularWithSize:15.0f]];
    optionsArray = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"Customer_Cell_Select_Option_Gallery", @""), NSLocalizedString(@"Customer_Cell_Select_Option_Camera", @""), NSLocalizedString(@"Customer_Cell_Cancel", @""), nil];
    
    [optionTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [TableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, cell.contentView.frame.size.width, 1)];
//    [imageView setTag:1];
//    [imageView setBackgroundColor:[UIColor whiteColor]];
//    [cell.contentView addSubview:imageView];

    
    [cell.textLabel setText:[optionsArray objectAtIndex:indexPath.section]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setTextColor:COLOR_BLUE_APP];
    [cell.textLabel setFont:[UIFont regularWithSize:15.0f]];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    completionBlock(nil, indexPath.section, YES);
}
@end
