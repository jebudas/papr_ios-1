//
//  PaprUserNotificationsVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController+User.h"
#import "APIController+Comments.h"
// TABLE
#import "PaprUserNotificationsCell.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"



@interface PaprUserNotificationsVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    //
}


@property (nonatomic, strong) NSDictionary *notificationDictionary;
@property (nonatomic, strong) NSArray *arrayOfNotifications;
@property (nonatomic, weak) IBOutlet UITableView *tableViewNotifications;
@property (nonatomic, weak) IBOutlet UIView *viewSpinner;



@end
