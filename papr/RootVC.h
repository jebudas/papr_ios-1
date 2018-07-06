//
//  RootVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/3/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "LoginVC.h"
#import "PaprVC.h" // GGXGG . DEPRECATED
#import "PaprBaseVC.h"
#import "PaprAlertVC.h"
#import "PaprMoreVC.h"
#import "PaprPostCreateVC.h"
#import "PaprPostPreviewVC.h"
#import "PaprProfileVC.h"
#import "PaprProfileEditVC.h"
#import "PaprProfileFollowingVC.h"
#import "PaprProfilePreVC.h"
#import "PaprProfileSettingsVC.h"
#import "PaprSavedPostsVC.h"
#import "PaprSearchVC.h"
#import "PaprProgressVC.h"
#import "PaprTabBarVC.h"
// SECONDARY
#import "PaprWWW.h"
#import "PaprCommentVC.h"
#import "PaprWelcomeFakieVC.h"
#import "PaprUserNotificationsVC.h"
// LOCATION
#import <CoreLocation/CoreLocation.h>
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// SAFARI
@import SafariServices;


@interface RootVC : UIViewController <UINavigationControllerDelegate, CLLocationManagerDelegate> {

    BOOL iAmLaunching;
    
}


@property (strong, nonatomic) UINavigationController *nc;
@property (nonatomic, strong) PaprWelcomeFakieVC *paprWelcomeFakieVC;
@property (nonatomic, weak) IBOutlet UIView *viewLaunch;
@property (nonatomic, weak) IBOutlet UIView *viewSpinner;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewLaunch;

// PAPR
@property (nonatomic, strong) LoginVC *loginVC;
@property (nonatomic, strong) PaprVC *paprVC; // GGXGG . DEPRECATED
@property (nonatomic, strong) PaprBaseVC *paprBaseVC;
@property (nonatomic, strong) PaprAlertVC *paprAlertVC;
@property (nonatomic, strong) PaprMoreVC *paprMoreVC;
@property (nonatomic, strong) PaprPostCreateVC *paprPostCreateVC;
@property (nonatomic, strong) PaprPostPreviewVC *paprPostPreviewVC;
@property (nonatomic, strong) PaprProfileVC *paprProfileVC;
@property (nonatomic, strong) PaprProfileEditVC *paprProfileEditVC;
@property (nonatomic, strong) PaprProfileFollowingVC *paprProfileFollowingVC;
@property (nonatomic, strong) PaprProfilePreVC *paprProfilePreVC;
@property (nonatomic, strong) PaprProfileSettingsVC *paprProfileSettingsVC;
@property (nonatomic, strong) PaprSavedPostsVC *paprSavedPostsVC;
@property (nonatomic, strong) PaprSearchVC *paprSearchVC;
@property (nonatomic, strong) PaprProgressVC *paprProgressVC;
@property (nonatomic, strong) PaprTabBarVC *paprTabBarVC;
@property (nonatomic, strong) PaprWWW *paprWWW;
@property (nonatomic, strong) PaprCommentVC *paprCommentVC;
@property (nonatomic, strong) PaprUserNotificationsVC *paprUserNotificationsVC;

// LOADING
@property (nonatomic, weak) IBOutlet UILabel *labelLoading;
@property (nonatomic, weak) IBOutlet UILabel *labelUpdated;

// LOCATION
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

// UTLITIES
@property (nonatomic, weak) IBOutlet UIView *viewFullScreenMessage;
@property (nonatomic, weak) IBOutlet UILabel *labelFullScreenMessage;


@end
