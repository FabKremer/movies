//
//  OptionsViewController.h
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionTableViewCell.h"

@interface OptionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate, UISearchResultsUpdating, OptionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSMutableArray *optionsSearchResults;

@property (strong, nonatomic) NSMutableArray *positiveOptions;
@property (strong, nonatomic) NSMutableArray *negativeOptions;

@end
