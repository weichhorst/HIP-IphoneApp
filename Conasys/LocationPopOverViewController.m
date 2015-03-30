//
//  LocationPopOverViewController.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "LocationPopOverViewController.h"
#import "Location.h"
#import "LocationDBManager.h"

@interface LocationPopOverViewController ()

@end

@implementation LocationPopOverViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCompletionBlock:(void(^)(id data, NSIndexPath *indexPath, BOOL result))myBlock{
    
    self = [super init];
    
    if (self) {
        
        completionBlock = myBlock;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    if (![Utility isiOSVersion6]) {
//        
//        
//    }
    if ([Utility isiOSVersion6]) {
        
        CALayer *layer = [self.tableView layer];
        [layer setCornerRadius:3.0f];
    }
    else if ([Utility isiOSVersion8])
    {
        [self.tableView.layer setCornerRadius:3.0f];
    }
    else{
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.view.superview.layer.cornerRadius = 0;
    
    [self.view.layer setCornerRadius:0.0f];
    [self.tableView.layer setCornerRadius:0.0f];
    [super viewWillAppear:animated];
    if ([Utility isiOSVersion6]) {
        
        CALayer *layer = [self.tableView layer];
        [layer setCornerRadius:3.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // Two sections, one for each detail view controller.
    return self.currentUnit.locationList.count;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
    
    
    if([Utility isiOSVersion8])
    {
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsMake(0, -20, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, -20, 0, 0)];
            cell.preservesSuperviewLayoutMargins =NO ;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [TableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
//    cell.imageView.image=[UIImage imageNamed:@"popIcon5.png"];
    
    cell.textLabel.text=[(Location *)[self.currentUnit.locationList objectAtIndex:indexPath.row] locationName];
    [cell.textLabel setFont:[UIFont regularWithSize:14.0f]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    completionBlock(Nil, indexPath, YES);
}


@end
