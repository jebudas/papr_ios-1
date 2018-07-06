//
//  AppDelegate.m
//  papr
//
//  Created by Brian WF Tobin on 8/3/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "AppDelegate.h"
// API
#import "APIController+Paprboy.h"
// HOCKEY APP
#import <HockeySDK/HockeySDK.h>
// FACEBOOK
#import <FBSDKCoreKit/FBSDKCoreKit.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor cyanColor];
    [self.window makeKeyAndVisible];
    
    self.rootVC = [[RootVC alloc] init];
    
    self.window.rootViewController = self.rootVC;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // START THE SINGLETON PARTY
    [DataController dc].frameFullScreen = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);

    // AWS
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc]
                                                         initWithAccessKey:@"AKIAJ2GMKZ6GCP444Y7Q" secretKey:@"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"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;

    // MIXPANEL
    // CONSIDER TURNING THIS OFF DURING DEVELOPMENT
    [Mixpanel sharedInstanceWithToken:@"dfebd8d52c4acf60c846029cca1f334c"];

    // HOCKEY APP
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"329d512aca054a3b86b1e78569dbb251"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    return YES;

}
- (void)applicationWillResignActive:(UIApplication *)application {

    [[Mixpanel sharedInstance] track:@"User Session . Duration"];

    [self updateUserSubscriptions];

    [self sendStats];
    
    NSDate *dateAppWillResignActive = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:dateAppWillResignActive forKey:@"dateAppWillResignActive"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.viewLaunchShow" object:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

    [FBSDKAppEvents activateApp];

    [[Mixpanel sharedInstance] timeEvent:@"User Session . Opened App"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserDictionary"]) {

        NSDate *dateNow = [NSDate date];
        NSDate *dateAppWillResignActive = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateAppWillResignActive"];
        NSDate *dateRefreshAfter = [dateAppWillResignActive dateByAddingTimeInterval: 610.0];

        if ([dateNow compare: dateRefreshAfter] == NSOrderedDescending) {
            
            // UPDATE ARRAY OF PAPRS
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.refreshPaprSubscriptions" object:nil];
            
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.viewLaunchHide" object:nil];

        }

    } else {
        
        // LOGIN?
        
    }

}
- (void)applicationWillTerminate:(UIApplication *)application {
    //
}

#pragma mark - Push Notifications

- (void) configurePushNotificationsForApplication:(UIApplication *)application withLaunchOptions:(NSDictionary *)launchOptions {
    
    // mixpanel notifications
    // Tell iOS you want  your app to receive push notifications
    [Mixpanel sharedInstanceWithToken:@"dfebd8d52c4acf60c846029cca1f334c" launchOptions:launchOptions];
    
}
- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"pushRequestShown"] ) {
        
        // RELAX
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.refreshSplitFeed" object:nil];
        
        // MARK THIS AS DONE ;)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"pushRequestShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenSPACED = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *deviceTokenUNSPACED = [deviceTokenSPACED stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"(prizeTest) deviceTokenUNSPACED = %@", deviceTokenUNSPACED);
    
    if (deviceToken) {
        
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel identify:mixpanel.distinctId];
        [mixpanel.people addPushDeviceToken:deviceToken];
        
    }
    
}
- (void) application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
    // TODO GGXGG . USER SHOULD BE ABLE TO ADVANCE ON FAILURE
    
}

#pragma mark - Universal Links

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {

    NSURL *url = userActivity.webpageURL;

    // SNTAH
    if ([url host].length < 7) {
        return FALSE;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushSafariBrowserWithShorty" object:nil userInfo:@{@"url" : [url path]}];
    
    [[Mixpanel sharedInstance] track:@"Papr . Share Interaction" properties: @{@"Action": @"Viewed Link Via Share"}];

    return TRUE;

}

#pragma mark - API Methods

- (void) sendStats {

#warning GGXGG
    return;

    NSString *path = [NSString stringWithFormat:@"%@/api/%@/statistics/chunky/?format=json", PAPR_API_BASE_URL, PAPR_API_VERSION];
    
    NSDictionary *statsDictionary = [[APIController api] returnVoteDictionary];
    
    [[APIController api] postStats:statsDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"AppDelegate . sendStats . success = %@", responseDictionary);
        
    } failure:^(NSError *error) {
        
        NSLog(@"AppDelegate . sendStats . error = %@", error);
        
    }];

}
- (void) updateUserSubscriptions {

    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"iNeedToSendMyLoginSubscriptions"] ) {
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"iNeedToSendMyLoginSubscriptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSArray *userSubscriptions = [[DataController dc] returnUserSubscriptions];
        
        for (NSString *thisPublisherID in userSubscriptions) {
        
            NSDictionary *followDictionary = @{@"i_should_follow" : @"1",
                                               @"publisher_id" : thisPublisherID,
                                               @"subscriber_id" : [[DataController dc] returnMyUserID]};
            
            [[APIController api] updateMyFollowStatusForPublisher:followDictionary success:^(NSDictionary *responseDictionary) {
                
                NSLog(@"AppDelegate . updateMyFollowStatusForPublisher . success = %@", responseDictionary);
                
            } failure:^(NSError *error) {
                
                NSLog(@"AppDelegate . updateMyFollowStatusForPublisher . error = %@", error);
                
            }];

        }

    }
    
    if ([DataController dc].iUpdatedMySubscriberList) {
    
        NSArray *userSubscriptions = [[DataController dc] returnUserSubscriptions];
        
        [[APIController api] updateUserSubscriptions:userSubscriptions success:^(NSDictionary *responseDictionary) {
            
            if ([[responseDictionary objectForKey:@"success"] intValue]) {
                
                NSLog(@"AppDelegate . updateUserSubscriptions . success . responseDictionary = %@", responseDictionary);
                
                [DataController dc].iUpdatedMySubscriberList = FALSE;
                
            } else {

                NSLog(@"AppDelegate . updateUserSubscriptions . successZERO . responseDictionary = %@", responseDictionary);

            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"AppDelegate . updateUserSubscriptions . failure . error = %@", error);
            
        }];

        
    }

}

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];

}


@end
