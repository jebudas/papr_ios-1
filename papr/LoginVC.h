//
//  LoginVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/5/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// LOGIN
#import "LoginUsernameVC.h"
// API
#import "APIController+User.h"
#import <AccountKit/AccountKit.h>
#import "UIColor+PAPRColor.h"
// TOOLS
#import "UIColor+PAPRColor.h"
// FACEBOOK
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginVC : UIViewController {
    //
}

@property (nonatomic, weak) IBOutlet UIButton *buLogin;
@property (nonatomic, weak) IBOutlet UIView *viewLogin;

@property (nonatomic, strong) LoginUsernameVC *loginUsernameVC;


@end
