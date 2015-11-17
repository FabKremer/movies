//
//  ActorsViewController.h
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *actors;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end
