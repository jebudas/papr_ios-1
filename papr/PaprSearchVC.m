//
//  PaprSearchVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprSearchVC.h"

@interface PaprSearchVC ()

@end

@implementation PaprSearchVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // TODO GGXGG:
    // TO GET THE FEATURED ACCOUNTS, SEND SUBSCRIPTION LIST?
    // OR JUST RECEIVE SUBSCRIPTION LIST AND REMOVE FROM LIST IF ALREADY SUBSCRIBED?
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    self.buCancel.alpha = 0.0;
    self.viewSearch.alpha = 0.0;
    
    [self setupHeaderLabels];
    
    [self getFeaturedItems];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    frameTextFieldOriginal = self.textFieldSearch.frame;
    
}

- (void) setupHeaderLabels {
    
    // TODO GGXGG:
    // HIT DATACONTROLLER FOR Notification Status,
    // UPDATE IMAGE, LABELS BASED ON THAT.
    
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
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0,0,20,50)];
    return viewFooter;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (searchIsActive) {
    
        if (self.arrayOfSearchUsers.count > 0) {
            self.viewSearchEmpty.alpha = 0.0;
            return self.arrayOfSearchUsers.count;
        } else {
            self.viewSearchEmpty.alpha = 1.0;
            return 0;
        }
    
    } else {

        if (self.arrayOfFeatured.count > 0) {
            return self.arrayOfFeatured.count;
        } else {
            return 0;
        }

    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (searchIsActive) {
    
        return [[DataController dc] returnRelativeSizeForThisScreen : 65];

    } else {

        if (indexPath.row == 0) {
            
            NSDictionary *thisCellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfFeatured objectAtIndex:0] ];
            NSString *cellType = [thisCellDictionary objectForKey:@"type"];
            
            if ( [cellType isEqualToString:@"editor"] ) {
                
                if (editorCellIsOpen) {
                    return [[DataController dc] returnRelativeSizeForThisScreen : 410];
                } else {
                    return [[DataController dc] returnRelativeSizeForThisScreen : 250];
                }
                
            } else {
                
                return [[DataController dc] returnRelativeSizeForThisScreen : 65];
                
            }
            
        } else {
            
            return [[DataController dc] returnRelativeSizeForThisScreen : 65];
            
        }

    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (searchIsActive) {

        NSDictionary *thisCellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSearchUsers objectAtIndex:indexPath.row] ];

        return [self returnSearchCellAccount : thisCellDictionary : indexPath];

    } else {

        NSDictionary *thisCellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfFeatured objectAtIndex:indexPath.row] ];
        NSString *cellType = [thisCellDictionary objectForKey:@"type"];
        if ( indexPath.row == 0 && [cellType isEqualToString:@"editor"] ) {
            
            return [self returnSearchCellEditor : thisCellDictionary : indexPath];
            
        } else {
            
            return [self returnSearchCellAccount : thisCellDictionary : indexPath];
            
        }

    }
    
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // THIS WAS ADDED LATE, AFTER A CHANGE. THIS PREVENTS THE USER FROM SELECTING THE CELL TO VIEW THE PROFILE,
    if (indexPath.row != 0 || searchIsActive) {
        return;
    }
    
    if (searchIsActive) {

        NSDictionary *thisCellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSearchUsers objectAtIndex:indexPath.row] ];
        
        NSDictionary *editionHeaderDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 [thisCellDictionary objectForKey:@"publisher_avatar"], @"edition_avatar_url",
                                                 [thisCellDictionary objectForKey:@"publisher_display_name"], @"edition_display_name",
                                                 nil];
        
        [DataController dc].currentPaprDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     [thisCellDictionary objectForKey:@"user_fb_id"], @"PUBLISHER_ID",
                                                     editionHeaderDictionary, @"EDITION_HEADER",
                                                     nil];
        
        [self.textFieldSearch resignFirstResponder];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileVC" object:nil];

        
    } else {
    
        NSDictionary *thisCellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfFeatured objectAtIndex:indexPath.row] ];
        NSString *cellType = [thisCellDictionary objectForKey:@"type"];
        if ( indexPath.row == 0 && [cellType isEqualToString:@"editor"] ) {
            
            if (editorCellIsOpen) {

                NSLog(@"OPEN USER PROFILE");
            
                [self openUserProfile : [self.arrayOfFeatured objectAtIndex:indexPath.row] ];

            } else {
                
                NSLog(@"EXPAND CELL");
                
                editorCellIsOpen = TRUE;
                
                [self.tableViewFeatured beginUpdates];
                
                [self.tableViewFeatured reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.tableViewFeatured endUpdates];
                
            }
            
        } else {
            
            NSLog(@"OPEN USER PROFILE");
            
            [self openUserProfile : [self.arrayOfFeatured objectAtIndex:indexPath.row] ];

        }

    }

}
- (SearchCellEditor *) returnSearchCellEditor : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    SearchCellEditor *cell = [self.tableViewFeatured dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCellEditor" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // ACCOUNT TOP
    NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"editor_main_image_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewMain.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    if (editorCellIsOpen) {

        cell.buFollow.alpha = 1.0;
        
        cell.labelBlurb.alpha = 1.0;
        cell.labelPublisher.alpha = 1.0;
        cell.labelUsername.alpha = 1.0;
        cell.imageViewAvatar.alpha = 1.0;
        cell.buArroTop.alpha = 0.0;
        cell.buArroBottom.alpha = 1.0;
    
    } else {
    
        cell.buFollow.alpha = 0.0;
        
        cell.labelBlurb.alpha = 0.0;
        cell.labelPublisher.alpha = 0.0;
        cell.labelUsername.alpha = 0.0;
        cell.imageViewAvatar.alpha = 0.0;
        cell.buArroBottom.alpha = 0.0;
   
    }

    cell.cellDictionary = thisCellDictionary;
    cell.labelTitle.text = [thisCellDictionary objectForKey:@"editor_title"];
    cell.labelBlurb.text = [thisCellDictionary objectForKey:@"editor_blurb"];
    
    // ACCOUNT INFO
    NSURL *imageAvatarURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"publisher_avatar"]];
    NSURLRequest *imageAvatarURLRequest = [NSURLRequest requestWithURL:imageAvatarURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageAvatarURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.cellDictionary = thisCellDictionary;
    cell.labelPublisher.text = [thisCellDictionary objectForKey:@"publisher_display_name"];
    cell.labelUsername.text = [NSString stringWithFormat:@"@%@", [thisCellDictionary objectForKey:@"publisher_username"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (SearchCellAccount *) returnSearchCellAccount : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    SearchCellAccount *cell;
    
    if (searchIsActive) {
        cell = [self.tableViewSearch dequeueReusableCellWithIdentifier:cellIdentifier];
    } else {
        cell = [self.tableViewFeatured dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCellAccount" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"publisher_avatar"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.cellDictionary = thisCellDictionary;
    cell.labelPublisher.text = [thisCellDictionary objectForKey:@"publisher_display_name"];
    cell.labelUsername.text = [NSString stringWithFormat:@"@%@", [thisCellDictionary objectForKey:@"publisher_username"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprSearchVC . tableViewReload");
    
    if (searchIsActive) {

        [self.tableViewSearch reloadData];

    } else {
    
        [self.tableViewFeatured reloadData];
    
    }

}
- (void) searchModeStart {
    
    float newWidth = self.textFieldSearch.frame.size.width * 0.825;
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         
                         self.buCancel.alpha = 1.0;
                         self.viewSearch.alpha = 1.0;
                         
                         self.textFieldSearch.frame = CGRectMake(self.textFieldSearch.frame.origin.x,
                                                                 self.textFieldSearch.frame.origin.y,
                                                                 newWidth,
                                                                 self.textFieldSearch.frame.size.height);
                         
                         
                     } completion: ^(BOOL finished){
                         
                         searchIsActive = TRUE;

                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hidePaprTabBar" object:nil];

                     }
     ];
    
}
- (void) searchModeStop {
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         
                         self.buCancel.alpha = 0.0;
                         self.viewSearch.alpha = 0.0;

                         self.textFieldSearch.text = @"";
                         self.textFieldSearch.frame = frameTextFieldOriginal;
                         
                     } completion: ^(BOOL finished){

                         searchIsActive = FALSE;
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprTabBar" object:nil];

                     }
     ];
    
}
- (void) openUserProfile : (NSDictionary *)profileDictionaryRCVD {

    NSDictionary *editionHeaderDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [profileDictionaryRCVD objectForKey:@"publisher_avatar"], @"edition_avatar_url",
                                             [profileDictionaryRCVD objectForKey:@"publisher_display_name"], @"edition_display_name",
                                             nil];
    
    [DataController dc].currentPaprDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                 [profileDictionaryRCVD objectForKey:@"PUBLISHER_ID"], @"PUBLISHER_ID",
                                                 editionHeaderDictionary, @"EDITION_HEADER",
                                                 nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileVC" object:nil];
    
}

#pragma mark - UITEXTFIELD METHODS

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField becomeFirstResponder];
    
    [self searchModeStart];
    
    
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    NSLog(@"shouldChangeCharactersInRange . text = %@", text);
    NSLog(@"shouldChangeCharactersInRange . textField.text = %@", textField.text);
    
    if ([text isEqualToString:@"\n"]) {
        
//        [self setupCommentDictionaryToPublish];
//        
//        self.viewComment.alpha = 0.0;
//        
//        [self.textFieldComment resignFirstResponder];

        [self getUsersWithLetters: textField.text];

        return NO;
        
    }

    
    return YES;
    
}
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
    
}
- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
}

#pragma mark - API METHODS

- (void) getFeaturedItems {
    
    __weak PaprSearchVC *weakSelf = self;

    weakSelf.viewSearchSpinner.alpha = 1.0;

    [[APIController api] getFeatured:nil success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprSearchVC . getSignupSubscriptions . success = %@", responseDictionary);
        
        weakSelf.arrayOfFeatured = [[DataController dc] returnArrayOfSortedPaprSubscriptions: [responseDictionary objectForKey:@"featuredDictionary"] ];

        [weakSelf performSelectorOnMainThread:@selector(tableViewReload) withObject:nil waitUntilDone:YES];
        
        weakSelf.viewSearchSpinner.alpha = 0.0;
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprSearchVC . getSignupSubscriptions . error = %@", error);

        weakSelf.viewSearchSpinner.alpha = 0.0;

    }];
    
}
- (void) getUsersWithLetters : (NSString *)searchText {
    
    if (searchText.length < 1) {
        return;
    }
    
    __weak PaprSearchVC *weakSelf = self;
    
    weakSelf.viewSearchSpinner.alpha = 1.0;
    
    NSDictionary *searchTextDictionary = @{@"search_text" : searchText, @"search_type" : @"accounts"};
    
    [[APIController api] getUsers:searchTextDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprSearchVC . getUsersWithLetters . success = %@", responseDictionary);
        
        weakSelf.arrayOfSearchUsers = [[NSMutableArray alloc] initWithArray:[responseDictionary objectForKey:@"records_updated"]];
        
        NSLog(@"weakSelf.arrayOfSearchUsers = %@", weakSelf.arrayOfSearchUsers);
        NSLog(@"");
        
        [weakSelf tableViewReload];
        
        weakSelf.viewSearchSpinner.alpha = 0.0;
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprSearchVC . getUsersWithLetters . error = %@", error);
        
        weakSelf.viewSearchSpinner.alpha = 0.0;
        
    }];
    
}

#pragma mark - IBACTION METHODS

- (IBAction) buCancelSelected : (id)sender {

    [DataController dc].currentZone = @"search";

    self.textFieldSearch.text = @"";

    [self.arrayOfSearchUsers removeAllObjects];
    
    [self tableViewReload];

    [self.textFieldSearch resignFirstResponder];
    
    [self searchModeStop];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
