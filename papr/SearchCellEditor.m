//
//  SearchCellEditor.m
//  papr
//
//  Created by Brian WF Tobin on 9/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "SearchCellEditor.h"

@implementation SearchCellEditor

- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    [self setupButtons];

    self.imageViewMain.backgroundColor = [UIColor clearColor];
    self.imageViewMain.layer.masksToBounds = YES;
    self.imageViewMain.layer.cornerRadius = 5;

    self.imageViewAvatar.backgroundColor = [UIColor clearColor];
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.cornerRadius = 5;
    
}
- (void) setupButtons {

    NSString *publisherID = [self.cellDictionary objectForKey:@"PUBLISHER_ID"];
    
    NSArray *arrayOfSubscriptionIDs = [[DataController dc] returnUserSubscriptions];
    
    if ([arrayOfSubscriptionIDs containsObject:publisherID]) {
        
        iAmSubscribedToThisAccount = TRUE;
        
        [self.buFollow setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        [self.buFollow setTitleColor:[UIColor paprGreyLight] forState:UIControlStateNormal];
        
        
    } else {
        
        iAmSubscribedToThisAccount = FALSE;
        
        [self.buFollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [self.buFollow setTitleColor:[UIColor paprBlue] forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - IBACTION METHODS

- (IBAction) buFollowSelected : (id)sender {
    
    [DataController dc].iUpdatedMySubscriberList = TRUE;
    
    NSLog(@"cellDictionary = %@", self.cellDictionary);
    
    NSString *publisherID;
    
    if ( [self.cellDictionary objectForKey:@"PUBLISHER_ID"] ) {
        publisherID = [self.cellDictionary objectForKey:@"PUBLISHER_ID"];
    } else {
        publisherID = [self.cellDictionary objectForKey:@"user_fb_id"];
    }
    
    NSLog(@"publisherID = %@", publisherID);
    
    if (iAmSubscribedToThisAccount) {
        
        // UNSUBSCRIBE
        iAmSubscribedToThisAccount = FALSE;
        
        [self updateMyFollowStatusForPublisher : publisherID : NO];
        
        [[DataController dc] updateUserSubscriptions:publisherID subscribeToThisUser:NO];
        
        [self.buFollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [self.buFollow setTitleColor:[UIColor paprBlue] forState:UIControlStateNormal];
        
    } else {
        
        // SUBSCRIBE
        iAmSubscribedToThisAccount = TRUE;
        
        [self updateMyFollowStatusForPublisher : publisherID : YES];
        
        [self notifyPublisher : publisherID];
        
        [[DataController dc] updateUserSubscriptions:publisherID subscribeToThisUser:YES];
        
        [self.buFollow setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        [self.buFollow setTitleColor:[UIColor paprGreyLight] forState:UIControlStateNormal];
        
    }
    
    
    
}
- (IBAction) buArrowSelected : (id)sender {

    NSLog(@"buArrowSelected");
    
}

#pragma mark - API METHODS

- (void) notifyPublisher : (NSString *)publisherID {
    
    NSDictionary *followDictionary = @{@"type_field" : @"followers",
                                       @"user_username" : [[DataController dc] returnMyUsername],
                                       @"friend_id": [[DataController dc] returnMyUserID],
                                       @"friend_username" : [[DataController dc] returnMyUsername],
                                       @"friend_avatar_url": [[DataController dc] returnMyAvatarURL],
                                       @"timestamp": [[DataController dc] returnTimestamp],
                                       @"comment": @"-",
                                       @"post_id":@"-",
                                       @"publisher_id" : publisherID,
                                       @"subscriber_id" : [[DataController dc] returnMyUserID]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendNotifications" object:nil userInfo:@{@"notifications":followDictionary}];
    
}
- (void) updateMyFollowStatusForPublisher : (NSString *)publisherID : (BOOL)follow {
    
    NSString *followStatus = [NSString stringWithFormat:@"%i", (int)follow];
    
    NSDictionary *followDictionary = @{@"i_should_follow" : followStatus,
                                       @"publisher_id" : publisherID,
                                       @"subscriber_id" : [[DataController dc] returnMyUserID]};
    
    [[APIController api] updateMyFollowStatusForPublisher:followDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"SearchCellAccount . updateMyFollowStatusForPublisher . success = %@", responseDictionary);
        
    } failure:^(NSError *error) {
        
        NSLog(@"SearchCellAccount . updateMyFollowStatusForPublisher . error = %@", error);
        
    }];
    
}


@end
