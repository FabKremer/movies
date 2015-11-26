//
//  OptionsViewController.m
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import "OptionsViewController.h"
#import "KMAppDelegate.h"
#import "OptionsSource.h"
#import "MBProgressHUD.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.positiveOptions = [NSMutableArray array];
    self.negativeOptions = [NSMutableArray array];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"OptionCell"];
    
    [self loadDataForType:self.navigationItem.title];
}

-(void) loadDataForType:(NSString*)type {
    NSString *typeParameter = @"";
    
    if ([self.navigationItem.title isEqualToString: @"Actores"]) {
        typeParameter = @"actors";
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    OptionsListCompletionBlock completionBlock = ^(NSArray* data, NSString* errorString)
    {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (data != nil)
            if (!self.options)
                self.options = [[NSArray alloc] init];
        
        self.options = [NSArray arrayWithArray:data];
        self.optionsSearchResults = [self.options mutableCopy];
        
        [self.tableView reloadData];
    };
    
    OptionsSource* source = [OptionsSource optionsSource];
    [source getOptionsListForType:typeParameter completion:completionBlock];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.optionsSearchResults.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"OptionCell";
    
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OptionTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    NSString *optionName = [self.optionsSearchResults objectAtIndex:indexPath.row];
    cell.optionLabel.text = optionName;
    cell.delegate = self;
    
    if ([self.positiveOptions containsObject:optionName]) {
        cell.state = OptionStatePositive;
        cell.optionLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:38/255.f green:166/255.f blue:91/255.f alpha:1];
    } else if ([self.negativeOptions containsObject:optionName]) {
        cell.state = OptionStateNegative;
        cell.optionLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:214/255.f green:69/255.f blue:65/255.f alpha:1];
    } else {
        cell.state = OptionStateNeutral;
        cell.optionLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    NSArray *results =[self.options filteredArrayUsingPredicate:resultPredicate];
    self.optionsSearchResults = [results mutableCopy];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.optionsSearchResults = [self.options mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - OptionCellDelegate

- (void) didPositiveOptionWithName:(NSString*)name {
    [self.positiveOptions addObject:name];
    [self encapsulateSearch];
}

- (void) didNagativeOptionWithName:(NSString*)name {
    if (![self.negativeOptions containsObject:name]) {
        [self.negativeOptions addObject:name];
        [self encapsulateSearch];
    }
}

- (void) didRemovePositiveOptionWithName:(NSString*)name {
    [self.positiveOptions removeObject:name];
    [self encapsulateSearch];
}

- (void) didRemoveNagativeOptionWithName:(NSString*)name {
    [self.negativeOptions removeObject:name];
    [self encapsulateSearch];
}

-(void) encapsulateSearch {
    if ([self.navigationItem.title isEqualToString: @"Actores"]) {
        KMAppDelegate *appDelegate = (KMAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.searchDictionary[@"actores_positivos"] = self.positiveOptions;
        appDelegate.searchDictionary[@"actores_negativos"] = self.negativeOptions;
    } else if ([self.navigationItem.title isEqualToString: @"Bla bla bla"]) {
        
    }
}

@end
