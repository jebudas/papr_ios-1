//
//  LoginSelectionVC.h
//  papr
//
//  Created by Brian WF Tobin on 8/18/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "LoginSelectionCell.h"
// API
#import "APIController+User.h"
// AK
#import <AccountKit/AccountKit.h>
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"

@interface LoginSelectionVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {

    //

}

@property (nonatomic, strong) NSMutableArray *arrayOfSubscriptions;
@property (nonatomic, strong) NSMutableArray *arrayOfSubscriptionsSelected;
@property (nonatomic, strong) NSDictionary *subscriptionDictionary;
// IBOUTLET
@property (nonatomic, weak) IBOutlet UITableView *tableViewSubscriptions;
@property (nonatomic, weak) IBOutlet UIButton *buNext;
@property (nonatomic, weak) IBOutlet UIView *viewManifesto;
@property (nonatomic, weak) IBOutlet UIButton *buManifestoContinue;

@end

