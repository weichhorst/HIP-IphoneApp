//
//  ViewSelectionPopOverController.m
//  Conasys
//
//  Created by user on 5/15/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ViewSelectionPopOverController.h"
#import "ViewSelectionCell.h"


@interface ViewSelectionPopOverController ()

@end

@implementation ViewSelectionPopOverController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    
    [self.tableView setBackgroundColor:COLOR_SERVICE_POPOVER];
    
    [self.tableView setSeparatorColor:COLOR_BLUE_APP];
 
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if ([Utility isiOSVersion6]) {
        
        CALayer *layer = [self.tableView layer];
        [layer setCornerRadius:3.0f];
    }
	// Do any additional setup after loading the view.
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
    return self.currentProject.serviceTypes.count;
}



- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"ViewSelectionCell";
    
    ViewSelectionCell *cell = [TableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil];
        for (id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]])
            {
                
                cell = (ViewSelectionCell *)currentObject;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
                
            }
        }
    }

    Service *service = [self.currentProject.serviceTypes objectAtIndex:indexPath.row];
    
    [cell.viewName setFont:[UIFont boldSystemFontOfSize:16.0f]];
    cell.viewName.text=service.name;
    [cell.viewName setTextColor:[UIColor whiteColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:COLOR_SERVICE_POPOVER];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    completionBlock([self.currentProject.serviceTypes objectAtIndex:indexPath.row], indexPath, YES);
}

@end
