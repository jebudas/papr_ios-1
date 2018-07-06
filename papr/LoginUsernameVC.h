//
//  LoginUsernameVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/16/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// LOGIN
#import "LoginSelectionVC.h"
// API
#import "APIController+User.h"
// AK
#import <AccountKit/AccountKit.h>
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// TOOLS
#import <CoreText/CoreText.h>
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"
// AWS
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <AWSCognito/AWSCognito.h>


@interface LoginUsernameVC : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    BOOL iHaveFacebookAccountKitDetails;
    BOOL iHaveSetupTheAvatar;
    BOOL imageUploadInProgress;
    
}

@property (nonatomic, strong) NSDictionary *myUserDictionary;
@property (nonatomic, strong) NSMutableDictionary *profileDictionary;
@property (nonatomic, strong) NSString *fbLoginToken;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSMutableDictionary *loginKitDictionary;
// IBOUTLET
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelUsernameError;
@property (nonatomic, weak) IBOutlet UITextField *textFieldName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldUsername;
@property (nonatomic, weak) IBOutlet UIButton *buContinue;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
// NAVIGATION
@property (nonatomic, strong) LoginSelectionVC *loginSelectionVC;

@end
