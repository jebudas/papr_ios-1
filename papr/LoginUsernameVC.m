//
//  LoginUsernameVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/16/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "LoginUsernameVC.h"

@interface LoginUsernameVC ()

@end

@implementation LoginUsernameVC

- (void)viewDidLoad {

    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    self.labelUsernameError.alpha = 0.0;
    
    if (iHaveSetupTheAvatar) {
        // CHILL
    } else {
        [self updateAvatarWithImage: [[DataController dc] returnRandomAvatarURL] ];
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (iHaveFacebookAccountKitDetails) {
        // CHILL
    } else {
        [self getFacebookAccountKitDetails];
    }
    
}
- (void) updateAvatarWithImage : (NSString *)urlRCVD {

    self.avatarURL = urlRCVD;
    NSURL *imageURL = [NSURL URLWithString:self.avatarURL];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    
    [self.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        self.imageViewAvatar.image = image;
        self.imageViewAvatar.backgroundColor = [UIColor clearColor];
        self.imageViewAvatar.layer.masksToBounds = YES;
        self.imageViewAvatar.layer.cornerRadius = 5;

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];

    
}
- (void) getFacebookAccountKitDetails {
    
    NSString *url = [NSString stringWithFormat:@"https://graph.accountkit.com/v1.2/me/?access_token=%@", self.fbLoginToken];
    
    [[APIController api] apiGET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        long long longID = [[responseObject objectForKey:@"id"] longLongValue];
        NSString *phoneID = [NSString stringWithFormat:@"%lld", longID];

        NSDictionary *phoneObject = [[NSDictionary alloc] initWithDictionary: [responseObject objectForKey:@"phone"] ];
        int phonePrefix = [[phoneObject objectForKey:@"country_prefix"] intValue];
        long long phoneNational = [[phoneObject objectForKey:@"national_number"] longLongValue];
        NSString *phoneNumber = [NSString stringWithFormat:@"%i%lld", phonePrefix, phoneNational];

        self.loginKitDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   phoneID, @"fb_user_id",
                                   phoneNumber, @"fb_phone_number",
                                   nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"LoginUsernameVC . getFacebookAccountKitDetails . error = %@", error);
        
    }];
    
}
- (void) sendLoginKit {

    // self.textFieldName DEPRECATED
    
    NSDictionary *parameters = @{@"user_username" : self.textFieldUsername.text,
                                 // @"user_display_name" : self.textFieldName.text,
                                 @"user_display_name" : @"Jose",
                                 @"user_profile_avatar_url" : self.avatarURL,
                                 @"user_username_TEST" : [self.textFieldUsername.text uppercaseString],
                                 @"fb_user_id" : [self.loginKitDictionary objectForKey:@"fb_user_id"],
                                 @"fb_phone_number" : [self.loginKitDictionary objectForKey:@"fb_phone_number"]};
    
    NSLog(@"parameters = %@", parameters);
    
    [[APIController api] sendLoginKit:parameters success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"LoginUsernameVC . sendLoginKit . success = %@", responseDictionary);
        
        [self.spinner stopAnimating];
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {

            [[DataController dc] updateUserToken: [responseDictionary objectForKey:@"user_token"] ];
            
            self.loginSelectionVC = [[LoginSelectionVC alloc] init];
            [self.navigationController pushViewController:self.loginSelectionVC animated:YES];
            
            // MIXPANEL . THIS ESTABLISHES THE USER ID AS THE MAIN ID FOR THE USER.
            [[Mixpanel sharedInstance] createAlias:[self.loginKitDictionary objectForKey:@"fb_user_id"] forDistinctID:[Mixpanel sharedInstance].distinctId];
            [[Mixpanel sharedInstance] identify:[Mixpanel sharedInstance].distinctId];
            [[Mixpanel sharedInstance].people set:@{ @"fb_user_id": [self.loginKitDictionary objectForKey:@"fb_user_id"] }];
            
        } else {
            
            self.labelUsernameError.alpha = 1.0;
            self.labelUsernameError.text = [responseDictionary objectForKey:@"message"];
            
        }
        
    } failure:^(NSError *error) {

        [self.spinner stopAnimating];

        NSLog(@"LoginUsernameVC . sendLoginKit . failure . error = %@", error);

        self.labelUsernameError.alpha = 1.0;
        self.labelUsernameError.text = @"Username error. Please try again.";

    }];

}

#pragma mark - IMAGEPICKER METHODS

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    UIImage *imageSquare = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    CGFloat thumbnailWidth = self.imageViewAvatar.frame.size.width;
    //    CGFloat thumbnailHeight = self.imageViewAvatar.frame.size.height;
    //    self.imageViewAvatar.image = [self scaleImage:imageSquare toSize:CGSizeMake(thumbnailWidth,thumbnailHeight)];
    
    self.imageViewAvatar.image = [self squareImageFromImage:imageSquare scaledToSize:400];
    
    // self.imageViewAvatar.image = imageSquare;
    
    [self uploadImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize; {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)sizeRCVD {
    
    //If scaleFactor is not touched, no scaling will occur
    CGFloat scaleFactor = 1.0;
    CGFloat newWidth = sizeRCVD.width;
    CGFloat newHeight = sizeRCVD.height;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (image.size.width > newWidth || image.size.height > newHeight)
        if (!((scaleFactor = (newWidth / image.size.width)) > (newHeight / image.size.height))) //scale to fit width, or
            scaleFactor = newHeight / image.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth,newHeight));
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((newWidth - image.size.width * scaleFactor) / 2,
                             (newHeight -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Draw the image into the rect
    [image drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (void) pushCamera {
    
#if TARGET_OS_IPHONE
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
#endif
    
}
- (void) pushPhotoLibrary {
    
#if TARGET_OS_IPHONE
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
#endif
    
}


#pragma mark - AWS METHODS

- (void) uploadImage {
    
    [self.spinner startAnimating];

    // PREPARE IMAGE FOR UPLOAD AS NSDATA
    NSData *imageDATA = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.imageViewAvatar.image, 0.88)];
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileDirectory = [filePath objectAtIndex:0];
    NSString *fileActual = [fileDirectory stringByAppendingPathComponent:@"image.jpg"];
    [imageDATA writeToFile:fileActual atomically:YES];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    uploadRequest.bucket = [[DataController dc] returnMyAvatarBucket];
    uploadRequest.key = [[DataController dc] returnImageStringForUser : [self.loginKitDictionary objectForKey:@"fb_user_id"] ];
    self.avatarURL = [[DataController dc] returnImageStringURL:uploadRequest.key];
    uploadRequest.body = [NSURL fileURLWithPath: fileActual];
    uploadRequest.contentType = @"image/jpeg";
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    
    imageUploadInProgress = TRUE;
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
        
        [self.spinner stopAnimating];

        if (task.error) {
            
            imageUploadInProgress = FALSE;
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        break;
                        
                    default:
                        NSLog(@"Error: %@", task.error);
                        break;
                }
            } else {
                // Unknown error.
                NSLog(@"Error: %@", task.error);
            }
        }
        
        if (task.result) {
            
            // SUCCESS
            
            NSLog(@"task = %i", task.completed);
            
            iHaveSetupTheAvatar = TRUE;
            imageUploadInProgress = FALSE;

            self.avatarURL = [[DataController dc] returnImageStringURL:uploadRequest.key];

            [self updateAvatarWithImage: self.avatarURL ];

            [self.profileDictionary setObject:self.avatarURL forKey:@"user_profile_avatar_url"];
            
        }
        return nil;
        
    }];
    
}


#pragma mark - IBAction

- (IBAction) buContinueSelected : (id)sender {

    NSLog(@"buContinueSelected . self.textFieldName.text = %@", self.textFieldName.text);
    NSLog(@"buContinueSelected . self.textFieldUsername.text = %@", self.textFieldUsername.text);
    
    // A SUDDEN DECISION TO DEPRECATE THE AVATAR LIES HERE...
    /*
    if (iHaveSetupTheAvatar) {
        // ADVANCE
    } else {
        
        // WE'RE GONNA STOP THE USER AND TELL THEM TO ADD A PERTY PIC
        
        [self pushAlertControllerForTextFieldsWithMessage:@"Please add a profile photo."];

        return;
        
    }
     */
    
    // A SUDDEN DECISION TO DEPRECATE THE DISPLAY NAME LIES HERE...
//    if (self.textFieldName.text.length < 2) {
//
//        [self pushAlertControllerForTextFieldsWithMessage:@"This Name is a bit too short."];
//
//    } else if (self.textFieldUsername.text.length < 2) {
    
    if (self.textFieldUsername.text.length < 2) {

        [self pushAlertControllerForTextFieldsWithMessage:@"This Username is a bit too short."];

    } else if (self.loginKitDictionary) {

        [self.spinner startAnimating];
        self.labelUsernameError.alpha = 0.0;
    
        [self sendLoginKit];
        
    }
    
}
- (IBAction) buPhotoSelected : (id)sender {
    
    [self pushAlertControllerForAvatar];
    
}
- (void) pushAlertControllerForAvatar {
    
    // UIALERT . ACTIONSHEET
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Your PAPR Avatar"
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionBlock = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self pushCamera];
    }];
    
    UIAlertAction* actionReport = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self pushPhotoLibrary];
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    
    [actionSheet addAction:actionBlock];
    [actionSheet addAction:actionReport];
    [actionSheet addAction:actionCancel];
    
    [self.view.window.rootViewController presentViewController:actionSheet animated:YES completion:nil];
    
}
- (void) pushAlertControllerForTextFieldsWithMessage : (NSString *)messageRCVD {
    
    // UIALERT . ACTIONSHEET
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:messageRCVD
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    
    [actionSheet addAction:actionCancel];
    
    [self.view.window.rootViewController presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
