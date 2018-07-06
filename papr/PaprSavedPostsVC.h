//
//  PaprSavedPostsVC.h
//  papr
//
//  Created by Brian WF Tobin on 10/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// TABLE
#import "PaprSavedPostsCell.h"
// API
#import "APIController+Paprboy.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"
// SAFARI
@import SafariServices;


@interface PaprSavedPostsVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    //
}


@property (nonatomic, strong) NSArray *arrayOfSavedPosts;
@property (nonatomic, weak) IBOutlet UITableView *tableViewSavedPosts;
@property (nonatomic, weak) IBOutlet UIView *viewSpinner;




@end
