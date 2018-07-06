//
//  PaprProfileFollowingVC.h
//  papr
//
//  Created by Brian WF Tobin on 12/20/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "APIController+User.h"
#import "APIController+Comments.h"
// TABLE
#import "SearchCellAccount.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"



@interface PaprProfileFollowingVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    //
}


@property (nonatomic, strong) NSDictionary *followingDictionary;
@property (nonatomic, strong) NSArray *arrayOfAccounts;
@property (nonatomic, assign) BOOL thisIsFollowing;
@property (nonatomic, weak) IBOutlet UITableView *tableViewFollowing;
@property (nonatomic, weak) IBOutlet UIView *viewSpinner;
@property (nonatomic, weak) IBOutlet UILabel *labelHeader;


@end
