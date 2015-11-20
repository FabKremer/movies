//
//  OptionTableViewCell.h
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OptionCellState) {
    OptionStateNegative,
    OptionStatePositive,
    OptionStateNeutral,
};

@protocol OptionCellDelegate<NSObject> //define delegate protocol

- (void) didPositiveOptionWithName:(NSString*)name;
- (void) didNagativeOptionWithName:(NSString*)name;
- (void) didRemovePositiveOptionWithName:(NSString*)name;
- (void) didRemoveNagativeOptionWithName:(NSString*)name;

@end

@interface OptionTableViewCell : UITableViewCell

@property (weak, nonatomic) id <OptionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (assign, nonatomic) OptionCellState state;

@end
