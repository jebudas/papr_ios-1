//
//  PaprAlertVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/20/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprAlertVC.h"

@interface PaprAlertVC ()
@end

@implementation PaprAlertVC


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNotifications];

    fadeInDuration = 0.5;
    messageExpeditor = 1;
    
}
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self hideAllViews];
    
}
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [self setupLabel];
    
    [self presentProperView];

    NSLog(@"PaprAlertVC . viewDidAppear");

}
- (void) viewDidLayoutSubviews {
    
    // IF THINGS GO SOUTH, PUT SETUPS AN FADE-INS HERE

    NSLog(@"PaprAlertVC . viewDidLayoutSubviews");

}
- (void) setupNotifications {

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSelf) name:@"PaprAlertVC.popSelf" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprAlertVC.popSelf" object:nil];
    
}
- (void) setupLabel {
    
    int viewGradientPaddingVertical = 50;
    
//    self.labelGradientText.font = [UIFont mmAlertFont];
//    self.labelGradientText.lineBreakMode = NSLineBreakByWordWrapping;
//    self.labelGradientText.text = [[self.messageDictionary objectForKey:@"label_text"] uppercaseString];
//    
//    UILabel *labelHeightFinder = [[UILabel alloc] initWithFrame:self.labelGradientText.frame];
//    labelHeightFinder.numberOfLines = 0;
//    labelHeightFinder.font = [UIFont mmAlertFont];
//    labelHeightFinder.text = self.labelGradientText.text;
//    [labelHeightFinder sizeToFit];
//    viewGradientHeight = labelHeightFinder.frame.size.height + viewGradientPaddingVertical;
    
}
- (void) presentProperView {

    if ( [self.currentView isEqualToString:@"location"] ) {
    
        [self fadeInAlertLocation];
        
    } else if ( [self.currentView isEqualToString:@"swipe_circle"] ) {
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.viewAlertSwipeFromCircle addGestureRecognizer:swipeLeft];

        [self fadeInAlertSwipeCircle];
        
    } else if ( [self.currentView isEqualToString:@"swipe_papr"] ) {
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.viewAlertSwipeFromPapr addGestureRecognizer:swipeLeft];
        
        [self fadeInAlertSwipePapr];
        
    } else if ( [self.currentView isEqualToString:@"internet"] ) {
        
        [self fadeInAlertInternet];
        
    }

}

#pragma mark - GESTURE METHODS

- (void) setupSwipeGestures {
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
}
- (void) swipeLeft : (id)sender {
    
    [self buExitNow : nil];
    
}

#pragma mark - FADE IN/OUT METHODS

- (void) fadeInAlertInternet {

    // SETUP FRAMES
    frameDestination = self.viewAlertInternetMessage.frame;
    int originY = frameDestination.origin.y - frameDestination.size.height - 2;
    frameOriginal = CGRectMake(frameDestination.origin.x, originY, frameDestination.size.width, frameDestination.size.height);
    self.viewAlertInternetMessage.frame = frameOriginal;

    // GET READY
    self.viewAlertInternet.alpha = 1.0;

    [UIView animateWithDuration: fadeInDuration
                     animations: ^{
                         self.viewAlertInternetMessage.frame = frameDestination;
                     } completion: ^(BOOL finished){
                         [self performSelector:@selector(fadeOutAlertInternet) withObject:nil afterDelay:0.75];
                     }
     ];
    
}
- (void) fadeOutAlertInternet {
    
    // GET READY
    self.viewAlertInternet.alpha = 1.0;
    
    [UIView animateWithDuration: fadeInDuration
                     animations: ^{
                         self.viewAlertInternetMessage.frame = frameOriginal;
                     } completion: ^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popPaprAlertVC" object:nil];
                     }
     ];

}
- (void) fadeInAlertLocation {
    
    [UIView animateWithDuration: fadeInDuration
                     animations: ^{
                        self.viewBG.alpha = 0.5;
                        self.viewAlertLocation.alpha = 1.0;
                     } completion: ^(BOOL finished){
                         // [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5.0];
                     }
     ];
    
}
- (void) fadeInAlertSwipeCircle {
    
    [UIView animateWithDuration: fadeInDuration
                     animations: ^{
                         self.viewBG.alpha = 0.75;
                         self.viewAlertSwipeFromCircle.alpha = 1.0;
                     } completion: ^(BOOL finished){
                         // [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5.0];
                     }
     ];
    
}
- (void) fadeInAlertSwipePapr {
    
    [UIView animateWithDuration: fadeInDuration
                     animations: ^{
                         self.viewBG.alpha = 0.5;
                         self.viewAlertSwipeFromPapr.alpha = 1.0;
                     } completion: ^(BOOL finished){
                         // [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5.0];
                     }
     ];
    
}
- (void) fadeOut {
    
    iAmFadingMessage = TRUE;
    
    [self fadeOutGradientWithDuration:1.5 * messageExpeditor];
    [self fadeOutTextWithDuration:2.0 * messageExpeditor];
    
}
- (void) fadeOutGradientWithDuration : (float)duration {
    
    /*
    float newOriginY = self.viewGradient.frame.origin.y + ([[UIScreen mainScreen] bounds].size.height / 7);
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         self.viewBG.alpha = 0.0;
                         self.viewGradient.alpha = 0.0;
                         self.viewGradient.frame = CGRectMake(self.viewGradient.frame.origin.x,
                                                              newOriginY,
                                                              self.viewGradient.frame.size.width,
                                                              self.viewGradient.frame.size.height);
                     } completion: ^(BOOL finished){
                         //
                     }
     ];
    */
    
}
- (void) fadeOutTextWithDuration : (float)duration {
    
    /*
    float newOriginY = self.labelGradientText.frame.origin.y + ([[UIScreen mainScreen] bounds].size.height / 7);
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         self.viewBG.alpha = 0.0;
                         self.labelGradientText.alpha = 0.0;
                         self.labelGradientText.frame = CGRectMake(self.labelGradientText.frame.origin.x,
                                                                   newOriginY,
                                                                   self.labelGradientText.frame.size.width,
                                                                   self.labelGradientText.frame.size.height);
                     } completion: ^(BOOL finished){
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popMMAlertVC" object:nil];
                         
                     }
     ];
    */
}

#pragma mark - VIEWS

- (void) popSelf {

    // DEPRECATED: PaprAlertVC.popSelf
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void) hideAllViews {

    self.viewBG.alpha = 0.0;
    self.viewAlertInternet.alpha = 0.0;
    self.viewAlertLocation.alpha = 0.0;
    self.viewAlertSwipeFromPapr.alpha = 0.0;
    self.viewAlertSwipeFromCircle.alpha = 0.0;

}

#pragma mark - IBACTION

- (IBAction) buAlertLocationAllow : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.setupUserLocation" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popPaprAlertVC" object:nil];

}
- (IBAction) buAlertLocationDontAllow : (id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popPaprAlertVC" object:nil];
    
}
- (IBAction) buScreenSelected : (id)sender {
    
    // ACTIVATE MESSAGE EXPEDITION SEQUENCE (THIS SOUNDS LIKE STAR TREK LINGO)
    
    if (iAmFadingMessage) {
        
        return;
        
    } else {
        
        messageExpeditor = 0.2;
        
        [self fadeOut];

    }
    
}
- (IBAction) buExitNow : (id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popPaprAlertVC" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
