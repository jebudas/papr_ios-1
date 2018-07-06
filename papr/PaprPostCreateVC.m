//
//  PaprPostCreateVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprPostCreateVC.h"

@interface PaprPostCreateVC ()

@end

@implementation PaprPostCreateVC

- (void)viewDidLoad {

    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupHeader];
    [self setupLabels];
    [self setupFont];
    [self setupTextViewPost];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.repostDictionary) {
    
        NSString *publisherID = [self.repostDictionary objectForKey:@"post_publisher"];
        
        if ([publisherID hasPrefix:@"p"]) {
            
            self.viewSpinner.alpha = 1.0;

            [self getArticleFromNewspaper : [self.repostDictionary objectForKey:@"post_link"]];

        } else {
        
            [self populateFieldsWithDictionary : self.repostDictionary];
        
        }
        
    }
    
}

- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postPapr) name:@"PaprPostCreateVC.postPapr" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSelfCreateVC) name:@"PaprPostCreateVC.popSelf" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostCreateVC.popSelf" object:nil];

}
- (void) setupHeader {

    self.labelAvatar.alpha = 0.0;
    self.imageViewAvatar.alpha = 0.0;
    
    NSDictionary *headerDictionary = [[DataController dc] returnMyUserDictionary];
    NSDictionary *profileDictionary = [[NSDictionary alloc] initWithDictionary: [headerDictionary objectForKey:@"user_profile"]];
    
    NSURL *imageURL = [NSURL URLWithString:[headerDictionary objectForKey:@"user_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [self.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        // SETUP THE IMAGE
        self.imageViewAvatar.image = image;
        // ROUNDED CORNER
        self.imageViewAvatar.backgroundColor = [UIColor clearColor];
        self.imageViewAvatar.layer.masksToBounds = YES;
        self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.size.width / 5;
        // LET THE WORLD SEE
        self.imageViewAvatar.alpha = 1.0;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    self.labelAvatar.text = [profileDictionary objectForKey:@"edition_display_name"];
    self.labelAvatar.alpha = 1.0;

}
- (void) setupLabels {

    rangeStartLocation = 0;
    rangeStartLocationNeedsUpdate = TRUE;
    
    self.labelAddPost.textColor = [UIColor darkTextColor];

}
- (void) setupFont {
    
    NSDictionary *myUserDictionary = [[DataController dc] returnMyUserDictionary];
    NSDictionary *myUserSettings = [myUserDictionary objectForKey:@"user_settings"];
    iLoveSerif = [[myUserSettings objectForKey:@"user_settings_font"] boolValue];
    
    int fontSize = [[DataController dc] returnRelativeSizeForThisScreen:20];
    
    if (iLoveSerif) {
        
        // THIS IS SERIF
        if (iHaveLinkage) {
            self.labelAddPost.font = [UIFont fontWithName:@"Georgia-Bold" size:fontSize];
            self.textViewPost.font = [UIFont fontWithName:@"Georgia-Bold" size:fontSize];
        } else {
            self.labelAddPost.font = [UIFont fontWithName:@"Georgia" size:fontSize];
            self.textViewPost.font = [UIFont fontWithName:@"Georgia" size:fontSize];
        }
        
    } else {
        
        // SANS SERIF
        if (iHaveLinkage) {
            self.labelAddPost.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
            self.textViewPost.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
        } else {
            self.labelAddPost.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
            self.textViewPost.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
        }
        
    }
    
}
- (void) setupTextViewPost {
    
    [self turnPostButtonOff];

    imageUploadedWithPost = FALSE;
    imageUploadInProgress = FALSE;

    self.textViewPost.textContainer.lineFragmentPadding = 0;
    self.textViewPost.textContainerInset = UIEdgeInsetsZero;
    self.textViewPost.textContainer.maximumNumberOfLines = 10;
    
    [self.textViewPost becomeFirstResponder];

}

#pragma mark - POST METHODS

- (void) postPapr {
    
    NSLog(@"PaprPostCreateVC.postPapr");

    
    
    
    [self popSelfCreateVC];
    
}
- (void) createPostDictionary {

    // TODO GGXGG: START SPINNER...
    
    // MUTABLE DICT
    NSMutableDictionary *postDictionaryEDITING = [[NSMutableDictionary alloc] init];
    
    // self.postString = [self returnPostString];
    NSString *postAuthor = @"None.";
    NSString *postID = [[DataController dc] returnPostID];
    NSString *postPublisher = [[DataController dc] returnMyUserID];
    NSString *postTimestamp = [[DataController dc] returnTimestamp];
    NSString *postPublisherMastURL = [[DataController dc] returnMyMastURL];
    NSString *postPublisherAvatarURL = [[DataController dc] returnMyAvatarURL];
    NSString *postPublisherDisplayName = [[DataController dc] returnMyDisplayName];
    NSString *postType = @"text";
    NSString *postImageURL = @"";

    if (self.articleDictionary) {
    
        postImageURL = [self.articleDictionary objectForKey:@"newspaper_image_url"];
        
        if (imageUploadedWithPost) {
            postType = @"full";
        }
        
        self.postLinkURL = [self.articleDictionary objectForKey:@"newspaper_url"];
        self.postString = self.textViewPost.text;

    } else if (self.repostDictionary) {

        NSDictionary *repostData = @{@"orig_post_id" : [self.repostDictionary objectForKey:@"post_id"],
                                     @"orig_post_timestamp" : [self.repostDictionary objectForKey:@"post_timestamp"],
                                     @"orig_post_publisher" : [self.repostDictionary objectForKey:@"post_publisher"]};
        [postDictionaryEDITING setObject:repostData forKey:@"repost_data"];
        
        postAuthor = [self.repostDictionary objectForKey:@"post_author"];
        postType = [self.repostDictionary objectForKey:@"post_type"];
        postImageURL = [self.repostDictionary objectForKey:@"post_image_url"];
        self.postLinkURL = [self.repostDictionary objectForKey:@"post_link"];
        self.postString = self.textViewPost.text;
        
    } else {

        if (imageUploadedWithPost) {
            if (imageUploadInProgress) {
                // TODO GGXGG: CALL THIS METHOD AGAIN?
            } else {
                postType = @"image";
                postImageURL = self.postImageURL;
            }
        }

    }

    if (postAuthor.length > 0) { [postDictionaryEDITING setObject:postAuthor forKey:@"post_author"]; }
    if (self.postString.length > 0) { [postDictionaryEDITING setObject:self.postString forKey:@"post_description"]; }
    if (postID.length > 0) { [postDictionaryEDITING setObject:postID forKey:@"post_id"]; }
    if (postImageURL.length > 0) { [postDictionaryEDITING setObject:postImageURL forKey:@"post_image_url"]; }
    if (postPublisher.length > 0) { [postDictionaryEDITING setObject:postPublisher forKey:@"post_publisher"]; }
    if (postTimestamp.length > 0) { [postDictionaryEDITING setObject:postTimestamp forKey:@"post_timestamp"]; }
    if (postPublisherMastURL.length > 0) { [postDictionaryEDITING setObject:postPublisherMastURL forKey:@"post_publisher_mast_url"]; }
    if (postPublisherAvatarURL.length > 0) { [postDictionaryEDITING setObject:postPublisherAvatarURL forKey:@"post_publisher_avatar_url"]; }
    if (postPublisherDisplayName.length > 0) { [postDictionaryEDITING setObject:postPublisherDisplayName forKey:@"post_publisher_display_name"]; }
    if (self.postString.length > 0) {
        [postDictionaryEDITING setObject:self.postString forKey:@"post_title"];
    } else {
        [postDictionaryEDITING setObject:@"-" forKey:@"post_title"];
    }
    if (postType.length > 0) { [postDictionaryEDITING setObject:postType forKey:@"post_type"]; }
    if (self.postLinkURL.length > 0) {
        [postDictionaryEDITING setObject:self.postLinkURL forKey:@"post_link"];
    } else if (postImageURL.length > 0) {
        [postDictionaryEDITING setObject:postImageURL forKey:@"post_link"];
    }
    
    self.postDictionary = [[NSDictionary alloc] initWithDictionary:postDictionaryEDITING];
    
    // NSLog(@"self.postDictionary = %@", self.postDictionary);
    
    NSDictionary *editionDictionary = [[NSDictionary alloc] initWithDictionary: [[DataController dc] returnFullEditionDictionaryWithNewPost:self.postDictionary] ];
    
    [self publishPostDictionary : editionDictionary];

}
- (void) publishPostDictionary : (NSDictionary *)editionDictionaryRCVD {

    if (iAmPosting) { return; }
    
    iAmPosting = TRUE;
    
    NSDictionary *parameters = @{ @"new_edition_dictionary" : editionDictionaryRCVD};
    
    [[APIController api] postItemToPapr:parameters success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {

            NSLog(@"PaprPostCreateVC . postItemToPapr . success . responseDictionary = %@", responseDictionary);
            
            iAmPosting = FALSE;

            [self archivePostItem : self.postDictionary];

            [[DataController dc] saveMyPaprDictionary:editionDictionaryRCVD];

            [self insertPaprIntoScrollView : editionDictionaryRCVD];
            
            [[DataController dc] updateUserPostTotal];

            [self showMyNewPaprDictionaryInPreview];

            [[Mixpanel sharedInstance] track: @"Papr . Create Post" properties: @{@"Status": @"Completed"}];

        } else {
        
            self.viewSpinner.alpha = 0.0;
            self.labelSpinner.text = @"Fetching Article...";

        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprPostCreateVC . postItemToPapr . failure . error = %@", error);

        iAmPosting = FALSE;

        self.viewSpinner.alpha = 0.0;
        self.labelSpinner.text = @"Fetching Article...";
        
    }];

}
- (void) archivePostItem : (NSDictionary *)editionDictionaryRCVD {
    
    NSDictionary *parameters = @{ @"post_dictionary" : self.postDictionary};
    
    [[APIController api] saveItemToArchives:parameters success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            NSLog(@"archivePostItem . postItemToPapr . success . responseDictionary = %@", responseDictionary);
            
        } else {
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"archivePostItem . postItemToPapr . failure . error = %@", error);
        
    }];
    
}
- (void) showMyNewPaprDictionaryInPreview {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostPreviewVC.reloadPaprDictionary" object:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (void) popSelfCreateVC {
    
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (NSString *) returnPostString {

    int linesCounter = 1;
    NSString *thisPostString = @"";
    
    for (NSString *line in self.linesArray) {
        
        NSString *linesStringFull = [thisPostString stringByAppendingString: line ];
        
        thisPostString = linesStringFull;
        
        linesCounter++;
        
        if (linesCounter > 4) {
            
            break;
            
        }
        
    }

    return thisPostString;
    
}
- (void) getArticleFromNewspaper : (NSString *)urlRCVD {

    NSDictionary *urlDictionary = @{@"url" : urlRCVD};
    
    [[APIController api] getArticle:urlDictionary success:^(NSDictionary *responseDictionary) {
        
        self.viewSpinner.alpha = 0.0;

        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            NSLog(@"PaprPostCreateVC . getArticle . success . responseDictionary = %@", responseDictionary);
            
            self.textViewPost.text = @"";
            
            self.articleDictionary = [[NSDictionary alloc] initWithDictionary: [responseDictionary objectForKey:@"this_newspaper_dictionary"] ];

            [self updateViewFetched];
            
            // [self textViewDidChange : self.textViewPost];
            
            linkUploadedWithPost = TRUE;

        } else {
            
            self.articleDictionary = nil;
            
            NSLog(@"PaprPostCreateVC . getArticle . ELSE . responseDictionary = %@", responseDictionary);
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprPostCreateVC . getArticle . failure . error = %@", error);

        self.articleDictionary = nil;

        self.viewSpinner.alpha = 0.0;

    }];

}
- (void) insertPaprIntoScrollView : (NSDictionary *)newEditionDictionary {

    NSString *newIndex = [NSString stringWithFormat:@"%i", [DataController dc].currentPaprIndex];
    
    NSDictionary *newPaprAndIndex = @{@"newPapr":newEditionDictionary,
                                      @"newIndex":newIndex};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.updatePaprSubscriptionsWithNewPapr" object:nil userInfo:newPaprAndIndex];

}
- (void) populateFieldsWithDictionary : (NSDictionary *)repostDictionary {

    NSLog(@"repostDictionary = %@", repostDictionary);

    self.repostDictionary = [[NSDictionary alloc] initWithDictionary: repostDictionary ];
    
    self.textViewPost.text = [self.repostDictionary objectForKey:@"post_title"];
    
    [self textViewDidChange : self.textViewPost];
    
    [self setupThumbnailWithArticleImage];
    
    [self.buLink setBackgroundImage:[UIImage imageNamed:@"post_icon_link_on.png"] forState:UIControlStateNormal];
    
    linkUploadedWithPost = TRUE;

}
- (void) updateViewFetched {
    
    self.viewFetchedData.alpha = 1.0;
    
    self.labelFetchedURL.text = [self.articleDictionary objectForKey:@"newspaper_url"];
    self.labelFetchedTitle.text = [self.articleDictionary objectForKey:@"newspaper_title"];

    //[self textViewDidChange : self.textViewPost];

    [self setupThumbnailWithArticleImage];
    
}


#pragma mark - UITEXTVIEW + UILABEL METHODS

// UITEXTVIEW
- (void) turnPostButtonOn {
    
    // UPDATE POST BUTTON
    self.buPost.enabled = TRUE;
    self.labelBuPost.textColor = [UIColor paprBlue];
    
}
- (void) turnPostButtonOff {
    
    // UPDATE POST BUTTON
    self.buPost.enabled = FALSE;
    self.labelBuPost.textColor = [UIColor paprGreyLight];
    
}
- (void) textViewDidBeginEditing:(UITextView *)textView {

    [textView becomeFirstResponder];

}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;

}
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        
        if ([text hasPrefix:@"http"]) {

            [self linkWasPasted : text];
            
            return NO;

        } else {
        
            NSString *urlText = [self returnURLFromPastedText : text];
            
            if (urlText.length > 7) {

                [self linkWasPasted : urlText];
                
                return NO;

            }

            
        }
        
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        if (textView.text.length > 0) {
            [self buPostSelected:nil];
        }

        return NO;
    
    }

    
    
    if (range.length == 1 && text.length == 0) {
        NSLog(@"backspace tapped");
    }

    return YES;
    
}
- (void) textViewDidChange:(UITextView *)textView {

    if ([textView.text isEqualToString:@""]) {

        self.labelAddPostExtra.text = @"Type or paste a link...";
        self.labelAddPostExtra.alpha = 1.0;
        self.labelAddPostExtra.textColor = [UIColor paprGreyVeryLight];

        // UPDATE POST BUTTON
        [self turnPostButtonOff];
        
    } else {

        self.labelAddPostExtra.text = @"";
        self.labelAddPostExtra.alpha = 0.0;
        self.labelAddPostExtra.textColor = [UIColor paprGreyVeryLight];

        self.labelAddPost.text = textView.text;
        
        // UPDATE POST BUTTON
        [self turnPostButtonOn];

        self.linesArray = [self getLinesArrayOfStringInLabel:self.labelAddPost];
        int linesCounter = 1;
        int rangeLength = 0;
        int rangeLocation = 1;
        self.postString = @"";

        for (NSString *line in self.linesArray) {
            
            NSString *linesStringFull = [self.postString stringByAppendingString: line ];
            
            if (linesCounter == 3) {
                rangeLocation = (int)linesStringFull.length;
            } else if (linesCounter == 4) {
                rangeLength = (int)linesStringFull.length - rangeLocation;
            }
            
            self.postString = linesStringFull;
            
            linesCounter++;

        }
        
        if (self.linesArray.count > 4) {
            
            UIFont *fontMenlo = self.labelAddPost.font;
            NSDictionary *fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:fontMenlo, NSFontAttributeName, nil];
            NSMutableAttributedString *attributedTextViewString = [[NSMutableAttributedString alloc] initWithString:self.textViewPost.text attributes:fontAttributes];
            NSRange rangeRed = NSMakeRange(rangeLocation, rangeLength);
            [attributedTextViewString addAttribute:NSForegroundColorAttributeName value:[UIColor paprRed] range:rangeRed];
            
            self.textViewPost.attributedText = attributedTextViewString;
            
        }
        
    }
    
}
- (BOOL) textViewShouldEndEditing:(UITextView *)textView {

//    [self.textViewPost resignFirstResponder];
    
    return YES;

}
- (void) textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {

        //
    
    } else {
    
        [self turnPostButtonOn];
        
    }
    
    [textView resignFirstResponder];

}
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label {
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return (NSArray *)linesArray;
}
// UILABEL
- (void) linkWasPasted : (NSString *)textRCVD {

    NSLog(@"[UIPasteboard generalPasteboard].string = %@", [UIPasteboard generalPasteboard].string);

    iHaveLinkage = TRUE;
    
    [self setupFont];
    
    self.labelAddPostExtra.text = @"";
    self.labelAddPostExtra.alpha = 0.0;
    self.labelAddPostExtra.textColor = [UIColor paprGreyVeryLight];

    self.viewSpinner.alpha = 1.0;
    
    self.postLinkURL = textRCVD;
    
    [self getArticleFromNewspaper:self.postLinkURL];
    
    [self.buLink setBackgroundImage:[UIImage imageNamed:@"post_icon_link_on.png"] forState:UIControlStateNormal];
    
    linkUploadedWithPost = TRUE;

}
- (NSString *) returnURLFromPastedText : (NSString *)textRCVD {
    
    // FIRST CHECK FOR HTTP WITH AN ARRAY DIVIDED BY SPACES
    NSArray *arrayOfTextSpaces = [textRCVD componentsSeparatedByString:@" "];

    for (NSString *thisText in arrayOfTextSpaces) {
    
        if ([thisText hasPrefix:@"http"]) {
            
            return thisText;
            
        }
        
    }

    // THEN CHECK FOR HTTP WITH AN ARRAY DIVIDED BY RETURNS "\n"
    NSArray *arrayOfTextReturns = [textRCVD componentsSeparatedByString:@"\n"];
    
    for (NSString *thisText in arrayOfTextReturns) {
        
        if ([thisText hasPrefix:@"http"]) {
            
            return thisText;
            
        }
        
    }
    
    return @"-";
    
}
- (void) updateLabelAddPostWithText : (NSString *)textRCVD {

    self.labelAddPost.text = textRCVD;
    
}

#pragma mark - IMAGEPICKER METHODS

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    UIImage *imageSquare = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *imageSelected = [info objectForKey:UIImagePickerControllerOriginalImage];

    self.imagePhotoActual = [self squareImageFromImage:imageSquare scaledToSize:1080];
    

    CGFloat thumbnailWidth = self.imageViewPhotoThumbnail.frame.size.width;
    CGFloat thumbnailHeight = self.imageViewPhotoThumbnail.frame.size.height;
    self.imageViewPhotoThumbnail.image = [self scaleImage:imageSquare toSize:CGSizeMake(thumbnailWidth,thumbnailHeight)];
    
    [self uploadImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.textViewPost becomeFirstResponder];
    
    [self.buCamera setBackgroundImage:[UIImage imageNamed:@"post_icon_camera_on.png"] forState:UIControlStateNormal];
    
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
- (UIImage *)createThumbnailImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    
    CGFloat newWidth = self.imageViewPhotoThumbnail.frame.size.width;
    CGFloat newHeight = self.imageViewPhotoThumbnail.frame.size.height;
    
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        // LANDSCAPE
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
        
    } else {
        // PORTRAIT
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newWidth, newHeight);
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
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
    
    
#endif
    
}
- (void) pushPhotoLibrary {
    
#if TARGET_OS_IPHONE
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
    
#endif
    
}
- (void) setupThumbnailWithArticleImage {

    NSString *imageString = [self.articleDictionary objectForKey:@"newspaper_image_url"];
    
    if (imageString.length < 7) {
        self.viewFetchedDataPhoto.alpha = 0.0;
        return;
    }
    
    NSURL *imageURL = [NSURL URLWithString:[self.articleDictionary objectForKey:@"newspaper_image_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    
    [self.imageViewFetchedThumbnail setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        self.imageViewFetchedThumbnail.image = image;

        self.viewFetchedDataPhoto.alpha = 1.0;

        imageUploadedWithPost = TRUE;
        imageUploadInProgress = FALSE;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
        self.viewFetchedDataPhoto.alpha = 0.0;

        imageUploadedWithPost = FALSE;
        imageUploadInProgress = FALSE;
        
    }];

}

#pragma mark - AWS METHODS

- (void) uploadImage {

    // PREPARE IMAGE FOR UPLOAD AS NSDATA
    NSData *imageDATA = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.imagePhotoActual, 0.7)];
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileDirectory = [filePath objectAtIndex:0];
    NSString *fileActual = [fileDirectory stringByAppendingPathComponent:@"image.jpg"];
    [imageDATA writeToFile:fileActual atomically:YES];

    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];

    uploadRequest.bucket = @"papr-user-images-1000001";
    //uploadRequest.key = [[DataController dc] returnImageStringForUser];
    self.postImageURL = [[DataController dc] returnImageStringURL:uploadRequest.key];
    uploadRequest.body = [NSURL fileURLWithPath: fileActual];
    uploadRequest.contentType = @"image/jpeg";
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;

    imageUploadInProgress = TRUE;

    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {

        if (task.error) {
            imageUploadedWithPost = FALSE;
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
            
            self.postImageURL = [[DataController dc] returnImageStringURL:uploadRequest.key];

            imageUploadedWithPost = TRUE;
            imageUploadInProgress = FALSE;
            

        }
        return nil;
        
    }];

}


#pragma mark - IBACTION METHODS

- (IBAction) buCameraSelected : (id)sender {
    
    NSLog(@"buCameraSelected");
    
    if (imageUploadedWithPost) {
    
        [self.buCamera setBackgroundImage:[UIImage imageNamed:@"post_icon_camera_off.png"] forState:UIControlStateNormal];
        
        imageUploadedWithPost = FALSE;

    } else {

        // UIALERT . ACTIONSHEET
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"My Action Sheet"
                                                                             message:@"This is an action sheet."
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
        
        [self presentViewController:actionSheet animated:YES completion:nil];

    }

}
- (IBAction) buLinkSelected : (id)sender {
    
    NSLog(@"buLinkSelected");

    if (linkUploadedWithPost) {
    
        self.postLinkURL = @"";
        
        [self.buLink setBackgroundImage:[UIImage imageNamed:@"post_icon_link_off.png"] forState:UIControlStateNormal];
        
        linkUploadedWithPost = FALSE;

    } else if ([[UIPasteboard generalPasteboard].string hasPrefix:@"http"]) {
        
        NSLog(@"[UIPasteboard generalPasteboard].string = %@", [UIPasteboard generalPasteboard].string);
        
        self.viewSpinner.alpha = 1.0;
        
        self.postLinkURL = [UIPasteboard generalPasteboard].string;
        
        [self getArticleFromNewspaper:self.postLinkURL];
        
        [self.buLink setBackgroundImage:[UIImage imageNamed:@"post_icon_link_on.png"] forState:UIControlStateNormal];
        
        linkUploadedWithPost = TRUE;

    }

}
- (IBAction) buExitSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRoot" object:nil];
    
}
- (IBAction) buPostSelected : (id)sender {
    
    self.viewSpinner.alpha = 1.0;
    self.labelSpinner.text = @"Posting...";

    [self createPostDictionary];

}

- (void) buInsertTextSelectedAgain {

    [self buInsertTextSelected:nil];
    
}
- (IBAction) buInsertTextSelected : (id)sender {

    self.textViewPost.text = self.labelFetchedTitle.text;
    self.labelAddPost.text = self.labelFetchedTitle.text;

    [self turnPostButtonOn];
    
    if (self.buPost.isEnabled) {
        // CHILL
    } else {
        // UPDATE POST BUTTON
        [self performSelectorOnMainThread:@selector(buInsertTextSelectedAgain) withObject:nil waitUntilDone:NO];
    }

}
- (IBAction) buThumbnailViewSelected : (id)sender {
    
    if (self.viewFetchedPhoto.alpha < 0.1) {
    
        NSURL *imageURL;
        
        if (self.articleDictionary) {
        
            imageURL = [NSURL URLWithString:[self.articleDictionary objectForKey:@"newspaper_image_url"]];
            
        } else if (self.repostDictionary) {
        
            imageURL = [NSURL URLWithString:[self.articleDictionary objectForKey:@"post_image_url"]];
            
        }
        
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        
        [self.imageViewFetchedPhoto setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            self.imageViewFetchedPhoto.image = image;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

            //
            
        }];

        self.viewFetchedPhoto.alpha = 1.0;
    
    } else {

        self.viewFetchedPhoto.alpha = 0.0;
    
    }

}
- (IBAction) buThumbnailDeleteSelected : (id)sender {
    //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
