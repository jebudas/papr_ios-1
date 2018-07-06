//
//  PaprProfileFollowingVC.m
//  papr
//
//  Created by Brian WF Tobin on 12/20/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProfileFollowingVC.h"

@interface PaprProfileFollowingVC ()

@end

@implementation PaprProfileFollowingVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.thisIsFollowing) {

        [self getFollowing : [[DataController dc] returnUserSubscriptions] ];

        self.labelHeader.text = @"Following";

    } else {

        [self getFollowers];
        self.labelHeader.text = @"Followers";
    }
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFooter = [[UIView alloc] init];
    viewFooter.backgroundColor = [UIColor clearColor];
    return viewFooter;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"self.arrayOfAccounts.count = %i", (int)self.arrayOfAccounts.count);
    return self.arrayOfAccounts.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[DataController dc] returnRelativeSizeForThisScreen : 65];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *thisFollowingDictionary = [self.arrayOfAccounts objectAtIndex: indexPath.row ];
    
    return [self returnSearchCellAccount : thisFollowingDictionary : indexPath];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"self.arrayOfAccounts = %@", [self.arrayOfAccounts objectAtIndex:indexPath.row]);
    
    return;
    
}
- (SearchCellAccount *) returnSearchCellAccount : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    SearchCellAccount *cell;
        cell = [self.tableViewFollowing dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCellAccount" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *cellHeaderDictionary = [thisCellDictionary objectForKey:@"EDITION_HEADER"];
    
    NSURL *imageURL = [NSURL URLWithString:[cellHeaderDictionary objectForKey:@"edition_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.cellDictionary = thisCellDictionary;
    cell.labelPublisher.text = [cellHeaderDictionary objectForKey:@"edition_display_name"];
    cell.labelUsername.text = [NSString stringWithFormat:@"@%@", [cellHeaderDictionary objectForKey:@"user_username"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    if (self.thisIsFollowing) {
        // SHOW FOLLOW BUTTON (DEFAULT)
    } else {
        // HIDE FOLLOW BUTTON
        cell.buFollow.alpha = 0.0;
    }
    
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}

- (void) tableViewReload {
    
    NSLog(@"PaprProfileFollowingVC . tableViewReload");
    [self.tableViewFollowing reloadData];
    
}
- (NSAttributedString *) returnNotificationLabelFromDictionary : (NSDictionary *)dictionaryRCVD {
    
    NSString *notificationText;
    NSString *username = [dictionaryRCVD objectForKey:@"friend_username"];
    NSString *notificationType = [dictionaryRCVD objectForKey:@"type_field"];
    
    if ( [notificationType isEqualToString:@"comments"] ) {
        
        notificationText = [NSString stringWithFormat:@"%@ left a comment on your post.", username];
        
    } else if ( [notificationType isEqualToString:@"followers"] ) {
        
        notificationText = [NSString stringWithFormat:@"%@ started following you.", username];
        
    } else if ( [notificationType isEqualToString:@"likes"] ) {
        
        notificationText = [NSString stringWithFormat:@"%@ liked your post.", username];
        
    } else if ( [notificationType isEqualToString:@"reposts"] ) {
        
        notificationText = [NSString stringWithFormat:@"%@ reposted your post.", username];
        
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: notificationText ];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlackHero] range:NSMakeRange(0, username.length)];
    
    return attributedString;
    
}

#pragma mark - API METHODS

- (void) getFollowing : (NSArray *)userSubscriptionArray {
    
    __weak PaprProfileFollowingVC *weakSelf = self;

    // RETURN WALL
    if (userSubscriptionArray.count < 1) { return; }
    // RETURN WALL
    
    NSDictionary *subscriptionDictionary = @{@"user_subscriptions" : userSubscriptionArray};

    [[APIController api] getMyFollowing:subscriptionDictionary success:^(NSDictionary *responseDictionary) {
        
        weakSelf.arrayOfAccounts = [[DataController dc] returnArrayFromOptionsArray: [responseDictionary objectForKey:@"user_subscriptions"] ];

        self.viewSpinner.alpha = 0.0;
        
        [weakSelf tableViewReload];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprProfileFollowingVC . getFollowing . error = %@", error);
        
    }];
    
}
- (void) getFollowers {
    
    __weak PaprProfileFollowingVC *weakSelf = self;
    
    NSArray *userSubscriptionArray = [[DataController dc] returnUserSubscriptions];
    
    // RETURN WALL
    if (userSubscriptionArray.count < 1) { return; }
    // RETURN WALL
    
    NSDictionary *idDictionary = @{@"publisher_id" : [[DataController dc] returnMyUserID]};

    [[APIController api] getMyFollowers:idDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprMoreVC . getMyFollowers . responseDictionary = %@", responseDictionary);
        
        NSArray *arrayOfFollowers = [[NSArray alloc] initWithArray: [[responseDictionary objectForKey:@"item_dictionary"] objectForKey:@"SUBSCRIBERS"] ];
        
        [self getFollowing : arrayOfFollowers ];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprProfileFollowingVC . getFollowing . error = %@", error);
        
    }];
    
}

- (IBAction) buXSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprProfileFollowingVC" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
