//
//  PaprWelcomeVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprWelcomeVC.h"

@interface PaprWelcomeVC ()

@end

@implementation PaprWelcomeVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self setupNotifications];
    
    [self setupCircleAnimation];

    [self setupSwipeGestures];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.labelWelcome.text = self.stringHeader;

    self.viewStats.alpha = 0.0;
    
    [self setupViewStatistics];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    // DEPRECATED
    // [self performSelector:@selector(swipeAlert) withObject:nil afterDelay:7.0];

}

- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(circleAnimationStart) name:@"PaprWelcomeVC.circleAnimationStart" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprWelcomeVC.circleAnimationStart" object:nil];
    
}
- (void) setupViewStatistics {
    
    NSArray *freshPosts = [[DataController dc] returnMyActivePaprItems];
    
    NSDictionary *statPostDictionary = [[NSDictionary alloc] initWithDictionary: [freshPosts lastObject] ];

    [self getStatsForPostWithDictionary : statPostDictionary];
    
}

#pragma mark - GESTURE METHODS

- (void) setupSwipeGestures {
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
//    CGPoint touchLocation = [touch locationInView:self.view];
//    
//    if (touchLocation.x > 30) {
//        cellShouldOpen = TRUE;
//    } else {
//        cellShouldOpen = FALSE;
//    }
//    
    return YES;
    
    
}
- (void) swipeLeft : (id)sender {
    
    [self buContinueSelected : nil];
    
}
- (void) swipeAlert {

    // DEPRECATED
    // NSDictionary *alertDictionary = @{@"alert_type":@"swipe_circle"};
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprAlertVC" object:nil userInfo:alertDictionary];

}

#pragma mark - CIRCLE && VIEW ANIMATIONS

- (void) setupCircleAnimation {
    
    NSLog(@"PaprWelcomeVC . setupCircleAnimation . START");

    paprCounter = 0;
    
    NSArray *userSubscriptions = [[DataController dc] returnUserSubscriptions];
    
    paprCounterFinal = (int)userSubscriptions.count;
    
    circleAnimationDuration = 3.0;

    if (paprCounterFinal > 1) {

        paprCounterDuration = circleAnimationDuration / (float)paprCounterFinal;

        self.labelPaprCounter.alpha = 0.0;
        self.labelPaprCounterNew.alpha = 0.0;
        
    } else {
    
        NSLog(@"PaprWelcomeVC . setupCircleAnimation . ERROR: NO PAPRS!!");
        
    }
    
    
    
}
- (void) circleAnimationStart {

    [CATransaction begin]; {

        [CATransaction setCompletionBlock:^{
            [self circleAnimationComplete];
        }];
        
        float radius = 0;
        float bump = 0;
        float lineWidth = 0;

        if ([[UIScreen mainScreen] bounds].size.width < 321) {
            radius = 85.333;
            bump = 5.12;
            lineWidth = 64;
        } else if ([[UIScreen mainScreen] bounds].size.width < 376) {
            radius = 100;
            bump = 6;
            lineWidth = 66; // WAS 75, ADJUST
        } else if ([[UIScreen mainScreen] bounds].size.width < 415) {
            radius = 110.4;
            bump = 6.624;
            lineWidth = 82.8;
        }

        // Set up the shape of the circle
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius].CGPath;
        // Center the shape in self.viewCircleAnimation
        // circle.position = CGPointMake(CGRectGetMidX(self.viewCircleAnimation.frame)-radius, CGRectGetMidY(self.viewCircleAnimation.frame)-radius);
        circle.position = CGPointMake(([[UIScreen mainScreen] bounds].size.width / 4)-bump,([[UIScreen mainScreen] bounds].size.width / 4)-bump);
        // Configure the apperence of the circle
        circle.fillColor = [UIColor clearColor].CGColor;
        circle.strokeColor = [UIColor paprPink].CGColor;
        circle.lineWidth = lineWidth;
        
        // Add to parent layer
        [self.viewCircleAnimation.layer addSublayer:circle];
        
        // Configure animation
        CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimation.duration            = circleAnimationDuration;
        drawAnimation.repeatCount         = 1.0;
        
        // Animate from no part of the stroke being drawn to the entire stroke being drawn
        drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
        
        // Experiment with timing to get the appearence to look the way you want
        drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        // Add the animation to the circle
        [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

    }
    
    [CATransaction commit];
    
    
}
- (void) circleAnimationComplete {

    NSLog(@"circleAnimationComplete . arrayOfSubscriptions.count = ???");

    if ([DataController dc].iUpdatedMySubscriberList) {

        // TURN THIS OFF TO AVOID TROUBLE
        [DataController dc].iUpdatedMySubscriberList = FALSE;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.updateSubscriptionCountForWelcomePage" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprProgress" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToCurrentPapr" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprTabBar" object:nil];

    } else {

        self.buContinue.alpha = 1.0;
        
        //  self.imageViewRedCircle.image = [UIImage imageNamed:@"welcome_circle_red_check.png"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.updateSubscriptionCountForWelcomePage" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprTabBar" object:nil];

    }
    
}
- (void) updateSubscriptionCount : (int)countRCVD {

    self.labelPaprCounter.alpha = 1.0;
    self.labelPaprCounterNew.alpha = 1.0;
    
    self.labelPaprCounter.text = [NSString stringWithFormat:@"%i", countRCVD];
    
}
- (void) updateLabelStatsViews : (NSString *)viewsRCVD {

    [DataController dc].currentPaprViewsCount = [viewsRCVD intValue];
    
    if ([DataController dc].currentPaprViewsCount > 0) {
    
        self.labelStatsViews.text = [NSString stringWithFormat:@"%i views", [DataController dc].currentPaprViewsCount];
        
        self.viewStats.alpha = 1.0;
        
    }
    
}
- (void) getStatsForPostWithDictionary : (NSDictionary *)statsRCVD {

    // GGXGG
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [statsRCVD objectForKey:@"post_id"], @"post_id",
                                [[DataController dc] returnMyUserID], @"publisher_id",
                                nil];

    [[APIController api] getStats:parameters success:^(NSDictionary *responseDictionary) {
        
        NSDictionary *statsDictionary = [[NSDictionary alloc] initWithDictionary: [[responseDictionary objectForKey:@"item_stats_dictionary"] objectForKey:@"STATS"] ];
        
        NSLog(@"PaprWelcomeVC . getStatsForPostWithDictionary . success = %@", statsDictionary);
        
        [self updateLabelStatsViews : [statsDictionary objectForKey:@"views"] ];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprWelcomeVC . getStatsForPostWithDictionary . error = %@", error);
        
    }];
    
}

- (IBAction) buContinueSelected : (id)sender {

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprProgress" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToFirstPapr" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.checkForNotifications" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
