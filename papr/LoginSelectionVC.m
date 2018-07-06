//
//  LoginSelectionVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/18/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "LoginSelectionVC.h"

@interface LoginSelectionVC ()

@end

@implementation LoginSelectionVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.arrayOfSubscriptionsSelected = [[NSMutableArray alloc] init];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

     self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);


    self.buManifestoContinue.layer.masksToBounds = YES;
    self.buManifestoContinue.layer.cornerRadius = 5;

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self getSignupSubscriptions];

    // [self pushLocationRequest];
    
}

#pragma mark - LOCATION METHODS

- (void) pushLocationRequest {
    
    NSDictionary *alertDictionary = @{@"alert_type":@"location"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprAlertVC" object:nil userInfo:alertDictionary];
    
}

#pragma mark - UITableView METHODS

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
    
    return 50;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,100)];
    return viewFooter;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.arrayOfSubscriptions.count > 0) {
        return self.arrayOfSubscriptions.count;
    } else {
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int indexPathRow = (int)indexPath.row;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", indexPathRow];
    // static NSString *cellIdentifier = @"cellIdentifier";
    LoginSelectionCell *cell = [self.tableViewSubscriptions dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginSelectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSubscriptions objectAtIndex:indexPathRow] ];
    cell.labelSubscription.text = [cell.cellDictionary objectForKey:@"display_title"];
    cell.labelUsername.text = [NSString stringWithFormat:@"@%@", [cell.cellDictionary objectForKey:@"source"] ];

    NSURL *imageURL = [NSURL URLWithString:[cell.cellDictionary objectForKey:@"image_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    
    [cell.imageViewSubscription setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        cell.imageViewSubscription.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    [cell setTag:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;

    NSString *subscription_id = [cell.cellDictionary objectForKey:@"PUBLISHER_ID"];
    if ([self.arrayOfSubscriptionsSelected containsObject:subscription_id]) {
        // cell.imageViewFollow.image = [UIImage imageNamed:@"follow_icon_on.png"];
    } else {
        // cell.imageViewFollow.image = [UIImage imageNamed:@"follow_icon_off.png"];
    }
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    int indexPathRow = (int)indexPath.row;
//    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSubscriptions objectAtIndex:indexPathRow] ];
//    NSString *subscription_id = [cellDictionary objectForKey:@"PUBLISHER_ID"];
//
//    [self sendSubscriptionToManager:subscription_id withIndexPath:indexPath];

}
- (void) tableViewReload {
    
    NSLog(@"LoginSelectionVC . tableViewReload");
    [self.tableViewSubscriptions reloadData];
    
}

#pragma mark - API METHODS

- (void) getSignupSubscriptions {
    
    __weak LoginSelectionVC *weakSelf = self;

    [[APIController api] getSignupSubscriptions:nil success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"LoginSelectionVC . getSignupSubscriptions . success = %@", responseDictionary);
        
        weakSelf.arrayOfSubscriptions = [[NSMutableArray alloc] initWithArray:[responseDictionary objectForKey:@"subscriptionDictionary"]];
        
        [weakSelf performSelectorOnMainThread:@selector(tableViewReload) withObject:nil waitUntilDone:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"LoginSelectionVC . getSignupSubscriptions . error = %@", error);
        
    }];
    
}


#pragma mark - IBACTION & RELATED METHODS/TOOLS

- (IBAction) buContinueSelected : (id)sender {

    if ([[DataController dc] returnUserSubscriptions].count >= 3) {
    
        [self updateUserThenShowManifesto];
        
    } else {
    
        [self pushAlertControllerForInsufficientSubscriptions];
        
    }
    
}
- (void) showManifesto {
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.viewManifesto.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         //
                     }];

}
- (IBAction) buManifestoContinueSelected : (id)sender {
    
    // POP LOGIN, GO TO PAPR
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRootAfterLogin" object:nil];
    
}
- (void) pushAlertControllerForInsufficientSubscriptions {
    
    // UIALERT . ACTIONSHEET
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:@"Please selext at least 3 publishers."
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    
    [actionSheet addAction:actionCancel];
    
    [self.view.window.rootViewController presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void) updateUserThenShowManifesto {

    NSDictionary *myUserDictionary = [[NSDictionary alloc] initWithDictionary:[[DataController dc] returnMyUserDictionary] ];

    [[APIController api] updateUser:myUserDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"LoginSelectionVC . updateUserThenShowManifesto . success = %@", responseDictionary);
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            [self showManifesto];
            
        } else {

            [DataController dc].userNeedsUpdate = TRUE;

        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"LoginSelectionVC . updateUserThenShowManifesto . failure . error = %@", error);
        
    }];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
