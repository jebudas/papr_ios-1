//
//  PaprPostEditVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// POST
#import "PaprCellHeaderPost.h"
#import "PaprCellFull.h"
#import "PaprCellPhoto.h"
#import "PaprCellText.h"
// AUTRE
#import "UIImageView+AFNetworking.h"

@interface PaprPostEditVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    BOOL iHaveEditedMyPapr;
    
}

@property (nonatomic, assign) BOOL weAreAtMaximum;
@property (nonatomic, strong) NSArray *arrayOfPaprItems;
@property (nonatomic, strong) NSDictionary *paprDictionary;
// IBOUTLET
@property (nonatomic, weak) IBOutlet UIView *viewMaximum;
@property (nonatomic, weak) IBOutlet UITableView *tableViewEditPapr;


@end
