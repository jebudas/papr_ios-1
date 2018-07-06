//
//  PaprPostPreviewVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// POST
#import "PaprPostCreateVC.h"
#import "PaprPostEditVC.h"
#import "PaprCellHeaderPost.h"
#import "PaprCellFull.h"
#import "PaprCellPhoto.h"
#import "PaprCellText.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"
// API
#import "APIController+User.h"


@interface PaprPostPreviewVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    BOOL fullHeaderIsOn;
    BOOL fullHeaderIsOff;
    
    int cellFontSize;
    int cellHeightHeader;
    int cellHeightContentFull;
    int cellHeightContentNormal;
    
}

@property (nonatomic, strong) NSArray *arrayOfPaprItems;
@property (nonatomic, strong) NSDictionary *paprDictionary;
// PUSH & POP
@property (nonatomic, strong) PaprPostCreateVC *paprPostCreateVC;
@property (nonatomic, strong) PaprPostEditVC *paprPostEditVC;
// IBOUTLET
@property (nonatomic, weak) IBOutlet UIView *viewEmptyPapr;
@property (nonatomic, weak) IBOutlet UILabel *labelEmptyPapr;
@property (nonatomic, weak) IBOutlet UITableView *tableViewPreviewPapr;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewCheckmark;


@end
