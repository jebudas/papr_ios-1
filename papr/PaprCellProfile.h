//
//  PaprCellProfile.h
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"
#import "APIController+User.h"

@interface PaprCellProfile : UITableViewCell {
    
    BOOL iAmSubscribedToThisAccount;
    
}

@property (nonatomic, assign) BOOL thisIsMe;
@property (nonatomic, strong) NSString *thisID;
@property (nonatomic, weak) IBOutlet UIView *viewStats;
@property (nonatomic, weak) IBOutlet UILabel *labelPosts;
@property (nonatomic, weak) IBOutlet UILabel *labelFollowers;
@property (nonatomic, weak) IBOutlet UILabel *labelFollowing;
@property (nonatomic, weak) IBOutlet UILabel *labelName;
@property (nonatomic, weak) IBOutlet UILabel *labelBlurb;
@property (nonatomic, weak) IBOutlet UILabel *labelWebsiteURL;

@property (nonatomic, weak) IBOutlet UIButton *buURL;
@property (nonatomic, weak) IBOutlet UIButton *buFollowSettings;

- (void) setupButtons;
- (void) setupLabels;

@end
