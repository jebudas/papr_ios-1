//
//  RootVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/3/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "RootVC.h"
// FACEBOOK
// #import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupNotifications];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [self evaluateLoginStatus];

}
- (void) evaluateLoginStatus {

    if (self.paprBaseVC) {
        
        // CHILL
        
    } else if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserDictionary"]) {

        [self setupPaprBaseVC];

    } else {
        
        [self setupPaprBaseVC];
        
        [self pushLoginVC];
        
    }

}
- (void) setupPaprBaseVC {

    if (iAmLaunching) {return;}
    
    iAmLaunching = TRUE;

    self.paprBaseVC = [[PaprBaseVC alloc] init];
    self.nc = [[UINavigationController alloc] initWithRootViewController:self.paprBaseVC];
    self.nc.navigationBar.hidden = YES;
    [self.view addSubview:self.nc.view];

    [self.view bringSubviewToFront:self.viewLaunch];

}
- (void) setupNotifications {
    
    // COMMENT
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprCommentVC:) name:@"RootVC.addPaprCommentVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprCommentVC) name:@"RootVC.removePaprCommentVC" object:nil];
    // FULL SCREEN MESSAGES & SPINNERS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFullScreenMessage:) name:@"RootVC.showFullScreenMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFullScreenMessage) name:@"RootVC.hideFullScreenMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFullScreenSpinner) name:@"RootVC.showFullScreenSpinner" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFullScreenSpinner) name:@"RootVC.hideFullScreenSpinner" object:nil];
    // LOADING
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewLaunch) name:@"RootVC.popViewLaunch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewLaunchHide) name:@"RootVC.viewLaunchHide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewLaunchShow) name:@"RootVC.viewLaunchShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLabelLoading) name:@"RootVC.showLabelLoading" object:nil];
    // LOCATION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUserLocation) name:@"RootVC.setupUserLocation" object:nil];
    // MORE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprMoreVC) name:@"RootVC.addPaprMoreVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprMoreVC) name:@"RootVC.removePaprMoreVC" object:nil];
    // NAVIGATION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRoot) name:@"RootVC.popToRoot" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootFromProfile) name:@"RootVC.popToRootFromProfile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootAnimated) name:@"RootVC.popToRootAnimated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootAfterLogin) name:@"RootVC.popToRootAfterLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootAfterSubscriptionUpdate) name:@"RootVC.popToRootAfterSubscriptionUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprAlertVC:) name:@"RootVC.pushPaprAlertVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popPaprAlertVC) name:@"RootVC.popPaprAlertVC" object:nil];
    // POST
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprPostCreateVC:) name:@"RootVC.pushPaprPostCreateVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprPostPreviewVC) name:@"RootVC.pushPaprPostPreviewVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popPaprPostPreviewVC) name:@"RootVC.popPaprPostPreviewVC" object:nil];
    // PROFILE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfileVC) name:@"RootVC.addPaprProfileVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfileForUser) name:@"RootVC.addPaprProfileForUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprProfileVC) name:@"RootVC.removePaprProfileVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfileEditVC) name:@"RootVC.addPaprProfileEditVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprProfileEditVC) name:@"RootVC.removePaprProfileEditVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfilePreVC:) name:@"RootVC.addPaprProfilePreVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprProfilePreVC) name:@"RootVC.removePaprProfilePreVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfileSettingsVC) name:@"RootVC.addPaprProfileSettingsVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprProfileSettingsVC) name:@"RootVC.removePaprProfileSettingsVC" object:nil];
    // RANDO
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transitionFromLoginToPapr) name:@"RootVC.transitionFromLoginToPapr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePaprTabBar) name:@"RootVC.hidePaprTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockPaprTabBar) name:@"RootVC.lockPaprTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPaprTabBar) name:@"RootVC.showPaprTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePaprProgress) name:@"RootVC.hidePaprProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPaprProgress) name:@"RootVC.showPaprProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprWelcomeFakie) name:@"RootVC.removePaprWelcomeFakie" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sharePaperArticle:) name:@"RootVC.sharePaperArticle" object:nil];
    // SAVED POSTS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprSavedPostsVC) name:@"RootVC.addPaprSavedPostsVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprSavedPostsVC) name:@"RootVC.removePaprSavedPostsVC" object:nil];
    // SEARCH
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprSearchVC) name:@"RootVC.pushPaprSearchVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popPaprSearchVC) name:@"RootVC.popPaprSearchVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPaprSubscriptions) name:@"RootVC.refreshPaprSubscriptions" object:nil];
    // USER
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprUserNotificationsVC:) name:@"RootVC.addPaprUserNotificationsVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprUserNotificationsVC) name:@"RootVC.removePaprUserNotificationsVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfileFollowingVC) name:@"RootVC.addPaprProfileFollowingVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprProfileFollowersVC) name:@"RootVC.addPaprProfileFollowersVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprProfileFollowingVC) name:@"RootVC.removePaprProfileFollowingVC" object:nil];
    // WWW
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaprWWW:) name:@"RootVC.addPaprWWW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePaprWWW) name:@"RootVC.removePaprWWW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSafariBrowser:) name:@"RootVC.pushSafariBrowser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSafariBrowserWithShorty:) name:@"RootVC.pushSafariBrowserWithShorty" object:nil];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showFullScreenSpinner" object:nil];

}
- (void) refreshPaprSubscriptions {

    [self setupPaprBaseVC];
    
}
- (void) viewLaunchHide {

    [self popViewLaunchActual : 0.0];
    
}
- (void) viewLaunchShow {
    
    self.imageViewLaunch.alpha = 1.0;

    self.labelUpdated.text = @"";
    self.labelUpdated.alpha = 0.0;
    
    self.viewLaunch.alpha = 1.0;
    
}

#pragma mark - LOCATION METHODS

- (void) setupUserLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.headingFilter = kCLHeadingFilterNone;
    
    [self.locationManager startUpdatingLocation];
    
    // NOW THAT LOCATION IS READY, LET'S SHOW USER'S LOCATION
    
}
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    [self.locationManager stopUpdatingLocation];
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [[DataController dc] returnMyUserDictionary] ];

    if ([userDictionary objectForKey:@"user_location"]) {
        // SKIP
        NSLog(@"MyUserDictionary[SKIP] = %@", userDictionary);
    } else {
        
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];

            NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            placemark.ISOcountryCode, @"ISOcountryCode",
                                            placemark.country, @"country",
                                            placemark.postalCode, @"postalCode",
                                            placemark.administrativeArea, @"administrativeArea",
                                            placemark.subAdministrativeArea, @"subAdministrativeArea",
                                            placemark.locality, @"locality",
                                            placemark.subLocality, @"subLocality",
                                            nil];
            
            [[DataController dc] updateUserDictionaryWithNewLocation:userDictionary];

//            NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
//            NSLog(@"placemark.country %@",placemark.country);
//            NSLog(@"placemark.postalCode %@",placemark.postalCode);
//            NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
//            NSLog(@"placemark.subAdministrativeArea %@",placemark.subAdministrativeArea);
//            NSLog(@"placemark.locality %@",placemark.locality);
//            NSLog(@"placemark.subLocality %@",placemark.subLocality);
//            NSLog(@"placemark.region %@",placemark.region);
//            NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
//            NSLog(@"placemark.timeZone %@",placemark.timeZone);
        }];
        
    }

}

#pragma mark - PUSH/POP, NOTIFICATION, MIXPANEL METHODS

- (void) popToRoot {

    [DataController dc].currentZone = @"papr";

    if ([DataController dc].currentPaprIndex > [DataController dc].currentPaprCount) {
    
        [self.nc popToRootViewControllerAnimated:NO];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToLastPapr" object:nil];

    } else {
    
        [self.nc popToRootViewControllerAnimated:NO];
    
    }

}
- (void) popToRootFromProfile {

    NSString *zone = [DataController dc].currentZone;
    
    if ([zone isEqualToString:@"papr"]) {

        [self removePaprProfilePreVC];
        [self removePaprProfileVC];
    
    } else {
    
        [self removePaprProfileVC];

    }

}
- (void) popToRootAnimated {
    
    [self.nc popToRootViewControllerAnimated:YES];
    
}
- (void) popToRootAfterLogin {

    [self.nc popToRootViewControllerAnimated:NO];
    
    [self viewLaunchShow];

    [self refreshPaprSubscriptions];

    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"iNeedToSendMyLoginSubscriptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self registerAndIdentifyUserWithMixpanel];

    // DEPRECATED v1.4
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.getPaprSubscriptions" object:nil];
    
}
- (void) popToRootAfterSubscriptionUpdate {
    
    [self viewLaunchShow];
    
    [self.nc popToRootViewControllerAnimated:NO];
    
    [self refreshPaprSubscriptions];
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"iNeedToSendMyLoginSubscriptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self registerAndIdentifyUserWithMixpanel];
    
    // DEPRECATED v1.4
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.getPaprSubscriptions" object:nil];
    
}
- (void) registerAndIdentifyUserWithMixpanel {

    NSLog(@"");
    
    NSDictionary *userDictionary = [[NSDictionary alloc] initWithDictionary: [[DataController dc] returnMyUserDictionary] ];

    [[Mixpanel sharedInstance] registerSuperProperties:@{@"username": [userDictionary objectForKey:@"user_username"],
                                                         @"fb_user_id": [userDictionary objectForKey:@"fb_user_id"],
                                                         @"fb_phone_number": [userDictionary objectForKey:@"fb_phone_number"],
                                                         @"user_settings_push" : @"0"}];
    
    [[Mixpanel sharedInstance] createAlias:[userDictionary objectForKey:@"fb_user_id"] forDistinctID:[Mixpanel sharedInstance].distinctId];
    
    [[Mixpanel sharedInstance] identify:[Mixpanel sharedInstance].distinctId];
    
    [[Mixpanel sharedInstance] track: @"Login" properties: @{@"Status": @"Completed"}];
    
    
}
- (void) pushLoginVC {
    
    [self popViewLaunchActual : 0.0];
    
    self.loginVC = [[LoginVC alloc] init];
    [self.nc pushViewController:self.loginVC animated:NO];
    
}
- (void) popLoginVC {
    
    [self.nc popToRootViewControllerAnimated:NO];
    self.loginVC = nil;
    
}
- (void) popViewLaunch {
    

    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"h:mm a"];

    self.labelUpdated.alpha = 1.0;
    self.labelUpdated.text = [NSString stringWithFormat:@"Updated %@", [formatter stringFromDate:now] ];

    [self performSelector:@selector(popViewLaunchActual:) withObject:nil afterDelay:2.0];
    
}
- (void) popViewLaunchActual : (float)delayRCVD {

    if (delayRCVD > 0) {
        // HEY NOW
    } else {
        delayRCVD = 0.1;
    }
    
    [UIView animateWithDuration: 0.5
                          delay: delayRCVD
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{

                         self.labelUpdated.alpha = 0.0;
                         self.viewLaunch.alpha = 0.0;

//                         self.imageViewLaunch.frame = CGRectMake(0,
//                                                            0 - [[DataController dc] returnRelativeSizeForThisScreen:288],
//                                                            self.imageViewLaunch.frame.size.width,
//                                                            self.imageViewLaunch.frame.size.height);
                     } completion: ^(BOOL finished){
                         //[self popViewLaunchFinal];
                         iAmLaunching = FALSE;
                     }
     ];

}
- (void) popViewLaunchFinal_DEPRECATED {
    
    [UIView animateWithDuration: 1.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         self.viewLaunch.alpha = 0.0;
                     } completion: ^(BOOL finished){
                         // POP
                         iAmLaunching = FALSE;
                         self.imageViewLaunch.frame = CGRectMake(0,0,self.imageViewLaunch.frame.size.width,self.imageViewLaunch.frame.size.height);
                     }
     ];
    
}
- (void) showLabelLoading {
    
    [UIView animateWithDuration: 0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         self.labelLoading.alpha = 1.0;
                     } completion: ^(BOOL finished){
                         // HEY THERE.
                     }
     ];

}

// ALERT
- (void) pushPaprAlertVC : (NSNotification *)notification {

    if ([DataController dc].iAmShowingAlert) {
        return;
    } else {
        [DataController dc].iAmShowingAlert = TRUE;
    }
    
    NSString *alertType = [notification.userInfo objectForKey:@"alert_type"];
    
    self.paprAlertVC = [[PaprAlertVC alloc] init];
    self.paprAlertVC.currentView = alertType;
    [self.view addSubview:self.paprAlertVC.view];
    
    
    
}
- (void) popPaprAlertVC {

    [self.paprAlertVC.view removeFromSuperview];
    self.paprAlertVC = nil;

    [DataController dc].iAmShowingAlert = FALSE;

}
// COMMENT
- (void) addPaprCommentVC : (NSNotification *)notification {
    
//    NSDictionary *commentDictionary = [[NSDictionary alloc] initWithDictionary: [notification.userInfo objectForKey:@"commentDictionary"] ];
//
    self.paprCommentVC = [[PaprCommentVC alloc] init];
    self.paprCommentVC.commentDictionary = notification.userInfo;
    [self.view addSubview:self.paprCommentVC.view];
    
}
- (void) removePaprCommentVC {
    
    [self.paprCommentVC.view removeFromSuperview];
    self.paprCommentVC = nil;
    
}
// USER
- (void) addPaprProfileFollowingVC {
    
    self.paprProfileFollowingVC = [[PaprProfileFollowingVC alloc] init];
    self.paprProfileFollowingVC.thisIsFollowing = TRUE;
    [self.view addSubview:self.paprProfileFollowingVC.view];
    
}
- (void) addPaprProfileFollowersVC {
    
    self.paprProfileFollowingVC = [[PaprProfileFollowingVC alloc] init];
    self.paprProfileFollowingVC.thisIsFollowing = FALSE;
    [self.view addSubview:self.paprProfileFollowingVC.view];
    
}
- (void) removePaprProfileFollowingVC {
    
    [self.paprProfileFollowingVC.view removeFromSuperview];
    self.paprProfileFollowingVC = nil;
    
}
- (void) addPaprUserNotificationsVC : (NSNotification *)notification {

    NSString *url = [notification.userInfo objectForKey:@"url"];

    self.paprUserNotificationsVC = [[PaprUserNotificationsVC alloc] init];
    [self.view addSubview:self.paprUserNotificationsVC.view];
    
}
- (void) removePaprUserNotificationsVC {

    [self removePaprProfilePreVC];

    [self.paprUserNotificationsVC.view removeFromSuperview];
    self.paprUserNotificationsVC = nil;
    
}
// MORE
- (void) addPaprMoreVC {
    
    self.paprMoreVC = [[PaprMoreVC alloc] init];
    [self.view addSubview:self.paprMoreVC.view];

    
}
- (void) removePaprMoreVC {
    
    [self.paprMoreVC.view removeFromSuperview];
    self.paprMoreVC = nil;

}
// POST
- (void) pushPaprPostCreateVC : (NSNotification *)notification {
    
    self.paprPostCreateVC = [[PaprPostCreateVC alloc] init];
    self.paprPostCreateVC.repostDictionary = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [self.nc pushViewController:self.paprPostCreateVC animated:NO];
    
}
- (void) popPaprPostCreateVC {
    
    [self.nc popToRootViewControllerAnimated:NO];
    self.paprPostCreateVC = nil;
    
}
- (void) pushPaprPostPreviewVC {

    self.paprPostPreviewVC = [[PaprPostPreviewVC alloc] init];
    [self.nc pushViewController:self.paprPostPreviewVC animated:NO];

}
- (void) popPaprPostPreviewVC {

    [self.nc popToRootViewControllerAnimated:NO];
    self.paprPostPreviewVC = nil;

}
// PROFILE
- (void) addPaprProfileVC {
    
    self.paprProfileVC = [[PaprProfileVC alloc] init];
    [self.view addSubview:self.paprProfileVC.view];
    
}
- (void) addPaprProfileForUser {
    
    self.paprProfileVC = [[PaprProfileVC alloc] init];
    self.paprProfileVC.thisIsMe = TRUE;
    [self.view addSubview:self.paprProfileVC.view];
    
}
- (void) removePaprProfileVC {
    
    [self.paprProfileVC.view removeFromSuperview];
    self.paprProfileVC = nil;
    
}
- (void) addPaprProfileEditVC {
    
    self.paprProfileEditVC = [[PaprProfileEditVC alloc] init];
    [self.view addSubview:self.paprProfileEditVC.view];
    
}
- (void) removePaprProfileEditVC {
    
    [self.paprProfileEditVC.view removeFromSuperview];
    self.paprProfileEditVC = nil;
    
}
- (void) addPaprProfilePreVC : (NSNotification *)notification {
    
    NSDictionary *thisDictionary = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [DataController dc].currentPaprDictionary = thisDictionary;

    self.paprProfilePreVC = [[PaprProfilePreVC alloc] init];
    [self.view addSubview:self.paprProfilePreVC.view];

}
- (void) removePaprProfilePreVC {
    
    [DataController dc].currentPaprDictionary = nil;
    
    if (self.paprProfilePreVC) {
        [self.paprProfilePreVC.view removeFromSuperview];
        self.paprProfilePreVC = nil;
    }
    
    
}
// SAVED POSTS
- (void) addPaprSavedPostsVC {
    
    self.paprSavedPostsVC = [[PaprSavedPostsVC alloc] init];
    [self.view addSubview:self.paprSavedPostsVC.view];
    
}
- (void) removePaprSavedPostsVC {

    [self removePaprProfilePreVC];

    [self.paprSavedPostsVC.view removeFromSuperview];
    self.paprSavedPostsVC = nil;
    
}
// SEARCH
- (void) pushPaprSearchVC {

    self.paprSearchVC = [[PaprSearchVC alloc] init];
    [self.nc pushViewController:self.paprSearchVC animated:NO];

}
- (void) popPaprSearchVC {
    
    [self.nc popToRootViewControllerAnimated:NO];
    self.paprSearchVC = nil;

}
// SHARE
- (void) sharePaperArticle : (NSNotification *)notification {
    
    NSDictionary *shareDictionary = [[NSDictionary alloc] initWithDictionary: notification.userInfo ];

    NSString *text = [NSString stringWithFormat:@"%@", [shareDictionary objectForKey:@"share_text"]];
    NSString *url = [shareDictionary objectForKey:@"share_url"];

    NSArray *activityItems = @[url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToWeibo];
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

// SHOW FULL SCREEN MESSAGE

- (void) showFullScreenMessage : (NSNotification *)notification {
    
    NSString *message = [notification.userInfo objectForKey:@"url"];

    self.viewFullScreenMessage.alpha = 1.0;
    self.labelFullScreenMessage.text = message;
    [self.view bringSubviewToFront:self.viewFullScreenMessage];
    
}
- (void) hideFullScreenMessage {
    
    self.viewFullScreenMessage.alpha = 0.0;

}
- (void) showFullScreenSpinner {
    
    self.viewSpinner.alpha = 1.0;
    [self.view bringSubviewToFront:self.viewSpinner];

}
- (void) hideFullScreenSpinner {
    
    self.viewSpinner.alpha = 0.0;
    
}


// WWW
- (void) addPaprWWW : (NSNotification *)notification {
    
    NSString *url = [notification.userInfo objectForKey:@"url"];
    
    self.paprWWW = [[PaprWWW alloc] init];
    self.paprWWW.thisURL = url;
    [self.view addSubview:self.paprWWW.view];
    
}
- (void) removePaprWWW {
    
    [self.paprWWW.view removeFromSuperview];
    self.paprWWW = nil;
    
}
- (void) pushSafariBrowser : (NSNotification *)notification {
    
    NSString *urlString = [notification.userInfo objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
    [self showViewController:safariVC sender:nil];

}
- (void) pushSafariBrowserWithShorty : (NSNotification *)notification {

    NSString *shortyPath = [notification.userInfo objectForKey:@"url"];
    NSString *shortyString = [shortyPath substringFromIndex:MAX((int)[shortyPath length] - 12, 0)];
    NSString *encoded = [shortyString substringToIndex:4];
    NSString *decoded = @"p700";
    decoded = [decoded stringByAppendingString: [[DataController dc] decodeTopSecretPublisherCharacter: [NSString stringWithFormat:@"%C", [encoded characterAtIndex:3]]]];
    decoded = [decoded stringByAppendingString: [[DataController dc] decodeTopSecretPublisherCharacter: [NSString stringWithFormat:@"%C", [encoded characterAtIndex:2]]]];
    decoded = [decoded stringByAppendingString: [[DataController dc] decodeTopSecretPublisherCharacter: [NSString stringWithFormat:@"%C", [encoded characterAtIndex:1]]]];
    decoded = [decoded stringByAppendingString: [[DataController dc] decodeTopSecretPublisherCharacter: [NSString stringWithFormat:@"%C", [encoded characterAtIndex:0]]]];

    NSDictionary *urlDictionary = @{@"url_shorty": shortyString,
                                    @"publisher_id": decoded};

    [[APIController api] getShareURL:urlDictionary success:^(NSDictionary *responseDictionary) {
        
        NSDictionary *shortyDictionary = [[NSDictionary alloc] initWithDictionary: [responseDictionary objectForKey:@"shorty_dictionary"] ];
        
        NSURL *url = [NSURL URLWithString: [shortyDictionary objectForKey:@"URL_ACTUAL"] ];

        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
        [self showViewController:safariVC sender:nil];

    } failure:^(NSError *error) {
        
        NSLog(@"pushSafariBrowserWithShorty . getShareURL . failure . error = %@", error);
        
    }];

}
// SETTINGS
- (void) addPaprProfileSettingsVC {
    
    self.paprProfileSettingsVC = [[PaprProfileSettingsVC alloc] init];
    [self.view addSubview:self.paprProfileSettingsVC.view];
    
}
- (void) removePaprProfileSettingsVC {
    
    [self.paprProfileSettingsVC.view removeFromSuperview];
    self.paprProfileSettingsVC = nil;
    
}

- (void) transitionFromLoginToPapr {

    // PREPARE PAPR

    // POP LOGIN
    [self popLoginVC];

}

#pragma mark - TAB BAR, PROGRESS BAR, WELCOME METHODS

- (void) setupPaprTabBar {
    
    // ADD PaprMenuVC
    self.paprTabBarVC = [[PaprTabBarVC alloc] init];
    self.paprTabBarVC.view.frame = [self returnTabBarFrame];
    self.paprTabBarVC.view.alpha = 0.0;
    [self.view addSubview:self.paprTabBarVC.view];
    
}
- (void) hidePaprTabBar {
    
    self.paprTabBarVC.view.alpha = 0.0;
    
}
- (void) lockPaprTabBar {
    
    self.paprTabBarVC.view.alpha = 0.25;
    self.paprTabBarVC.view.userInteractionEnabled = FALSE;
}
- (void) showPaprTabBar {
    
    self.paprTabBarVC.view.alpha = 1.0;
    self.paprTabBarVC.view.userInteractionEnabled = TRUE;

    [self.view bringSubviewToFront:self.paprTabBarVC.view];

}
- (CGRect) returnTabBarFrame {
    
    // PAPR TAB BAR DIMENSIONS BASED ON PaprTabBar.xib RATIO = 375x60
    // 375 / 60 = 6.25
    // 375 / 6.25 = HEIGHT
    
    float tabSizeWidth = [DataController dc].frameFullScreen.size.width;
    float tabSizeHeight = tabSizeWidth / 6.25;
    float tabOriginX = 0;
    float tabOriginY = [DataController dc].frameFullScreen.size.height - tabSizeHeight;
    CGRect tabBarFrame = CGRectMake(tabOriginX, tabOriginY, tabSizeWidth, tabSizeHeight);
    
    return tabBarFrame;
    
}

- (void) setupPaprProgress {
    
    // ADD PaprMenuVC
    self.paprProgressVC = [[PaprProgressVC alloc] init];
    self.paprProgressVC.view.frame = [self returnProgressFrame];
    self.paprProgressVC.view.alpha = 0.0;
    [self.view addSubview:self.paprProgressVC.view];
    
}
- (void) hidePaprProgress {
    
    self.paprProgressVC.view.alpha = 0.0;
    
}
- (void) showPaprProgress {
    
    self.paprProgressVC.view.alpha = 1.0;
    
    [self.view bringSubviewToFront:self.paprProgressVC.view];
    
}
- (CGRect) returnProgressFrame {
    
    // PAPR TAB BAR DIMENSIONS BASED ON PaprProgress.xib RATIO = 375x23
    // 375 / 23 = 16.3
    // 375 / 16.3 = HEIGHT
    
    float progressSizeWidth = [DataController dc].frameFullScreen.size.width;
    float progressSizeHeight = progressSizeWidth / 16.3;
    float progressOriginX = 0;
    float progressOriginY = 0;
    CGRect progressBarFrame = CGRectMake(progressOriginX, progressOriginY, progressSizeWidth, progressSizeHeight);
    
    return progressBarFrame;
    
}

- (void) setupPaprWelcomeFakie {

    // FIRST . ADD WELCOME FAKIE
    int offsetY = [[DataController dc] returnRelativeSizeForThisScreen:20];
    self.paprWelcomeFakieVC = [[PaprWelcomeFakieVC alloc] init];
    self.paprWelcomeFakieVC.view.frame = [DataController dc].frameFullScreen;
    [self.view addSubview:self.paprWelcomeFakieVC.view];

}
- (void) removePaprWelcomeFakie {

    [self.paprWelcomeFakieVC.view removeFromSuperview];
    self.paprWelcomeFakieVC = nil;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
