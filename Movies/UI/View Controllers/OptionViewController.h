//
//  ActorsViewController.h
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
