//
//  PaprProfileEditVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProfileEditVC.h"

@interface PaprProfileEditVC ()

@end

@implementation PaprProfileEditVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.myUserDictionary = [[DataController dc] returnMyUserDictionary];
    
    self.profileDictionary = [[NSMutableDictionary alloc] initWithDictionary: [self.myUserDictionary objectForKey:@"user_profile"] ];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupEditSections];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void) setupEditSections {
    
    // AVATAR
    if (profileWasChanged) {
        // SKIP THIS FOR NOW
    } else {

        NSURL *imageURL = [NSURL URLWithString:[self.profileDictionary objectForKey:@"user_profile_avatar_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        [self.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.imageViewAvatar.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            self.imageViewAvatar.image = [UIImage imageNamed:@"header_empty_avatar_07.png"];
        }];

        // AVATAR . ROUNDED
        self.imageViewAvatar.backgroundColor = [UIColor cyanColor];
        self.imageViewAvatar.layer.masksToBounds = YES;
        self.imageViewAvatar.layer.cornerRadius = 5;

    }

    [self setupPlaceholderText];

}
- (void) setupPlaceholderText {

    // DISPLAY NAME.self.profileDictionary
    NSString *profileDisplayName = [self.profileDictionary objectForKey:@"user_profile_display_name"];
    if (profileDisplayName.length > 0) {
        self.textFieldDisplayName.text = [self.profileDictionary objectForKey:@"user_profile_display_name"];
    } else {
        self.textFieldDisplayName.text = [self.myUserDictionary objectForKey:@"user_username"];
    }
    
    // URL
    NSString *profileURL = [self.profileDictionary objectForKey:@"user_profile_url"];
    if ( [profileURL isEqualToString:@"-"] ) {
        self.textFieldURL.text = @"Got website?";
    } else {
        self.textFieldURL.text = [self.profileDictionary objectForKey:@"user_profile_url"];
    }
    
    // BLURB
    NSString *profileBlurb = [self.profileDictionary objectForKey:@"user_profile_blurb"];
    if ( [profileBlurb isEqualToString:@"-"] ) {
        self.textFieldBlurb.text = @"Tell 'em about yourself.";
    } else {
        self.textFieldBlurb.text = [self.profileDictionary objectForKey:@"user_profile_blurb"];
    }

}

#pragma mark - IMAGEPICKER METHODS

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    profileWasChanged = TRUE;
    
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

#pragma mark - UITEXTVIEW METHODS

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField becomeFirstResponder];
    
    [self slideViewUp];

    if (textField == self.textFieldDisplayName) {

        //
        
    } else if (textField == self.textFieldURL) {
        
        if ( [self.textFieldURL.text isEqualToString:@"Got website?"] ) {
            self.textFieldURL.text = @"";
        }
        
    } else if (textField == self.textFieldBlurb) {

        if ( [self.textFieldBlurb.text isEqualToString:@"Tell 'em about yourself."] ) {
            self.textFieldBlurb.text = @"";
        }

    }

    
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if ([textField.text isEqualToString:self.profileDictionary]) {
            //
        } else {
            profileWasChanged = TRUE;
        }

        [textField resignFirstResponder];
        
        [self slideViewDown];
        
        return NO;
        
    }
    
    return YES;
    
}
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
    
}
- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];

    [self slideViewDown];
    
    if (textField == self.textFieldDisplayName) {
        
        if ( [self.textFieldDisplayName.text isEqualToString:@""] ) {
            [self.profileDictionary setObject:[self.myUserDictionary objectForKey:@"user_username"] forKey:@"user_profile_display_name"];
        } else {
            profileWasChanged = TRUE;
            [self.profileDictionary setObject:self.textFieldDisplayName.text forKey:@"user_profile_display_name"];
        }

    } else if (textField == self.textFieldURL) {
        
        if ( [self.textFieldURL.text isEqualToString:@""] ) {
            [self.profileDictionary setObject:@"-" forKey:@"user_profile_url"];
        } else {
            profileWasChanged = TRUE;
            [self.profileDictionary setObject:self.textFieldURL.text forKey:@"user_profile_url"];
        }
        
    } else if (textField == self.textFieldBlurb) {
        
        if ( [self.textFieldBlurb.text isEqualToString:@""] ) {
            [self.profileDictionary setObject:@"-" forKey:@"user_profile_blurb"];
        } else {
            profileWasChanged = TRUE;
            [self.profileDictionary setObject:self.textFieldBlurb.text forKey:@"user_profile_blurb"];
        }

    }
    
    [self setupPlaceholderText];

}
- (void) slideViewUp {
    
    float offsetY = (self.view.frame.size.width / 2) * -1;
    
    [UIView animateWithDuration: 0.5
                     animations: ^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x, offsetY, self.view.frame.size.width, self.view.frame.size.height);
                     } completion: ^(BOOL finished){
                         //
                     }
     ];
    
}
- (void) slideViewDown {
    
    [UIView animateWithDuration: 0.5
                     animations: ^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                     } completion: ^(BOOL finished){
                         //
                     }
     ];
    
}

#pragma mark - AWS METHODS

- (void) uploadImage {
    
    // PREPARE IMAGE FOR UPLOAD AS NSDATA
    NSData *imageDATA = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.imageViewAvatar.image, 0.7)];
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileDirectory = [filePath objectAtIndex:0];
    NSString *fileActual = [fileDirectory stringByAppendingPathComponent:@"image.jpg"];
    [imageDATA writeToFile:fileActual atomically:YES];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    uploadRequest.bucket = @"papr-user-images-1000001";
    // uploadRequest.key = [[DataController dc] returnImageStringForUser];
    self.avatarURL = [[DataController dc] returnImageStringURL:uploadRequest.key];
    uploadRequest.body = [NSURL fileURLWithPath: fileActual];
    uploadRequest.contentType = @"image/jpeg";
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    
    imageUploadInProgress = TRUE;
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
        
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
            
            self.avatarURL = [[DataController dc] returnImageStringURL:uploadRequest.key];
            
            profileWasChanged = TRUE;
            imageUploadInProgress = FALSE;
            
            [self.profileDictionary setObject:self.avatarURL forKey:@"user_profile_avatar_url"];

            [self updateUser];
            
        }
        return nil;
        
    }];
    
}

#pragma mark - IBACTION && RELATED METHODS

- (void) updateUser {
    
    NSLog(@"self.profileDictionary = %@", self.profileDictionary);
    
    [[DataController dc] updateUserDictionaryWithNewProfile:self.profileDictionary];
    
    [DataController dc].userNeedsUpdate = TRUE;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.updateUserFromPaprVC" object:nil];
    
}
- (IBAction) buBackSelected : (id)sender {

    if (profileWasChanged) {
        
        [self updateUser];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprProfileEditVC" object:nil];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprProfileEditVC" object:nil];

    }

}
- (IBAction) buAvatarSelected : (id)sender {
    
    // UIALERT . ACTIONSHEET
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"PAPR"
                                                                         message:@"Update Your Avatar"
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
- (IBAction) buDisplayNameSelected : (id)sender {
    
    //
    
}
- (IBAction) buURLSelected : (id)sender {
    
    //
    
}
- (IBAction) buBlurbSelected : (id)sender {
    
    //
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
