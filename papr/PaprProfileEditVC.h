//
//  PaprProfileEditVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "UIColor+PAPRColor.h"
#import <CoreText/CoreText.h>
// API
#import "APIController+Paprboy.h"
#import "UIImageView+AFNetworking.h"
// AWS
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <AWSCognito/AWSCognito.h>


@interface PaprProfileEditVC : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

    BOOL profileWasChanged;
    BOOL imageUploadInProgress;

}

@property (nonatomic, strong) NSDictionary *myUserDictionary;
@property (nonatomic, strong) NSMutableDictionary *profileDictionary;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelUsername;
@property (nonatomic, weak) IBOutlet UITextField *textFieldDisplayName;//labelDisplayName
@property (nonatomic, weak) IBOutlet UITextField *textFieldURL;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBlurb;


@end
