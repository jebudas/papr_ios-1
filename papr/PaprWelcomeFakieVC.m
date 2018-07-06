//
//  PaprWelcomeFakieVC.m
//  papr
//
//  Created by Brian WF Tobin on 11/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprWelcomeFakieVC.h"

@interface PaprWelcomeFakieVC ()

@end

@implementation PaprWelcomeFakieVC

- (void)viewDidLoad {

    [super viewDidLoad];

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self circleAnimationStart];
    
}

#pragma mark - CIRCLE && VIEW ANIMATIONS

- (void) circleAnimationStart {

    circleAnimationDuration = 16.0;

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
            lineWidth = 66;
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
    
    // RESTART CIRCLE

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
