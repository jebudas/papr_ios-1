//
//  PaprVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/21/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "PaprItemVC.h"
#import "PaprWelcomeVC.h"
#import "PaprAccomplishmentVC.h"
// API
#import "APIController+Paprboy.h"
#import "APIController+Statistics.h"
#import "APIController+User.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"


@interface PaprVC : UIViewController <UIScrollViewDelegate> {

    CGFloat screenWidth;

    int totalViews;
    BOOL scrollViewIsMoving;

    int scrollAttempts;

    
}


@property (nonatomic, strong) UIScrollView *scrollViewPapr;
@property (nonatomic, strong) NSMutableArray *arrayOfPaprs;
@property (nonatomic, strong) NSArray *arrayOfSubscriptions;
@property (nonatomic, strong) PaprWelcomeVC *paprWelcomeVC;
@property (nonatomic, strong) PaprAccomplishmentVC *paprAccomplishmentVC;



@end
