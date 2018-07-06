//
//  PaprVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/21/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprVC.h"

@interface PaprVC ()
@end

@implementation PaprVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSLog(@"PaprVC . viewDidLoad");

    scrollAttempts = 0;
    
    [self setupNotifications];

    [self getPaprSubscriptions];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupLocalVariables];

}
- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPaprSubscriptions) name:@"PaprVC.getPaprSubscriptions" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubscriptionCountForWelcomePage) name:@"PaprVC.updateSubscriptionCountForWelcomePage" object:nil];
    // SCROLLVIEW
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableScrolling) name:@"PaprVC.enableScrolling" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableScrolling) name:@"PaprVC.disableScrolling" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToFirstPapr) name:@"PaprVC.scrollToFirstPapr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToLastPapr) name:@"PaprVC.scrollToLastPapr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToCurrentPapr) name:@"PaprVC.scrollToCurrentPapr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToLeft) name:@"PaprVC.scrollToLeft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToRight) name:@"PaprVC.scrollToRight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePaprSubscriptionsWithNewPapr:) name:@"PaprVC.updatePaprSubscriptionsWithNewPapr" object:nil];
    // API
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendStats:) name:@"PaprVC.sendStats" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNotifications:) name:@"PaprVC.sendNotifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForNotifications) name:@"PaprVC.checkForNotifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserFromPaprVC) name:@"PaprVC.updateUserFromPaprVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishUpdatedDictionary) name:@"PaprVC.publishUpdatedDictionary" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToCurrentPapr" object:nil];

}

#pragma mark - API METHODS 

- (void) getPaprSubscriptions {

    [DataController dc].currentZone = @"papr";

    // HIDE PAPR PROGRESS
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hidePaprProgress" object:nil];
    // LOCK PAPR TAB BAR
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.lockPaprTabBar" object:nil];
    

    NSArray *userSubscriptionArray = [[DataController dc] returnUserSubscriptions];

    // RETURN WALL
    if (userSubscriptionArray.count < 1) { return; }
    // RETURN WALL
    
    NSDictionary *subscriptionDictionary = @{@"user_subscriptions" : userSubscriptionArray};

    [[APIController api] getSubscriptions:subscriptionDictionary success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {

            self.arrayOfSubscriptions =
            [[NSArray alloc] initWithArray: [[DataController dc] returnArrayOfFreshPaprDictionaries:[responseDictionary objectForKey:@"user_subscriptions"]] ];
            
            if (self.arrayOfSubscriptions.count > 0) {
                
                // SETUP PAPRs IN SCROLLVIEW
                [self setupScrollViewPapr];
                
                [self addPaprsToScrollview];
                
                
                // REMOVE FAKIE, ADD GOODIE
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprWelcomeVC.circleAnimationStart" object:nil];
                
                [self performSelector:@selector(removeWelcomeFakie) withObject:nil afterDelay:2.0];
                
                

                // SETUP PROGRESS BAR
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprProgressVC.setupProgressBrackets" object:nil];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprProgressVC.updateProgressBar" object:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprProgress" object:nil];
                
                [[Mixpanel sharedInstance] identify: [[DataController dc] returnMyUserID] ];
                
            } else {
            
                NSLog(@"PaprVC . getPaprSubscriptions . success . self.arrayOfSubscriptions = %@", self.arrayOfSubscriptions);

            }
            
        } else {
            
            NSLog(@"PaprVC . getPaprSubscriptions . ELSE . responseDictionary = %@", responseDictionary);
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprVC . getPaprSubscriptions . failure . error = %@", error);
        
    }];
}
- (void) updateUserFromPaprVC {

    NSDictionary *myUserDictionary = [[NSDictionary alloc] initWithDictionary:[[DataController dc] returnMyUserDictionary] ];
    
    [[APIController api] updateUser:myUserDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprVC . updateUserFromPaprVC . success = %@", responseDictionary);
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            [DataController dc].userNeedsUpdate = FALSE;
            
            // TODO GGXGG: UPDATE MIXPANEL FOR PUSH STATUS
            
        } else {
            
            [DataController dc].userNeedsUpdate = TRUE;
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"LoginSelectionVC . updateUserThenPopToRoot . failure . error = %@", error);
        
    }];

    
}
- (void) publishUpdatedDictionary {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showFullScreenMessage" object:nil userInfo:@{@"message" : @"Editing..."}];
    
    NSDictionary *parameters = @{ @"new_edition_dictionary" : [[DataController dc] returnMyPaprDictionary]};
    
    [[APIController api] postItemToPapr:parameters success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            NSLog(@"PaprVC . publishUpdatedDictionary . success . responseDictionary = %@", responseDictionary);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hideFullScreenMessage" object:nil];
            
        } else {
            
            NSLog(@"PaprVC . publishUpdatedDictionary . responseDictionary = %@", responseDictionary);
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprVC . publishUpdatedDictionary . failure . error = %@", error);
        
    }];
    
}
- (void) sendStats : (NSNotification *)notification {
    
    NSDictionary *statsDictionary = [[NSDictionary alloc] initWithDictionary: [notification.userInfo objectForKey:@"stats"] ];
    
    NSLog(@"PaprVC . sendStats . statsDictionary = %@", statsDictionary);
    
    NSDictionary *parameters;
    NSString *statType = [statsDictionary objectForKey:@"type_field"];
    NSString *commentString = [statsDictionary objectForKey:@"comment"];

    if ( [statType isEqualToString:@"views"] ) {
        
        parameters = statsDictionary;

    } else if ( [statType isEqualToString:@"likes"] ) {

        parameters = statsDictionary;

    } else if ( [statType isEqualToString:@"reposts"] ) {
        
        parameters = statsDictionary;

    } else if ( [commentString isEqualToString:@"-"] ) {

        NSLog(@"commentString = %@", commentString);

    } else {
    
        statType = @"comments";

        parameters = @{@"type_field" : statType,
                       @"friend_id": [[DataController dc] returnMyUserID],
                       @"friend_username" : [[DataController dc] returnMyUsername],
                       @"friend_avatar_url": [[DataController dc] returnMyAvatarURL],
                       @"comment": [statsDictionary objectForKey:@"comment"],
                       @"timestamp": [statsDictionary objectForKey:@"timestamp"],
                       @"comment_id":[statsDictionary objectForKey:@"comment_id"],
                       @"publisher_id":[statsDictionary objectForKey:@"publisher_id"]
                       };

    }
    
    [[APIController api] postStats:parameters success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprVC . sendStats . success = %@", responseDictionary);
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprVC . sendStats . error = %@", error);
        
    }];

}
- (void) sendNotifications : (NSNotification *)notification {
    
    NSDictionary *notificationDictionary = [[NSDictionary alloc] initWithDictionary: [notification.userInfo objectForKey:@"notifications"] ];

    NSLog(@"PaprVC . sendStats . notificationDictionary = %@", notificationDictionary);
    
    NSDictionary *parameters;
    NSString *notificationType = [notificationDictionary objectForKey:@"type_field"];
    NSString *commentString = [notificationDictionary objectForKey:@"comment"];
    
    if ( [notificationType isEqualToString:@"followers"] ) {
        
        parameters = notificationDictionary;
        commentString = @"-";
        
    } else if ( [notificationType isEqualToString:@"likes"] ) {
        
        parameters = notificationDictionary;
        
    } else if ( [notificationType isEqualToString:@"reposts"] ) {
        
        parameters = notificationDictionary;
        
    } else if ( [commentString isEqualToString:@"-"] ) {
        
        NSLog(@"commentString = %@", commentString);
        
    } else {
        
        notificationType = @"comments";
        
        parameters = @{@"type_field" : notificationType,
                       @"friend_id": [[DataController dc] returnMyUserID],
                       @"friend_username" : [[DataController dc] returnMyUsername],
                       @"friend_avatar_url": [[DataController dc] returnMyAvatarURL],
                       @"comment": [notificationDictionary objectForKey:@"comment"],
                       @"timestamp": [notificationDictionary objectForKey:@"timestamp"],
                       @"post_id":[notificationDictionary objectForKey:@"comment_id"],
                       @"publisher_id":[notificationDictionary objectForKey:@"publisher_id"]
                       };
        
    }

    [[APIController api] postNotifications:parameters success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprVC . sendNotifications . success = %@", responseDictionary);
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprVC . sendNotifications . error = %@", error);
        
    }];

}
- (void) checkForNotifications {

    // __weak PaprVC *weakSelf = self;
    
    [[APIController api] getNotifications:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprVC . getNotifications . responseDictionary = %@", responseDictionary);
        
        [[DataController dc] updatecurrentNotificationCount:[responseDictionary objectForKey:@"notifications"] ];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprCellHeader.updateNotificationButton" object:nil];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprNotificationVC . getNotificationsWithDictionary . error = %@", error);
        
    }];

}
- (void) removeWelcomeFakie {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprWelcomeFakie" object:nil];

}

#pragma mark - SCROLLVIEW METHODS

- (void) setupScrollViewPapr {

    if (self.scrollViewPapr) {
        [self.scrollViewPapr removeFromSuperview];
        self.scrollViewPapr = nil;
    }
    
    // SCROLLVIEW . INIT + PARAMETERS
    self.scrollViewPapr = [[UIScrollView alloc] initWithFrame:[DataController dc].frameFullScreen];
    self.scrollViewPapr.delegate = self;
    self.scrollViewPapr.scrollEnabled = FALSE;
    self.scrollViewPapr.backgroundColor = [UIColor clearColor];
    self.scrollViewPapr.canCancelContentTouches = YES;
    self.scrollViewPapr.delaysContentTouches = YES;
    self.scrollViewPapr.clipsToBounds = YES;
    self.scrollViewPapr.pagingEnabled = YES;
    self.scrollViewPapr.showsVerticalScrollIndicator = NO;
    self.scrollViewPapr.showsHorizontalScrollIndicator = NO;
    self.scrollViewPapr.bounces = NO;
    [self.view addSubview:self.scrollViewPapr];

    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // SCROLLVIEW . ADD WELCOME
    self.paprWelcomeVC = [[PaprWelcomeVC alloc] init];
    self.paprWelcomeVC.stringHeader = @"Welcome";
    self.paprWelcomeVC.view.frame = [DataController dc].frameFullScreen;
    [self.scrollViewPapr addSubview:self.paprWelcomeVC.view];
    
}
- (void) addPaprsToScrollview {

    int tagCounter = 1;
    
    [DataController dc].currentPaprCount = (int)self.arrayOfSubscriptions.count;
    
    // WE STORE THE PAPRITEMS IN THIS <STRONG> ARRAY SO THEY DON'T GET DEALLOCATED 
    self.arrayOfPaprs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *paprDictionary in self.arrayOfSubscriptions) {

        // SCROLLVIEW . ADD paprVC
        PaprItemVC *paprItemVC = [[PaprItemVC alloc] init];
        paprItemVC.paprTag = tagCounter;
        paprItemVC.paprDictionary = [[NSDictionary alloc] initWithDictionary:paprDictionary];
        paprItemVC.view.frame = [DataController dc].frameFullScreen;

        [self.scrollViewPapr addSubview:paprItemVC.view];
        
        [self.arrayOfPaprs addObject:paprItemVC];
        
        tagCounter++;

    }

    // SCROLLVIEW . ADD ACCOMPLISHMENT
    self.paprAccomplishmentVC = [[PaprAccomplishmentVC alloc] init];
    self.paprAccomplishmentVC.view.frame = [DataController dc].frameFullScreen;
    [self.scrollViewPapr addSubview:self.paprAccomplishmentVC.view];
    
    // SETUP VIEWS FOR HORIZONTAL PAGING
    [self layoutViewsInScrollViewPapr];
    
}
- (void) layoutViewsInScrollViewPapr {
    
    CGFloat curXLoc = 0;
    
    for (UIView *paprItem in [self.scrollViewPapr subviews]) {
        
        if ([paprItem isKindOfClass:[UIImageView class]]) {
            // DO NADA, THESE ARE SCROLLVIEW SCROLLBAR INDICATORS
        } else if ([paprItem isKindOfClass:[UIView class]]) {

            CGRect frame = paprItem.frame;
            frame.origin = CGPointMake(curXLoc, 20);
            paprItem.frame = frame;
            
            curXLoc += screenWidth;

        }
        
    }

    totalViews = (int)self.arrayOfSubscriptions.count + 1; // + WELCOME SCREEN
    
    [self.scrollViewPapr setContentSize:CGSizeMake( totalViews * screenWidth, [DataController dc].frameFullScreen.size.height - 20)];
    
}
- (void) setupLocalVariables {
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
}
- (void) enableScrolling {

    self.scrollViewPapr.scrollEnabled = TRUE;
    
}
- (void) disableScrolling {
    
    self.scrollViewPapr.scrollEnabled = FALSE;
    
}
- (void) updatePaprSubscriptionsWithNewPapr : (NSNotification *)notification {
    
    [DataController dc].currentPaprWasEdited = TRUE;
    
    NSDictionary *newPapr = [[NSDictionary alloc] initWithDictionary: [notification.userInfo objectForKey:@"newPapr"] ];
    int newIndex = [[notification.userInfo objectForKey:@"newIndex"] intValue];
    int newIndexAdjustment = 0;

    NSMutableArray *arrayOfSubscriptionsUPDATED = [[NSMutableArray alloc] init];
    
    for (NSDictionary *thisPapr in self.arrayOfSubscriptions) {
    
        NSString *publisherID = [thisPapr objectForKey:@"PUBLISHER_ID"];
        
        if ( [publisherID isEqualToString:[[DataController dc] returnMyUserID]] ) {
            newIndexAdjustment = 1;
        } else {
            [arrayOfSubscriptionsUPDATED addObject:thisPapr];
        }
        
    }
    
    if (newIndex > 0) {
        newIndex = newIndex - newIndexAdjustment;
    }
    
    [arrayOfSubscriptionsUPDATED insertObject:newPapr atIndex:newIndex];

    self.arrayOfSubscriptions = [[NSArray alloc] initWithArray:arrayOfSubscriptionsUPDATED];
    
    [self setupScrollViewPapr];
    
    [self addPaprsToScrollview];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprProgressVC.setupProgressBrackets" object:nil];

    [self scrollToIndex : newIndex];
    
}
- (void) updateSubscriptionCountForWelcomePage {

    [self.paprWelcomeVC updateSubscriptionCount : (int)self.arrayOfSubscriptions.count];

}
- (void) scrollToFirstPapr {

    if (self.arrayOfSubscriptions.count > 0) {
        
        [self scrollToFirstPaprActual];

    } else {
    
        if (scrollAttempts < 3) {
            
            scrollAttempts++;
            
            [self performSelector:@selector(scrollToFirstPapr) withObject:nil afterDelay:2.5];
            
        }
        

    }
}
- (void) scrollToFirstPaprActual {

    if ([DataController dc].currentPaprWasEdited) {
        
        // CHILL, WE OFFSET THE PAPRs SOMEWHERE ELSE
        // RESET FOR NEXT TIME:
        [DataController dc].currentPaprWasEdited = FALSE;
        
    } else {
        
        [self.scrollViewPapr setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
        
    }

    ////////
    // [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"iHaveShownSwipeAlertForPapr"];
    // [[NSUserDefaults standardUserDefaults] synchronize];
    ////////
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"iHaveShownSwipeAlertForPapr"] ) {
        // CHILL
    } else {
        
        [self performSelector:@selector(swipeAlert) withObject:nil afterDelay:0.5];

        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"iHaveShownSwipeAlertForPapr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

}
- (void) scrollToLastPapr {

    NSLog(@"scrollToLastPapr . [DataController dc].currentPaprCount = %i", [DataController dc].currentPaprCount);

    int offsetX = screenWidth * ([DataController dc].currentPaprCount + 1);
    
    [self.scrollViewPapr setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
}
- (void) scrollToCurrentPapr {

    NSLog(@"scrollToLastPapr . [DataController dc].currentPaprCount = %i", [DataController dc].currentPaprIndex);
    
    int offsetX;
    
    if ([DataController dc].currentPaprIndex > [DataController dc].currentPaprCount) {

        offsetX = screenWidth * ([DataController dc].currentPaprCount - 1);

    } else {
    
        offsetX = screenWidth * ([DataController dc].currentPaprIndex);
        
    }

    [self.scrollViewPapr setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}
- (void) scrollToLeft {

    int currentPageNumber = [self returnPageNumber];
    
    if (currentPageNumber < totalViews) {
        
        int offsetWidth = (currentPageNumber + 1) * screenWidth;
        
        [self.scrollViewPapr setContentOffset:CGPointMake(offsetWidth, 0) animated:YES];
        
    }
    
    if (currentPageNumber == (totalViews - 1) ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprAccomplishmentVC.animatePushIN" object:nil];
        
    }


}
- (void) scrollToRight {

    int currentPageNumber = [self returnPageNumber];
    
    if (currentPageNumber > 0) {
        
        int offsetWidth = (currentPageNumber - 1) * screenWidth;
        
        [self.scrollViewPapr setContentOffset:CGPointMake(offsetWidth, 0) animated:YES];
        
    }
    
}
- (void) scrollToIndex : (int)indexRCVD {
    
    int offsetWidth = (indexRCVD+1) * screenWidth;
    
    [self.scrollViewPapr setContentOffset:CGPointMake(offsetWidth, 0) animated:NO];
    
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    scrollViewIsMoving = FALSE;
    
    [DataController dc].currentPaprIndex = [self returnPageNumber];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprProgressVC.updateProgressBar" object:nil];
    
}
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    scrollViewIsMoving = FALSE;

    [DataController dc].currentPaprIndex = [self returnPageNumber];

    // HERE
    if ([DataController dc].currentPaprIndex == 2) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iHaveShownTheBumpHint"]) {
            // CHILL
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprItemVC.showTheBumpHintUp" object:nil];
            
            // GGXGG . SET THIS TO TRUE!
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"iHaveShownTheBumpHint"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprProgressVC.updateProgressBar" object:nil];

}
- (int) returnPageNumber {
    
    int thisPageNumber = round(self.scrollViewPapr.contentOffset.x / screenWidth);
    
    return thisPageNumber;
    
}
- (void) swipeAlert {
    
    NSDictionary *alertDictionary = @{@"alert_type":@"swipe_papr"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprAlertVC" object:nil userInfo:alertDictionary];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
