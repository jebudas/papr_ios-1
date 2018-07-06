//
//  AppDelegate.h
//  papr
//
//  Created by Brian WF Tobin on 8/3/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootVC.h"
// AWS
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
// MIXPANEL
#import "Mixpanel/Mixpanel.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootVC *rootVC;


@end

/*
 
 MIXPANEL KIT
 
 #import "Mixpanel/Mixpanel.h" 
 
 [[Mixpanel sharedInstance] identify:@"13793"];
 
 [mixpanel registerSuperProperties:@{@"Plan": @"Mega"}];
 
 [[Mixpanel sharedInstance] track:@"Plan selected" properties:@{ @"Plan": @"Premium" }];
 
 [self uploadImageWithSuccessHandler:^{
    [[Mixpanel sharedInstance] track:@"Image Upload"];
 }];
 
 
 */

/*
 
 BEFORE RELEASE:
 
 Info.plist
 "Allow Arbitrary Loads in Web Content" // Test HTTP vs HTTPS Issue
 
 
 
 */
