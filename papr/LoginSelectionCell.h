//
//  LoginSelectionCell.h
//  papr
//
//  Created by Brian WF Tobin on 8/18/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"


@interface LoginSelectionCell : UITableViewCell {

    BOOL iHaveSetupButtons;

}

@property (nonatomic, strong) NSDictionary *cellDictionary;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewSubscription;
@property (nonatomic, weak) IBOutlet UILabel *labelSubscription;
@property (nonatomic, weak) IBOutlet UILabel *labelUsername;
@property (nonatomic, weak) IBOutlet UIButton *buAdd;
@property (nonatomic, weak) IBOutlet UIButton *buRemove;

- (void) setupButtons;
- (void) updateButton;

@end
