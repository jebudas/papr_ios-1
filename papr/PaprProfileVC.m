//
//  PaprProfileVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProfileVC.h"

@interface PaprProfileVC ()
@end

@implementation PaprProfileVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    cellTextHeight = [[DataController dc] returnRelativeSizeForThisScreen:86];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    if (iHaveAppeared) {
        // CHILL
        return;
    }

    iHaveAppeared = TRUE;

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupIsThisMe];

    [self setupHeader];
    
    [self setupProfileDictionary];
    
    [self setupArchives];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void) setupIsThisMe {
    
    // IF WE ALREADY ESTABLISED self.thisIsMe THEN WE DONT NEED TO DOUBLE-CHECK
    if (self.thisIsMe) {
        
        [DataController dc].currentPaprDictionary = [[DataController dc] returnMyPaprDictionary];
        return;
    }
    
    NSString *myID = [[DataController dc] returnMyUserID];
    NSString *thisID = [[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"];
    
    if ([myID isEqualToString:thisID]) {
        
        self.thisIsMe = TRUE;
        
    } else {
        
        self.thisIsMe = FALSE;
        
    }
    
}
- (void) setupHeader {

    if (self.thisIsMe) {
    
        self.labelEllipsis.alpha = 0.0;

        NSDictionary *profileDictionary = [[NSDictionary alloc] initWithDictionary: [[[DataController dc] returnMyUserDictionary] objectForKey:@"user_profile"] ];
        
        self.headerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [profileDictionary objectForKey:@"user_profile_avatar_url"], @"edition_avatar_url",
                                 [profileDictionary objectForKey:@"user_profile_display_name"], @"edition_display_name",
                                 nil];
        
    } else {
        
        self.labelEllipsis.alpha = 1.0;

        self.headerDictionary = [[DataController dc].currentPaprDictionary objectForKey:@"EDITION_HEADER"];
    
    }

    // AVATAR
    NSURL *imageURL = [NSURL URLWithString:[self.headerDictionary objectForKey:@"edition_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [self.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        self.imageViewAvatar.image = [UIImage imageNamed:@"header_empty_avatar_07.png"];
    }];
    
    // AVATAR . ROUNDED
    self.imageViewAvatar.backgroundColor = [UIColor cyanColor];
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.cornerRadius = 5;

    
    // USERNAME
    if ([self.headerDictionary objectForKey:@"edition_display_name"]) {
        self.labelAvatar.text = [self.headerDictionary objectForKey:@"edition_display_name"];
    } else {
        self.labelAvatar.text = [self.headerDictionary objectForKey:@"user_username"];
    }

}
- (void) setupProfileDictionary {
    
    if (self.thisIsMe) {
        
        [self getUserProfileWithUserDictionary: @{@"user_id": [[DataController dc] returnMyUserID]} ];
        
    } else {
        
        [self getUserProfileWithUserDictionary: @{@"user_id": [[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"]} ];
        
    }
    
}
- (void) setupArchives {

    // returnArrayOfFreshPaprItems
    self.arrayOfPaprItems = [[NSArray alloc] initWithArray: [[DataController dc].currentPaprDictionary objectForKey:@"EDITION_POSTS"] ];
    
    if ( [[[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"] hasPrefix:@"p"] ) {

        // THIS IS A PUBLISHER SUBSCRIPTION

        if (self.arrayOfPaprItems.count > 0) {
            
            sectionCurrentCount = (int)self.arrayOfPaprItems.count;
            
            [self tableViewReload];
            
        } else {
        
            [self getArchivesForUser : [[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"] ];
            
        }

    } else {
    
        [self getArchivesForUser : [[DataController dc] returnMyUserID] ];
        
    }

}
- (void) getArchivesForUser : (NSString *)userID {

    NSDictionary *publisherDictionary = @{@"publisher_id" : userID};
    
    [[APIController api] getArchives:publisherDictionary success:^(NSDictionary *responseDictionary) {

        NSLog(@"PaprProfileVC . getArchives . responseDictionary = %@", responseDictionary);
        NSDictionary *archiveDictionary = [[NSDictionary alloc] initWithDictionary:[[responseDictionary objectForKey:@"Items"] objectAtIndex:0] ];

        self.arrayOfPaprItems = [[NSArray alloc] initWithArray: [archiveDictionary objectForKey:@"EDITION_POSTS"] ];
        // SET INDICES FOR CURRENT v ARCHIVE
        
        NSArray *arrayCurrentCounter = [[DataController dc] returnArrayOfFreshPaprItems:self.arrayOfPaprItems];
        
        NSLog(@"PaprProfileVC . getArchives . arrayCurrentCounter.count = %i", (int)arrayCurrentCounter.count);
        
        sectionCurrentCount = (int)arrayCurrentCounter.count;
        sectionArchiveCount = (int)self.arrayOfPaprItems.count - (int)arrayCurrentCounter.count;
        
        if (sectionArchiveCount < 0) {
            sectionArchiveCount = 0;
        }
        
        if (self.arrayOfPaprItems.count > 0) {
            
            [self tableViewReload];
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprProfileVC . getArchives . failure . error = %@", error);
        
    }];

}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {

        return 0;
        
    } else {
        
        return 30;
        
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.arrayOfPaprItems.count < 1) {
    
        self.viewEmpty.alpha = 1.0;
        self.tableViewProfile.scrollEnabled = FALSE;
        
        return nil;
        
    } else if (section == 1 && sectionCurrentCount > 0) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
        [headerView setBackgroundColor:[UIColor paprGreyVeryLight]];
        
        UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 20)];
        [labelHeader setTextColor:[UIColor darkTextColor]];
        [labelHeader setFont:[UIFont fontWithName:@"Arial" size:15]];
        
        [labelHeader setText:@"CURRENT"];
        
        [headerView addSubview:labelHeader];
        
        return headerView;

    } else if (section == 2 && sectionArchiveCount > 0) {
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
        [headerView setBackgroundColor:[UIColor paprGreyVeryLight]];
        
        UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 20)];
        [labelHeader setTextColor:[UIColor darkTextColor]];
        [labelHeader setFont:[UIFont fontWithName:@"Arial" size:15]];
        
        [labelHeader setText:@"ARCHIVE"];
        
        [headerView addSubview:labelHeader];
        
        return headerView;
        
    } else {
    
        return nil;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"PaprProfileVC . numberOfRowsInSection . self.arrayOfPaprItems.count = %i", (int)self.arrayOfPaprItems.count);
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return sectionCurrentCount;

    } else {
        
        return sectionArchiveCount;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        NSDictionary *userProfileDictionary = [[DataController dc].currentUserDictionary objectForKey:@"user_profile"];
        NSLog(@"userProfileDictionary = %@", userProfileDictionary);

        if (self.thisIsMe) {
        
        }
        
        
        NSString *myName = [userProfileDictionary objectForKey:@"user_profile_display_name"];
        NSString *myBlurb = [userProfileDictionary objectForKey:@"user_profile_blurb"];
        NSString *myURL = [userProfileDictionary objectForKey:@"user_profile_url"];
//        NSString *myBlurb = @"All the News That's Fit To Click.";
//        NSString *myURL = @"http://jebudas.com";

        int addedHeightForProfileElements = 0;
        int heightForStaticProfileElements = [[DataController dc] returnRelativeSizeForThisScreen:127]; // HEIGHT (222) MINUS DYNAMIC ELEMENT HEIGHTS
        
        if ( myName.length > 2) {
            addedHeightForProfileElements += [[DataController dc] returnRelativeSizeForThisScreen:24]; // NAME = 24
        }

        if ( myBlurb.length > 2) {
            addedHeightForProfileElements += [[DataController dc] returnRelativeSizeForThisScreen:51]; // BLURB = 51
        }

        if ( myURL.length > 2) {
            addedHeightForProfileElements += [[DataController dc] returnRelativeSizeForThisScreen:20]; // URL = 20
        }

        return heightForStaticProfileElements + addedHeightForProfileElements;
        
    } else {
        
        return cellTextHeight;

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        return [self returnPaprCellProfile : nil : indexPath];
        
    } else if (indexPath.section == 1) {

        NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: indexPath.row ];
        
        return [self returnPaprCellText : thisCellDictionary : indexPath];

    } else {

        NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: (indexPath.row + sectionCurrentCount) ];
        
        return [self returnPaprCellText : thisCellDictionary : indexPath];

    }
    
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
}
- (PaprCellProfile *) returnPaprCellProfile : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellProfile *cell = [self.tableViewProfile dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellProfile" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.thisIsMe = self.thisIsMe;
    cell.thisID = [[DataController dc].currentPaprDictionary objectForKey:@"PUBLISHER_ID"];    
    [cell setupButtons];
    [cell setupLabels];
    
    // DYNAMIC LABELS HERE
    NSDictionary *userProfileDictionary = [[DataController dc].currentUserDictionary objectForKey:@"user_profile"];

    NSLog(@"userProfileDictionary = %@", userProfileDictionary);
    
    NSString *myName = [userProfileDictionary objectForKey:@"user_profile_display_name"];
    NSString *myBlurb = [userProfileDictionary objectForKey:@"user_profile_blurb"];
    NSString *myURL = [userProfileDictionary objectForKey:@"user_profile_url"];
//    NSString *myBlurb = @"All the News That's Fit To Click. All the News That's Fit To Click. All the News That's Fit To Click.  All the News That's Fit To Click.";
//    NSString *myURL = @"http://jebudas.com";
    
    int nextProfileElementOriginY = cell.viewStats.frame.size.height + 2;
    
    if (myName.length > 2) {
        
        CGRect frameName = CGRectMake(cell.labelName.frame.origin.x, nextProfileElementOriginY, cell.labelName.frame.size.width, cell.labelName.frame.size.height);
        UILabel *thisLabelName = [[UILabel alloc] initWithFrame:frameName];
        thisLabelName.numberOfLines = 0;
        thisLabelName.font = cell.labelName.font;
        thisLabelName.text = myName;
        thisLabelName.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:thisLabelName];

        nextProfileElementOriginY += cell.labelName.frame.size.height + 2;

        cell.labelName.alpha = 0.0;
    
    } else {
        cell.labelName.alpha = 0.0;
    }
    
    if (myBlurb.length > 2) {

        CGRect frameBlurb = CGRectMake(cell.labelBlurb.frame.origin.x, nextProfileElementOriginY, cell.labelBlurb.frame.size.width, cell.labelBlurb.frame.size.height);
        UILabel *thisLabelBlurb = [[UILabel alloc] initWithFrame:frameBlurb];
        thisLabelBlurb.numberOfLines = 0;
        thisLabelBlurb.font = cell.labelBlurb.font;
        thisLabelBlurb.text = myBlurb;
        thisLabelBlurb.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:thisLabelBlurb];
        
        nextProfileElementOriginY += cell.labelBlurb.frame.size.height + 3;
        
        cell.labelBlurb.alpha = 0.0;

    } else {
        cell.labelBlurb.alpha = 0.0;
    }
    
    if (myURL.length > 2) {

        CGRect frameURL = CGRectMake(cell.buURL.frame.origin.x, nextProfileElementOriginY, cell.buURL.frame.size.width, cell.buURL.frame.size.height);
        UILabel *thisLabelURL = [[UILabel alloc] initWithFrame:frameURL];
        thisLabelURL.numberOfLines = 0;
        thisLabelURL.font = cell.labelBlurb.font;
        thisLabelURL.text = myURL;
        thisLabelURL.textColor = [UIColor paprBlue];
        thisLabelURL.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:thisLabelURL];
        
        nextProfileElementOriginY += cell.labelWebsiteURL.frame.size.height + 2;
        
        // cell.buURL.alpha = 0.0;
    
    } else {
        cell.buURL.alpha = 0.0;
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (PaprCellText *) returnPaprCellText : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellText *cell = [self.tableViewProfile dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.labelText.text = [thisCellDictionary objectForKey:@"post_title"];
    cell.imageViewIcon.image = [UIImage imageNamed:@"icon_news.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell addSubview: [self returnCellFooterLineWithHeight : cellTextHeight] ];
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (UIView *) returnCellFooterLineWithHeight : (int)heightRCVD {
    
    float viewOriginX = [[DataController dc] returnRelativeSizeForThisScreen:15];
    float viewOriginY = [[DataController dc] returnRelativeSizeForThisScreen:heightRCVD] - 1;
    float viewSizeX = [[DataController dc] returnRelativeSizeForThisScreen:345];
    float viewSizeY = 1;
    
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.frame = CGRectMake(viewOriginX, viewOriginY, viewSizeX, viewSizeY);
    viewLine.backgroundColor = [UIColor paprGreyVeryLight];
    
    return viewLine;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprItemVC . tableViewReload");
    [self.tableViewProfile reloadData];
    
}

#pragma mark - API

- (void) getUserProfileWithUserDictionary : (NSDictionary *)userDictionaryRCVD {
    
    __weak PaprProfileVC *weakSelf = self;
    
    [[APIController api] getUserProfile:userDictionaryRCVD success:^(NSDictionary *responseDictionary) {
        
        [DataController dc].currentUserDictionary = [[NSDictionary alloc] initWithDictionary: [responseDictionary objectForKey:@"db_connected"] ];

        [weakSelf.tableViewProfile reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprCellProfile . getUserProfileWithUserDictionary . error = %@", error);
        
    }];
    
}

#pragma mark - UIALERT

- (void) pushActionSheet {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"PAPR"
                                                                         message:@"User Settings"
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionBlock = [UIAlertAction actionWithTitle:@"Block User" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //
                                                        }];

    UIAlertAction* actionReport = [UIAlertAction actionWithTitle:@"Report User" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //
                                                        }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             [self dismissViewControllerAnimated:YES completion:^{}];
                                                             
                                                         }];

    
    [actionSheet addAction:actionBlock];
    [actionSheet addAction:actionReport];
    [actionSheet addAction:actionCancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}
- (void) pushAlert {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"This is an alert."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //
                                                     }];

    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [self dismissViewControllerAnimated:YES completion:^{}];
                                                         
                                                     }];

    [alert addAction:actionOK];
    [alert addAction:actionCancel];

    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - IBACTION METHODS

- (IBAction) buBackSelected : (id)sender {
    
    NSLog(@"buBackSelected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRootFromProfile" object:nil];
    
}
- (IBAction) buEllipsisSelected : (id)sender {
    
    if (self.thisIsMe) {
        // CHILL
    } else {
        [self pushActionSheet];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
