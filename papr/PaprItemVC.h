//
//  PaprItemVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "PaprCellHeader.h"

#import "PaprCellFull.h"

#import "PaprCellHeroFull01.h"
#import "PaprCellHeroFull02.h"
#import "PaprCellHeroFull03.h"
#import "PaprCellHeroFull04.h"
#import "PaprCellText01.h"
#import "PaprCellText02.h"
#import "PaprCellText03.h"
#import "PaprCellText04.h"

#import "PaprCellText.h"
#import "PaprCellPhoto.h"
#import "UIImageView+AFNetworking.h"
// API
#import "APIController+Statistics.h"
// AUTRE
#import "UIColor+PAPRColor.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// SAFARI
@import SafariServices;


@interface PaprItemVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {

    // TABLEVIEW + HERO VARIABLES
    int screenHeight;
    int cellFontSizeHero;
    int cellFontSizeNormal;
    int cellHeroImageWidth;
    int cellHeroImageHeight;
    int cellHeroHeight;
    int cellHeroHeight_01;
    int cellHeroHeight_02;
    int cellHeroHeight_03;
    int cellHeroHeight_04;
    int cellNormalHeight;
    int cellNormalHeight_01;
    int cellNormalHeight_02;
    int cellNormalHeight_03;
    int cellNormalHeight_04;
    BOOL editionIsSerif;
    BOOL editionIsHeroText;

    // SWIPE VARIABLES
    int pageTotal;
    int pageCurrent;

    
    // STATISTICS
    BOOL iHaveSentStats;
    
    BOOL cellShouldOpen;
    
    BOOL fullHeaderIsOn;
    BOOL iHaveSetupThisProgressCircle;

    int cellHeightHeader;
    int cellHeroTextHeight;
    int cellTextWidth;
    int cellTextMarginTop;
    int cellTextMarginLeft;
    int cellHeroSubRemainder;
    int cellHeightContentNormal_01;
    int cellHeightContentNormal_02;
    int cellHeightContentNormal_03;

}

@property (nonatomic, assign) int paprTag;
@property (nonatomic, strong) NSArray *arrayOfPaprItems;
@property (nonatomic, strong) NSDictionary *paprDictionary;
@property (nonatomic, strong) NSMutableArray *arrayOfLineHints;
@property (nonatomic, strong) NSMutableArray *arrayOfHeroIndexes;
//
@property (nonatomic, weak) IBOutlet UIImageView *imageViewMast;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelPageCount;

// IBOUTLET
@property (nonatomic, weak) IBOutlet UITableView *tableViewPapr;

// METHODS
- (void) showTheBumpHintUp;



@end
