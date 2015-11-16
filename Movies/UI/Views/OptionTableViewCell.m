//
//  OptionTableViewCell.m
//  Movies
//
//  Created by Fernanda Toledo on 16/11/15.
//  Copyright © 2015 iKode Ltd. All rights reserved.
//

#import "OptionTableViewCell.h"

@implementation OptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self addGestureRecognizer:lpgr];
    
    UITapGestureRecognizer *press = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    

}

-(IBAction) handlePress:(UITapGestureRecognizer *)sender {
    NSLog(@"Normal Press");
    self.backgroundColor = [UIColor greenColor];
}

-(IBAction) handleLongPress:(UITapGestureRecognizer *)sender {
    NSLog(@"Long Press");
    self.backgroundColor = [UIColor redColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
