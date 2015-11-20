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
    if (self.state == OptionStateNeutral) {
        self.state = OptionStatePositive;
        self.optionLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:38/255.f green:166/255.f blue:91/255.f alpha:1];
        [self.delegate didPositiveOptionWithName:self.optionLabel.text];
    } else {
        self.optionLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        if (self.state == OptionStateNegative) {
            [self.delegate didRemoveNagativeOptionWithName:self.optionLabel.text];
        }else {
            //OptionStatePositive
            [self.delegate didRemovePositiveOptionWithName:self.optionLabel.text];
        }
        
        self.state = OptionStateNeutral;
    }
}

-(IBAction) handleLongPress:(UITapGestureRecognizer *)sender {
    self.state = OptionStateNegative;
    self.optionLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:214/255.f green:69/255.f blue:65/255.f alpha:1];
    [self.delegate didNagativeOptionWithName:self.optionLabel.text];
}

@end
