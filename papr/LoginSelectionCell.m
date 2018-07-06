//
//  LoginSelectionCell.m
//  papr
//
//  Created by Brian WF Tobin on 8/18/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "LoginSelectionCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation LoginSelectionCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // self.labelSubscription.font = [UIFont FONTNAME];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    
    if (iHaveSetupButtons) {
        // CHILL
    } else {

        iHaveSetupButtons = TRUE;

        [self updateButtons];
        
        // ROUNDED CORNER
        self.imageViewSubscription.backgroundColor = [UIColor clearColor];
        self.imageViewSubscription.layer.masksToBounds = YES;
        self.imageViewSubscription.layer.cornerRadius = 5;
        
        // BU ADD
        self.buAdd.layer.masksToBounds = YES;
        self.buAdd.layer.cornerRadius = 5;
        
        // BU REMOVE
        self.buRemove.layer.masksToBounds = YES;
        self.buRemove.layer.cornerRadius = 5;
        self.buRemove.layer.borderWidth = 1.0f;
        self.buRemove.layer.borderColor = [UIColor lightGrayColor].CGColor;

    }

}

#pragma mark - BUTTON METHODS

- (void) updateButtons {
    
    NSString *publisherID = [self.cellDictionary objectForKey:@"PUBLISHER_ID"];
    
    if ([[DataController dc] iSubscribeToThisPublisher:publisherID]) {
        
        self.buAdd.alpha = 0.0;
        self.buRemove.alpha = 1.0;

    } else {
        
        self.buAdd.alpha = 1.0;
        self.buRemove.alpha = 0.0;

    }
    
}
- (IBAction) buAddRemoveSelected : (id)sender {
    
    [DataController dc].iUpdatedMySubscriberList = TRUE;

    NSString *publisherID = [self.cellDictionary objectForKey:@"PUBLISHER_ID"];
    NSString *publisherName = [self.cellDictionary objectForKey:@"display_title"];

    if ([[DataController dc] iSubscribeToThisPublisher:publisherID]) {
    
        [[DataController dc] updateUserSubscriptions:publisherID subscribeToThisUser:NO];

        NSString *subscriptionString = [NSString stringWithFormat: @"User Unsubscribed: %@", publisherName];
        [[Mixpanel sharedInstance] track:@"Papr . Sources" properties: @{@"Action": subscriptionString}];

    } else {
        
        [[DataController dc] updateUserSubscriptions:publisherID subscribeToThisUser:YES];

        NSString *subscriptionString = [NSString stringWithFormat: @"User Subscribed: %@", publisherName];
        [[Mixpanel sharedInstance] track:@"Papr . Sources" properties: @{@"Action": subscriptionString}];

    }

    [self updateButtons];

}



@end

