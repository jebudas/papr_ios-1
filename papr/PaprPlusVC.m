//
//  PaprPlusVC.m
//  papr
//
//  Created by Brian WF Tobin on 4/5/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprPlusVC.h"

@interface PaprPlusVC ()

@end

@implementation PaprPlusVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    iAmExploring = TRUE;

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // THIS IS A LIST OF ALL POSSIBLE SUBSCRIPTIONS
    [self getSignupSubscriptions];
    
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
    
    if (iAmExploring) {
        
        return 250;

    } else {
        
        return 50;

    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,100)];
    return viewFooter;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // DEFAULT TO HIDE
    self.viewNoResults.alpha = 0.0;
    
    if (iAmFiltering) {
        
        if (self.arrayOfSourcesFILTERED.count < 1) {
            self.viewNoResults.alpha = 1.0;
        }
        
        return self.arrayOfSourcesFILTERED.count;
        
    } else if (iAmExploring) {

        return self.arrayOfSourcesEXPLORE.count;
        
    } else {

        return self.arrayOfSourcesMINE.count;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int indexPathRow = (int)indexPath.row;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", indexPathRow];
    // WE"RE RE-USING THIS PERFECTLY WONDERFUL CELL FROM LOGIN
    LoginSelectionCell *cell = [self.tableViewAddSources dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginSelectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (iAmFiltering) {
        cell.cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSourcesFILTERED objectAtIndex:indexPathRow] ];
    } else if (iAmExploring) {
        cell.cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSourcesEXPLORE objectAtIndex:indexPathRow] ];
    } else {
        cell.cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSourcesMINE objectAtIndex:indexPathRow] ];
    }
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
    
    return cell;

}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    //    int indexPathRow = (int)indexPath.row;
    //    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSources objectAtIndex:indexPathRow] ];
    //    NSString *subscription_id = [cellDictionary objectForKey:@"PUBLISHER_ID"];
    //
    //    [self sendSubscriptionToManager:subscription_id withIndexPath:indexPath];
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprPlusVC . tableViewReload");
    [self.tableViewAddSources reloadData];
    
    // [self.tableViewAddSources setContentOffset:CGPointMake(0,16) animated:NO];

}

#pragma mark - UITEXTFIELD METHODS

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField becomeFirstResponder];
    
    [self searchModeStart];
    
    
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    NSLog(@"shouldChangeCharactersInRange . text = %@", text);
    NSLog(@"shouldChangeCharactersInRange . textField.text = %@", textField.text);
    NSLog(@"shouldChangeCharactersInRange . range.length = %i", (int)range.length);

    if ([text isEqualToString:@"\n"]) {
        
        return NO;
        
    } else if (text.length > 0) {
        
        NSString *fullText = [NSString stringWithFormat:@"%@%@", textField.text, text];
        [self filterSourcesWithText: fullText];
        
        return YES;

    } else if (textField.text.length > 1) {
        
        NSString *oldText = [NSString stringWithFormat:@"%@", textField.text];
        NSString *fullText = [oldText substringToIndex:[oldText length]-1];
        
        [self filterSourcesWithText: fullText];
        
        return YES;
        
    } else {
        
        iAmFiltering = FALSE;
        
        [self tableViewReload];

        return YES;

    }
    
}
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
    
}
- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
}
- (BOOL) textFieldShouldClear : (UITextField *)textField {

    iAmFiltering = FALSE;
    
    [self tableViewReload];
    
    return YES;

}
- (void) searchModeStart {
    
    self.imageViewGlyphLeft.alpha = 1.0;
    self.imageViewGlyphRight.alpha = 0.0;
    self.textFieldSearchSources.textAlignment = NSTextAlignmentLeft;

    frameSearchBG = self.imageViewTextFieldBG.frame;
    frameSearchTextField = self.textFieldSearchSources.frame;

    float newWidthImageView = self.imageViewTextFieldBG.frame.size.width * 0.8;
    float newWidthTextField = self.textFieldSearchSources.frame.size.width * 0.75;

    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{

                         self.imageViewTextFieldBG.frame = CGRectMake(self.imageViewTextFieldBG.frame.origin.x,
                                                                        self.imageViewTextFieldBG.frame.origin.y,
                                                                        newWidthImageView,
                                                                        self.imageViewTextFieldBG.frame.size.height);

                         self.textFieldSearchSources.frame = CGRectMake(self.textFieldSearchSources.frame.origin.x,
                                                                        self.textFieldSearchSources.frame.origin.y,
                                                                        newWidthTextField,
                                                                        self.textFieldSearchSources.frame.size.height);

                         
                     } completion: ^(BOOL finished){
                         
                         searchIsActive = TRUE;

                         self.buCancelSearch.alpha = 1.0;

                     }
     ];

}
- (void) searchModeStop {

    self.buCancelSearch.alpha = 0.0;
    
    self.imageViewGlyphLeft.alpha = 0.0;
    self.imageViewGlyphRight.alpha = 1.0;
    self.textFieldSearchSources.textAlignment = NSTextAlignmentCenter;

    self.textFieldSearchSources.text = @"";
    [self.textFieldSearchSources resignFirstResponder];

    [UIView animateWithDuration: 0.1
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         
                         self.imageViewTextFieldBG.frame = frameSearchBG;
                         self.textFieldSearchSources.frame = frameSearchTextField;
                         
                     } completion: ^(BOOL finished){
                         
                         iAmFiltering = FALSE;
                         searchIsActive = FALSE;
                         
                         [self tableViewReload];

                     }

     ];
    
}

#pragma mark - API METHODS

- (void) getFeaturedItems {
    
    __weak PaprPlusVC *weakSelf = self;
    
    // weakSelf.viewSearchSpinner.alpha = 1.0;

}
- (void) filterSourcesWithText : (NSString *)searchText {
    
    iAmFiltering = TRUE;

    self.arrayOfSourcesFILTERED = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfSourcesUPDATING;

    if (iAmExploring) {

        arrayOfSourcesUPDATING = [[NSMutableArray alloc] initWithArray: self.arrayOfSourcesEXPLORE ];

    } else {

        arrayOfSourcesUPDATING = [[NSMutableArray alloc] initWithArray: self.arrayOfSourcesMINE ];

    }

    for (NSDictionary *thisDictionary in arrayOfSourcesUPDATING) {
        
        NSString *sourceTitleUPPER = [[thisDictionary objectForKey:@"display_title"] uppercaseString];
        NSString *searchTextUPPER = [searchText uppercaseString];
        NSString *searchTextTHE_UPPER = [NSString stringWithFormat:@"THE %@", [searchText uppercaseString]];
        
        if ( [sourceTitleUPPER hasPrefix: searchTextUPPER] ) {
            
            NSLog(@"MATCHING: %@", sourceTitleUPPER);
            
            [self.arrayOfSourcesFILTERED addObject:thisDictionary];
            
        } else if ( [sourceTitleUPPER hasPrefix: searchTextTHE_UPPER] ) {
            
            NSLog(@"MATCHING: %@", searchTextTHE_UPPER);
            
            [self.arrayOfSourcesFILTERED addObject:thisDictionary];
            
        }
        
    }

    if (self.arrayOfSourcesFILTERED.count > 0) {
        

        // HIDE THE "HEY MON WE AINT SEEING A DERN THANG" VIEW

    } else {
        
        // SHOW THE "HEY MON WE AINT SEEING A DERN THANG" VIEW

    }
    
    [self tableViewReload];


}


#pragma mark - API METHODS & RELATED METHODS

- (void) getSignupSubscriptions {
    
    __weak PaprPlusVC *weakSelf = self;
    
    [[APIController api] getSignupSubscriptions:nil success:^(NSDictionary *responseDictionary) {
        
        [weakSelf splitArrayOfSubscriptions : [responseDictionary objectForKey:@"subscriptionDictionary"]];

        [weakSelf performSelectorOnMainThread:@selector(tableViewReload) withObject:nil waitUntilDone:YES];

    } failure:^(NSError *error) {
        
        NSLog(@"PaprPlusVC . getSignupSubscriptions . error = %@", error);
        
    }];
    
}
- (void) splitArrayOfSubscriptions : (NSArray *)arrayOfPaprSubscriptionsRCVD {
     
     self.arrayOfSourcesMINE = [[NSMutableArray alloc] init];
     self.arrayOfSourcesEXPLORE = [[NSMutableArray alloc] init];
     
     // FIRST WE SPLIT THE SUBSCRIPTIONS FROM THE NON-SUBSCRIPTIONS
     for (NSDictionary *thisPaprSubscription in arrayOfPaprSubscriptionsRCVD) {
         
         NSString *publisherID = [thisPaprSubscription objectForKey:@"PUBLISHER_ID"];
         
         if ( [[DataController dc] iSubscribeToThisPublisher:publisherID] ) {
             
             [self.arrayOfSourcesMINE addObject:thisPaprSubscription];

         } else {
             
             [self.arrayOfSourcesEXPLORE addObject:thisPaprSubscription];

         }

     }

}


#pragma mark - IBACTION & RELATED METHODS/TOOLS

- (IBAction) buContinueSelected : (id)sender {
    
    if ([[DataController dc] returnUserSubscriptions].count >= 3) {
        
        [self updateUserThenPopToRoot];
        
    } else {
        
        
    }
    
}
- (void) updateUserThenPopToRoot {
    
    NSDictionary *myUserDictionary = [[NSDictionary alloc] initWithDictionary:[[DataController dc] returnMyUserDictionary] ];
    
    [[APIController api] updateUser:myUserDictionary success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            // POP LOGIN, GO TO PAPR
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRootAfterLogin" object:nil];
            
        } else {
            
            [DataController dc].userNeedsUpdate = TRUE;
            
            // POP LOGIN, GO TO PAPR
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRootAfterLogin" object:nil];
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprPlusVC . updateUserThenPopToRoot . failure . error = %@", error);
        
    }];

}
- (IBAction) buCancelSearchSelected : (id)sender {
    
    [self searchModeStop];
    
}
- (IBAction) buRequestNewsSourceSelected : (id)sender {
    
    NSLog(@"SOURCE = %@", self.textFieldSearchSources.text);
    
}


#pragma mark - IBACTION & RELATED BUTTONS

- (IBAction) buExitSelected : (id)sender {
    
    [self.textFieldSearchSources resignFirstResponder];
    
    if ( [DataController dc].iUpdatedMySubscriberList ) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRootAfterSubscriptionUpdate" object:nil];

    } else {
    
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}
- (IBAction) buMySubscriptionsSelected : (id)sender {

    if (iAmExploring) {
        
        // SWITCH TO MY SUBSCRIPTIONS
        iAmExploring = FALSE;
        
        self.labelHeader.text = @"My Subscriptions";

        [self.buExploreAndSubscriptions setTitle:@"Explore >" forState:UIControlStateNormal];

    } else {
        
        // SWITCH TO EXPLORE
        iAmExploring = TRUE;

        self.labelHeader.text = @"Explore";

        [self.buExploreAndSubscriptions setTitle:@"My Subscriptions >" forState:UIControlStateNormal];

    }
    
    iAmFiltering = FALSE;

    [self searchModeStop];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
