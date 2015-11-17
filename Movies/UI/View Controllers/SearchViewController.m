//
//  ActorsViewController.m
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import "SearchViewController.h"
#import "OptionTableViewCell.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.actors = [NSArray arrayWithObjects: @"Jill Valentine", @"Peter Griffin", @"Meg Griffin", @"Jack Lolwut",
              @"Mike Roflcoptor", @"Cindy Woods", @"Jessica Windmill", @"Alexander The Great",
              @"Sarah Peterson", @"Scott Scottland", @"Geoff Fanta", @"Amanda Pope", @"Michael Meyers",
              @"Richard Biggus", @"Montey Python", @"Mike Wut", @"Fake Person", @"Chair",
              nil];
    
    self.searchResults = [self.actors mutableCopy];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"OptionCell"];
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
    
    return self.searchResults.count;    //count number of row from counting array hear cataGorry is An Array
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
    cell.optionLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    NSArray *results =[self.actors filteredArrayUsingPredicate:resultPredicate];
    self.searchResults = [results mutableCopy];
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
    self.searchResults = [self.actors mutableCopy];
    [self.tableView reloadData];
}



@end
