//
//  PaprProfilePreVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProfilePreVC.h"

@interface PaprProfilePreVC ()

@end

@implementation PaprProfilePreVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupSwipeGestures];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.viewBG.alpha = 0.0;
    self.viewOptions.alpha = 0.0;

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [self animateBG];
    
}

#pragma mark - GESTURE METHODS

- (void) setupSwipeGestures {
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];
    
}
- (void) swipeUp : (id)sender {
    
    [self animateOptionsOUT : @"cancel"];

}

#pragma mark - ANIMATE METHODS

- (void) animateOptionsIN {
    
    frameOptionsIN = self.viewOptions.frame;
    
    float originOffsetY = 0 - self.viewOptions.frame.size.height - 2; // -2 bc padding = safety.
    
    self.viewOptions.frame = CGRectMake(self.viewOptions.frame.origin.x,originOffsetY,self.viewOptions.frame.size.width,self.viewOptions.frame.size.height);
    frameOptionsOUT = self.viewOptions.frame;
    
    self.viewOptions.alpha = 1.0;
    
    [UIView animateWithDuration: 0.25
                     animations: ^{
                         self.viewOptions.frame = frameOptionsIN;
                     } completion: ^(BOOL finished){
                         //
                     }
     ];
    
}
- (void) animateOptionsOUT : (NSString *)destinationRCVD {
    
    [UIView animateWithDuration: 0.10
                     animations: ^{
                     
                         if ([destinationRCVD isEqualToString:@"cancel"]) {
                             self.viewBG.alpha = 0.0;
                             self.viewOptions.frame = frameOptionsOUT;
                         } else {
                             self.viewOptions.frame = frameOptionsOUT;
                         }

                     } completion: ^(BOOL finished){

                         if ([destinationRCVD isEqualToString:@"profile"]) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileForUser" object:nil];
                         } else if ([destinationRCVD isEqualToString:@"saved_posts"]) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprSavedPostsVC" object:nil];
                         } else if ([destinationRCVD isEqualToString:@"notifications"]) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprUserNotificationsVC" object:nil];
                         } else if ([destinationRCVD isEqualToString:@"cancel"]) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprProfilePreVC" object:nil];
                         }

                     }
     ];
    
}
- (void) animateBG {

    [UIView animateWithDuration: 0.10
                     animations: ^{
                         self.viewBG.alpha = 0.70;
                     } completion: ^(BOOL finished){
                         [self animateOptionsIN];
                     }
     ];
    
}

#pragma mark - IBACTION METHODS

- (IBAction) buProfileSelected : (id)sender {

    NSLog(@"buProfileSelected");

    [self animateOptionsOUT : @"profile"];

}
- (IBAction) buSavedPostsSelected : (id)sender {
    
    NSLog(@"buSavedPostsSelected");
    
    [self animateOptionsOUT : @"saved_posts"];
    
}
- (IBAction) buCommentSelected : (id)sender {

    [self animateOptionsOUT : @"notifications"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
