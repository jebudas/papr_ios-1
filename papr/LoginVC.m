//
//  LoginVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/5/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC () <AKFViewControllerDelegate>
@end

@implementation LoginVC {

    AKFAccountKit *_accountKit;
    UIViewController<AKFViewController> *_pendingLoginViewController;
    NSString *_authorizationCode;

}


- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSLog(@"LoginVC . viewDidLoad");

    // TODO . GGXGG
    // return;
    
    // initialize Account Kit
    if (_accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken OR AKFResponseTypeAuthorizationCode
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
        
    }
    
    // view controller for resuming login
    _pendingLoginViewController = [_accountKit viewControllerForLoginResume];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    
    // ROUND CORNERS
    self.buLogin.backgroundColor = [UIColor paprBlue];
    self.buLogin.layer.masksToBounds = YES;
    self.buLogin.layer.cornerRadius = 5;

    // SETUP FB LOGIN
    if (_pendingLoginViewController != nil) {
        
        // resume pending login (if any)
        [self _prepareLoginViewController:_pendingLoginViewController];
        [self presentViewController:_pendingLoginViewController animated:animated completion:NULL];
        _pendingLoginViewController = nil;
        
    }

}
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

}

#pragma mark - PAPR API Calls

- (void) testPOST : (NSString *)authCodeRCVD {
    
    __weak LoginVC *weakSelf = self;
    
    [[APIController api] sendAuthCode:authCodeRCVD success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"LoginVC . testPOST . success = %@", responseDictionary);
        
        // [weakSelf finalizeLoginVC];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"LoginVC . testPOST . failure");
        
    }];

    
}

- (void) registerAuthCode : (NSString *)authCodeRCVD {

    __weak LoginVC *weakSelf = self;
    
    [[APIController api] sendAuthCode:authCodeRCVD success:^(NSDictionary *responseDictionary) {

        NSLog(@"LoginVC . registerAuthCode . success = %@", responseDictionary);
        
        // [weakSelf finalizeLoginVC];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"LoginVC . registerAuthCode . failure");
        
    }];
    
}

#pragma mark - Facebook API Calls

- (IBAction) loginWithPhone : (id)sender {
    
    [[Mixpanel sharedInstance] track: @"Login" properties: @{@"Status": @"Initiated"}];

    UIViewController<AKFViewController> *viewController = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:nil state:[[NSUUID UUID] UUIDString]];
    viewController.uiManager = [[AKFSkinManager alloc] initWithSkinType:AKFSkinTypeContemporary primaryColor:[UIColor greenColor]];
    viewController.enableSendToFacebook = YES; // defaults to NO
    
    [self _prepareLoginViewController:viewController]; // see below
    [self presentViewController:viewController animated:YES completion:NULL];

}
- (void) _prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController {
    
    loginViewController.delegate = self;
    loginViewController.advancedUIManager = nil;
    loginViewController.uiManager = [[AKFSkinManager alloc]
                                initWithSkinType:AKFSkinTypeClassic
                                primaryColor:[UIColor paprBlue]
                                backgroundImage:nil
                                backgroundTint:AKFBackgroundTintWhite
                                tintIntensity:1.0];
    
    
}
// handle callbacks on successful login to show account
- (void) viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state {
    
    NSLog(@"LoginVC . SUCCESS . TOKEN");
    NSLog(@"LoginVC . SUCCESS . TOKEN . accessToken = %@", accessToken);
    NSLog(@"LoginVC . SUCCESS . TOKEN . accessToken.string = %@", accessToken.tokenString);
    // accessToken.string = EMAWcPyQ2cRzuLRBN2a1K5hC92dZBmnObA2LmQPwCsv4A1BNt0u1qdj8d766oXc4422BKEAHOmaZC0bWz6gV8CGksF7MsXDLZBFC494KpPgZDZD
    // accessToken.string = EMAWeYWJmZCny5UzSbpRJJ1gzkGrK8mmtUgHZCPgwCP3kAAZANi9rDgFKu3kFj0e0ZB63iTfGrWWL9do84SZCGyfBzvZBhllcXZC4GrkAjN3wvQZDZD
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken.tokenString forKey:@"fb_access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self pushLoginUsername : accessToken.tokenString];
    
}

// handle callback on successful login to show authorization code
- (void) viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state {

    // Pass the code to your own server and have your server exchange it for a user access token.
    // You should wait until you receive a response from your server before proceeding to the main screen.
    NSLog(@"LoginVC . SUCCESS . AUTHCODE");
    
    [self registerAuthCode : code];


}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error {
    // ... implement appropriate error handling ...
    NSLog(@"LoginVC . %@ did fail with error: %@", viewController, error);
}
- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController {
    // ... handle user cancellation of the login process ...
    NSLog(@"LoginVC . User did cancel.");

}

#pragma mark - Navigation

- (void) pushLoginUsername : (NSString *)tokenRCVD {

    self.loginUsernameVC = [[LoginUsernameVC alloc] init];
    self.loginUsernameVC.fbLoginToken = tokenRCVD;
    [self.navigationController pushViewController:self.loginUsernameVC animated:YES];
    
}

#pragma mark - IBACTION METHODS

- (IBAction) buTermsSelected : (id)sender {
    // TODO GGXGG:
    // LAUNCH URL
    // HAVE URL TO LAND ON!
}
- (IBAction) buPrivacySelected : (id)sender {
    // TODO GGXGG:
    // LAUNCH URL
    // HAVE URL TO LAND ON!
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
