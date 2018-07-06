//
//  PaprTableVC.h
//  papr
//
//  Created by Brian WF Tobin on 2/14/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "PaprTableCell.h"
// API
#import "APIController+Statistics.h"
// TOOLS
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// SAFARI
@import SafariServices;


@interface PaprTableVC : UIViewController <UITableViewDelegate, UITableViewDataSource, PaprTableCellDelegate> {

    //
    
}


@property (nonatomic, assign) int paprTag;
@property (nonatomic, strong) NSArray *arrayOfPaprArticles;
@property (nonatomic, strong) NSDictionary *paprDictionary;
@property (nonatomic, weak) IBOutlet UITableView *tableViewPapr;



@end
