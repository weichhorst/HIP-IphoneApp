//
//  ProductPopOverViewController.m
//  Conasys
//
//  Created by user on 5/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ProductPopOverViewController.h"
#import "Product.h"
#import "ProductDBManager.h"
#import "UnitDataBase.h"

@interface ProductPopOverViewController ()

@end

#define HEADER_HEIGHT 25

@implementation ProductPopOverViewController

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
    
    allProducts = [NSMutableArray new];
    
    allProducts = [[ProductDBManager sharedManager] getAllProductsForLocation:self.locationId];
	
	
	// Now we need to add otherProduct entries to each product while maintaing sortOrder and avoiding deplicacy
	UnitDataBase * unitDB = [[UnitDataBase alloc]init];
	NSInteger currentUnitLocationRowId = [unitDB getLocationRowIdForOtherLocation:self.currentUnit.unitId];

		NSMutableArray * otherProducts =[[ProductDBManager sharedManager] getAllProductsForLocation:currentUnitLocationRowId];
	
		NSMutableArray * allProductID = [[NSMutableArray alloc]init];
		
		NSMutableArray * otherProductID = [[NSMutableArray alloc]init];

		for(Product * product in allProducts){
			[allProductID addObject: product.productId];
		}
		for (Product * product in otherProducts) {
			[otherProductID addObject: product.productId];
		}
	
		for (Product * otherProduct in otherProducts)  {
			if(!([allProductID containsObject:otherProduct.productId]))
			[allProducts addObject:otherProduct];
		}

//	  [allProducts sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	 NSMutableArray * indentedEntries = [[NSMutableArray alloc]init];
	 NSMutableArray * nonIndentedEntries = [[NSMutableArray alloc]init];

	 for (Product * product in allProducts) {
			if(!(product.isIndented))
				 [indentedEntries addObject:product];
		 else
			 [nonIndentedEntries addObject:product];
		}
	
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productName"
																							 ascending:YES];
	NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
	indentedEntries = [[indentedEntries sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
	NSMutableArray * newAllProductsArray = [[NSMutableArray alloc]init];
	for (Product * product in indentedEntries) {
		NSMutableArray * thisProductsItems = [[NSMutableArray alloc]init];
		for (Product * allProduct in allProducts) {
			if (([allProduct.parentID isEqualToString:product.parentID])&& (allProduct.isIndented)) {
				[thisProductsItems addObject:allProduct];
			}
		}
//			sort thisproducts entries here alphabatically
		thisProductsItems = [[thisProductsItems sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
		[newAllProductsArray addObject:product];
			for (Product * thisProductItem in thisProductsItems) {
				[newAllProductsArray addObject:thisProductItem];
			}
	}
	
	
	Product * miscellaneous;
	for (Product * product in allProducts) {
		if ([product.productId isEqualToString:@"-1"]) {
			 miscellaneous = product;
			[newAllProductsArray removeObject:product];
		}
	}
	[newAllProductsArray insertObject:miscellaneous atIndex:0];
//	[newAllProductsArray addObject:miscellaneous];
	allProducts = newAllProductsArray;

	if ((![Utility isiOSVersion6]) && ![Utility isiOSVersion8]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
	
    
    if ([Utility isiOSVersion6]) {
        
        CALayer *layer = [self.tableView layer];
        [layer setCornerRadius:3.0f];
    }
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.view.superview.layer.cornerRadius = 0;
    [super viewWillAppear:animated];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0;

    return HEADER_HEIGHT;
}


- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
    // Two sections, one for each detail view controller.
    return allProducts.count;
}



- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [TableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
//    cell.imageView.image=[UIImage imageNamed:@"popIcon5.png"];
	
    Product *product = (Product * )[allProducts objectAtIndex:indexPath.row];
	
	
    if (product.isIndented) {
        
        cell.textLabel.font = [UIFont regularWithSize:14.0f];
        cell.textLabel.text=[NSString stringWithFormat:@"%@%@", product.isIndented?@"   ":@"",product.productName];
    }
    else{
        
        cell.textLabel.font = [UIFont semiBoldWithSize:13.0f];
        cell.textLabel.text=[product.productName uppercaseString];
    }
    
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    

    [cell setBackgroundColor:product.isIndented?COLOR_OFFWHITE_CELL_APP:COLOR_LIGHTGRAY_CELL_APP];

    if ([Utility isiOSVersion6]) {
        
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    [cell.contentView setBackgroundColor:product.isIndented?COLOR_OFFWHITE_CELL_APP:COLOR_LIGHTGRAY_CELL_APP];
    
//    if([Utility isiOSVersion8])
//    {
//        UILabel *bottomDivider = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.contentView.frame.size.height-1, cell.contentView.frame.size.width, 1)];
//        [bottomDivider setBackgroundColor:[UIColor lightGrayColor]];
//        [cell addSubview:bottomDivider];
//    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Product *product = (Product * )[allProducts objectAtIndex:indexPath.row];
   
    if (!product.isIndented) {
        
        return 30.0f;
    }
    return 40.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product = [allProducts objectAtIndex:indexPath.row];
    product.category = [self getCategory:indexPath];
    completionBlock(product, indexPath, YES);
}


- (NSString *)getCategory:(NSIndexPath *)indexPath{
    
    NSString *category=@"";
    Product *product = [allProducts objectAtIndex:indexPath.row];
	
    if (!product.isIndented) {
        
        return category;
    }
    
    for (int i=indexPath.row; i>=0; i--) {
        
        Product *product = [allProducts objectAtIndex:i];
        
        if (!product.isIndented) {
            
            return [NSString stringWithFormat:@"%@ - ", product.productName];
        }
    }
    
    return category;
}


@end
