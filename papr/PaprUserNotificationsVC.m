//
//  PaprUserNotificationsVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprUserNotificationsVC.h"

@interface PaprUserNotificationsVC ()

@end

@implementation PaprUserNotificationsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getNotificationa];

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
    
    return self.arrayOfNotifications.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[DataController dc] returnRelativeSizeForThisScreen:70];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *thisNotificationDictionary = [self.arrayOfNotifications objectAtIndex: indexPath.row ];
    
    return [self returnPaprUserNotificationsCell : thisNotificationDictionary : indexPath];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"self.arrayOfNotifications = %@", [self.arrayOfNotifications objectAtIndex:indexPath.row]);
    
    return;
    
}
- (PaprUserNotificationsCell *) returnPaprUserNotificationsCell : (NSDictionary *)thisNotificationDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprUserNotificationsCell *cell = [self.tableViewNotifications dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprUserNotificationsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"thisNotificationDictionary = %@", thisNotificationDictionary);
    
    NSURL *imageURL = [NSURL URLWithString:[thisNotificationDictionary objectForKey:@"friend_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.labelText.attributedText = [self returnNotificationLabelFromDictionary:thisNotificationDictionary];
    cell.labelTime.text = [[DataController dc] returnHumanDateString:[thisNotificationDictionary objectForKey:@"timestamp"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprNotificationsVC . tableViewReload");
    [self.tableViewNotifications reloadData];
    
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
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] range:NSMakeRange(0, username.length)];
    
    
    
    return attributedString;
    
}

#pragma mark - API METHODS

- (void) getNotificationa {
    
    __weak PaprUserNotificationsVC *weakSelf = self;
    
    [[APIController api] getNotifications:^(NSDictionary *responseDictionary) {

        NSLog(@"PaprNotificationVC . getNotificationsWithDictionary . responseDictionary = %@", responseDictionary);

        weakSelf.arrayOfNotifications = [[NSArray alloc] initWithArray: [responseDictionary objectForKey:@"notifications"] ];
        
        [DataController dc].currentNotificationCount = 0;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprCellHeader.updateNotificationButton" object:nil];

        self.viewSpinner.alpha = 0.0;
        
        [weakSelf tableViewReload];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprNotificationVC . getNotificationsWithDictionary . error = %@", error);
        
    }];
    
}

- (IBAction) buXSelected : (id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprUserNotificationsVC" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
