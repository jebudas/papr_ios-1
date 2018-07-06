//
//  PaprPostCreateVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import <CoreText/CoreText.h>
#import "UIColor+PAPRColor.h"
// API
#import "APIController+Paprboy.h"
#import "UIImageView+AFNetworking.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// AWS
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <AWSCognito/AWSCognito.h>


@interface PaprPostCreateVC : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    int lineMaximum;
    int charsPerLine;
    int charLimitation;

    BOOL iLoveSerif;
    BOOL iHaveLinkage;
    BOOL iAmPosting;
    BOOL linkUploadedWithPost;
    BOOL imageUploadedWithPost;
    BOOL imageUploadInProgress;
    
    NSRange currentRangeFinder;
    NSUInteger rangeStartLocation;
    BOOL rangeStartLocationNeedsUpdate;
    BOOL textIsThreeLinesOrLess;
    
}

// HEADER
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelAvatar;
// POST
@property (nonatomic, strong) NSArray *linesArray;
@property (nonatomic, strong) NSString *postString;
@property (nonatomic, strong) NSString *postImageURL;
@property (nonatomic, strong) NSString *postLinkURL;
@property (nonatomic, strong) NSDictionary *postDictionary;
@property (nonatomic, strong) NSDictionary *repostDictionary;
@property (nonatomic, strong) NSDictionary *articleDictionary;
@property (nonatomic, weak) IBOutlet UIButton *buPost;
@property (nonatomic, weak) IBOutlet UILabel *labelBuPost; // GRRRRRRRR...
@property (nonatomic, weak) IBOutlet UILabel *labelAddPost;
@property (nonatomic, weak) IBOutlet UILabel *labelAddPostExtra;
@property (nonatomic, weak) IBOutlet UITextView *textViewPost;
@property (nonatomic, weak) IBOutlet UIView *viewFetchedData;
@property (nonatomic, weak) IBOutlet UIView *viewFetchedDataPhoto;
@property (nonatomic, weak) IBOutlet UILabel *labelFetchedTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelFetchedURL;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewFetchedThumbnail;
@property (nonatomic, weak) IBOutlet UIView *viewFetchedPhoto;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewFetchedPhoto;
@property (nonatomic, weak) IBOutlet UIView *viewSpinner;
@property (nonatomic, weak) IBOutlet UILabel *labelSpinner;
// PHOTO
@property (nonatomic, strong) UIImage *imagePhotoActual;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewPhotoThumbnail;
@property (nonatomic, weak) IBOutlet UIButton *buCamera;
@property (nonatomic, weak) IBOutlet UIButton *buLink;

- (void) populateFieldsWithDictionary : (NSDictionary *)repostDictionary;

@end
