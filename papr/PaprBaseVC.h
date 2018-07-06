//
//  PaprBaseVC.h
//  papr
//
//  Created by Brian WF Tobin on 2/7/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaprSourceCell.h"
#import "PaprTableVC.h"
#import "PaprCommentsVC.h"
#import "PaprNotificationsVC.h"
#import "PaprPlusVC.h"
#import "PaprProfilesVC.h"
#import "PaprPostSignupVC.h"
// API
#import "APIController+Comments.h"
#import "APIController+Paprboy.h"
#import "APIController+Statistics.h"
#import "APIController+User.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// HELPERS
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"
#import "LXReorderableCollectionViewFlowLayout.h"

@interface PaprBaseVC : UIViewController <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout> {
    
    int paprIndexCounter;
    int paprSubscriptionCounter;
    BOOL loadingTimerWasStarted;

    CGRect frameLeft;
    CGRect frameCenter;
    CGRect frameRight;
    
    int originalToIndex;
    int originalFromIndex;
    int postEditingIndex;
    BOOL userIsEditing;
    BOOL paprsBeMoving;
    
}


@property (nonatomic, strong) NSArray *arrayOfUserSubscriptions;
@property (nonatomic, strong) NSMutableArray *arrayOfPaprs;
@property (nonatomic, strong) NSMutableArray *arrayOfPaprCells;
@property (nonatomic, strong) NSMutableArray *arrayOfPaprViews;
@property (nonatomic, strong) PaprCommentsVC *paprCommentsVC;
@property (nonatomic, strong) PaprNotificationsVC *paprNotificationsVC;
@property (nonatomic, strong) PaprPlusVC *paprPlusVC;
@property (nonatomic, strong) PaprProfilesVC *paprProfilesVC;
@property (nonatomic, strong) PaprPostSignupVC *paprPostSignupVC;


// IBOUTLET
@property (nonatomic, weak) IBOutlet UIView *viewCenter;
@property (nonatomic, weak) IBOutlet UIView *viewEditingMode;
@property (nonatomic, weak) IBOutlet UIView *viewDragAndDrop;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionViewSource;
@property (nonatomic, weak) IBOutlet UIButton *buProfile;
@property (nonatomic, weak) IBOutlet UIButton *buNotifications;
@property (nonatomic, weak) IBOutlet UIButton *buPlus;
@property (nonatomic, weak) IBOutlet UIButton *buPost;

@end
