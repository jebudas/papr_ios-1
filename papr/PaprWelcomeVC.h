//
//  PaprWelcomeVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "UIColor+PAPRColor.h"
// API
#import "APIController+Statistics.h"


@interface PaprWelcomeVC : UIViewController {

    int paprCounter;
    int paprCounterFinal;
    float paprCounterDuration;

    float circleAnimationDuration;
    
}

@property (nonatomic, strong) NSString *stringHeader;
@property (nonatomic, weak) IBOutlet UILabel *labelWelcome;
@property (nonatomic, weak) IBOutlet UIView *viewCircleAnimation;
@property (nonatomic, weak) IBOutlet UILabel *labelPaprCounter;
@property (nonatomic, weak) IBOutlet UILabel *labelPaprCounterNew;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewRedCircle;
@property (nonatomic, weak) IBOutlet UIButton *buContinue;
// STATS
@property (nonatomic, weak) IBOutlet UIView *viewStats;
@property (nonatomic, weak) IBOutlet UILabel *labelStatsViews;

- (void) updateSubscriptionCount : (int)countRCVD;

@end
