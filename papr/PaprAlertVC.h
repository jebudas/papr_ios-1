//
//  PaprAlertVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/20/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"


@interface PaprAlertVC : UIViewController {

    float fadeInDuration;
    
    CGRect frameOriginal;
    CGRect frameDestination;

    BOOL iAmFadingMessage;
    float messageExpeditor;
    float viewGradientHeight;
    
}

// GLOBAL PROPERTIES
@property (nonatomic, strong) NSDictionary *messageDictionary;
@property (nonatomic, weak) IBOutlet UIView *viewBG;
// SPECIFIC PROPERTIES
@property (nonatomic, strong) NSString *currentView;
@property (nonatomic, weak) IBOutlet UIView *viewAlertInternet;
@property (nonatomic, weak) IBOutlet UIView *viewAlertInternetMessage;
@property (nonatomic, weak) IBOutlet UIView *viewAlertLocation;
@property (nonatomic, weak) IBOutlet UIView *viewAlertSwipeFromPapr;
@property (nonatomic, weak) IBOutlet UIView *viewAlertSwipeFromCircle;

// METHODS
- (void) fadeInAlertLocation;

@end
