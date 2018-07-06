//
//  PaprAccomplishmentVC.m
//  papr
//
//  Created by Brian WF Tobin on 10/18/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprAccomplishmentVC.h"

@interface PaprAccomplishmentVC ()

@end

@implementation PaprAccomplishmentVC

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setupNotifications];

    [self setupSwipeGestures];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupViewPushSlider];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animatePushIN) name:@"PaprAccomplishmentVC.animatePushIN" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprAccomplishmentVC.animatePushIN" object:nil];
    
}
- (void) setupViewPushSlider {

    self.labelSettings.alpha = 0.0;

    framePushSliderORIG = self.viewPushSlider.frame;
    
}

#pragma mark - ANIMATION METHODS

- (void) animatePushIN {

    NSLog(@"animatePushIN");
    
    [UIView animateWithDuration: 1.2
                          delay: 0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         self.viewPushSlider.frame = CGRectMake(self.viewPushSlider.frame.origin.x,
                                                                self.viewPushSlider.frame.origin.y,
                                                                self.viewPushSlider.frame.size.width,
                                                                1);
                     } completion: ^(BOOL finished){
                         // [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5.0];
                     }
     ];

    
}
- (void) animatePushOUT {
    
    NSLog(@"animatePushOUT");

    [UIView animateWithDuration: 0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{

                         self.viewPushSlider.frame = framePushSliderORIG;
                     
                     } completion: ^(BOOL finished){
                     
                         [self animatePushSettings];
                     
                     }
     ];

}
- (void) animatePushSettings {

    self.labelSettings.alpha = 1.0;

    NSLog(@"animatePushSettings");
    
    [UIView animateWithDuration: 1.0
                          delay: 1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         self.labelSettings.alpha = 0.0;
                     } completion: ^(BOOL finished){
                         // [self performSelector:@selector(fadeOut) withObject:nil afterDelay:5.0];
                     }
     ];

}

#pragma mark - GESTURE METHODS

- (void) setupSwipeGestures {
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDown];

}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
    
}
- (void) swipeRight : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToRight" object:nil];
    
}
- (void) swipeDown : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfilePreVC" object:nil userInfo:nil];
    
}

#pragma mark - IBACTION METHODS

- (IBAction) buPushSelected : (id)sender {

    int pushDecision = (int)[sender tag];
    
    if (pushDecision == 0) {
    
        [self animatePushOUT];
        
    } else {
    
        // PUSH!
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
