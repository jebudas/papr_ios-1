//
//  PaprCellProfile.m
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellProfile.h"

@implementation PaprCellProfile

- (void)awakeFromNib {

    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

- (void) setupButtons {

    if (self.thisIsMe) {
        
        self.buFollowSettings.backgroundColor = [UIColor paprGreyLight];
        
        [self.buFollowSettings setTitle:@"Settings" forState:UIControlStateNormal];
        
        [self.buFollowSettings setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    } else {
        
        NSArray *arrayOfSubscriptionIDs = [[DataController dc] returnUserSubscriptions];
        
        if ([arrayOfSubscriptionIDs containsObject:self.thisID]) {
        
            iAmSubscribedToThisAccount = TRUE;

            self.buFollowSettings.backgroundColor = [UIColor paprGreyLight];
            
            [self.buFollowSettings setTitle:@"Following" forState:UIControlStateNormal];
            
            [self.buFollowSettings setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        } else {

            iAmSubscribedToThisAccount = FALSE;

            self.buFollowSettings.backgroundColor = [UIColor paprBlue];
            
            [self.buFollowSettings setTitle:@"Follow" forState:UIControlStateNormal];
            
            [self.buFollowSettings setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
        
    }

    // ROUNDED CORNERS
    self.buFollowSettings.layer.masksToBounds = YES;
    self.buFollowSettings.layer.cornerRadius = 5;

    
}
- (void) setupLabels {
    
    //[DataController dc].currentProfileDictionary
    NSDictionary *userProfileDictionary = [[NSDictionary alloc] initWithDictionary: [[DataController dc].currentUserDictionary objectForKey:@"user_profile"] ];
    NSLog(@"PaprCellProfile . userProfileDictionary = %@", userProfileDictionary);
    
    self.labelPosts.text = [userProfileDictionary objectForKey:@"user_profile_stat_posts"];
    self.labelFollowers.text = [userProfileDictionary objectForKey:@"user_profile_stat_followers"];
    self.labelFollowing.text = [userProfileDictionary objectForKey:@"user_profile_stat_following"];
//    self.labelName.text = [userProfileDictionary objectForKey:@"user_profile_display_name"];
//    self.labelBlurb.text = [userProfileDictionary objectForKey:@"user_profile_blurb"];
//    [self.buURL setTitle:[userProfileDictionary objectForKey:@"user_profile_avatar_url"] forState:UIControlStateNormal];
    
}

#pragma mark - API METHODS

- (void) notifyPublisher {
    
    NSDictionary *followDictionary = @{@"type_field" : @"followers",
                                       @"user_username" : [[DataController dc] returnMyUsername],
                                       @"friend_id": [[DataController dc] returnMyUserID],
                                       @"friend_username" : [[DataController dc] returnMyUsername],
                                       @"friend_avatar_url": [[DataController dc] returnMyAvatarURL],
                                       @"timestamp": [[DataController dc] returnTimestamp],
                                       @"comment": @"-",
                                       @"post_id":@"-",
                                       @"publisher_id" : [[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"],
                                       @"subscriber_id" : [[DataController dc] returnMyUserID]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendNotifications" object:nil userInfo:@{@"notifications":followDictionary}];
    
}
- (void) updateMyFollowStatusForPublisher : (BOOL)follow {

    NSString *followStatus = [NSString stringWithFormat:@"%i", (int)follow];
    
    NSDictionary *followDictionary = @{@"i_should_follow" : followStatus,
                                         @"publisher_id" : [[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"],
                                         @"subscriber_id" : [[DataController dc] returnMyUserID]};
    
    [[APIController api] updateMyFollowStatusForPublisher:followDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprCellProfile . updateMyFollowStatusForPublisher . success = %@", responseDictionary);
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprCellProfile . updateMyFollowStatusForPublisher . error = %@", error);
        
    }];
    
}

- (IBAction) buURLSelected : (id)sender {

    NSLog(@"buURLSelected");
    
    NSDictionary *userProfileDictionary = [[NSDictionary alloc] initWithDictionary: [[DataController dc].currentUserDictionary objectForKey:@"user_profile"] ];
    NSString *cellURL = [userProfileDictionary objectForKey:@"user_profile_url"];
    
    if (cellURL.length < 7) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushSafariBrowser" object:nil userInfo:@{@"url" : cellURL}];

}
- (IBAction) buFollowSettingsSelected : (id)sender {
    
    if (self.thisIsMe) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileSettingsVC" object:nil];
        
    } else {
        
        if (iAmSubscribedToThisAccount) {
            
            // UNSUBSCRIBE
            iAmSubscribedToThisAccount = FALSE;
            
            [self updateMyFollowStatusForPublisher : NO];
            
            [[DataController dc] updateUserSubscriptions:self.thisID subscribeToThisUser:NO];
            
        } else {
            
            // SUBSCRIBE
            iAmSubscribedToThisAccount = TRUE;
            
            [self updateMyFollowStatusForPublisher : YES];

            [self notifyPublisher];
            
            [[DataController dc] updateUserSubscriptions:self.thisID subscribeToThisUser:YES];
            
        }
        
        [self setupButtons];
        
    }
    
    // TODO GGXGG: REFRESH PAPRS
    
}

@end


//        // SETUP LABEL . FOLLOWING
//        int myFollowing = (int)[[DataController dc] returnUserSubscriptions].count;
//        self.labelFollowing.text = [NSString stringWithFormat:@"%i", myFollowing];
//
//        // SETUP LABEL . POSTS
//        self.labelPosts.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPostTotal"];
//
