//
//  PaprPostPreviewVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprPostPreviewVC.h"

@interface PaprPostPreviewVC ()

@end

@implementation PaprPostPreviewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // HACK
    fullHeaderIsOff = TRUE;
    
    NSLog(@"PaprPostPreviewVC . viewDidLoad");
    
    [self setupNotifications];

    [self setupHeightVariables];

    [DataController dc].currentZone = @"create_preview";
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupPaprDictionary];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.showPaprTabBar" object:nil];
    
}

- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprPostCreateVC) name:@"PaprPostPreviewVC.pushPaprPostCreateVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popPaprPostCreateVC) name:@"PaprPostPreviewVC.popPaprPostCreateVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprPostEditVC) name:@"PaprPostPreviewVC.pushPaprPostEditVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popPaprPostEditVC) name:@"PaprPostPreviewVC.popPaprPostEditVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPaprDictionary) name:@"PaprPostPreviewVC.reloadPaprDictionary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popThenReload) name:@"PaprPostPreviewVC.popThenReload" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostPreviewVC.reloadPaprDictionary" object:nil];
    
}
- (void) setupHeightVariables {
    
    if ([[UIScreen mainScreen] bounds].size.width < 321) {
        cellFontSize = 14;
        cellHeightHeader = 70;
        cellHeightContentFull = 232;
        cellHeightContentNormal = 73;
    } else if ([[UIScreen mainScreen] bounds].size.width < 376) {
        cellFontSize = 16;
        cellHeightHeader = 82;
        cellHeightContentFull = 272;
        cellHeightContentNormal = 86;
    } else if ([[UIScreen mainScreen] bounds].size.width < 415) {
        cellFontSize = 16;
        cellHeightHeader = 90;
        cellHeightContentFull = 300;
        cellHeightContentNormal = 94;
    }
    
}
- (void) setupPaprDictionary {
    
    self.paprDictionary = [[DataController dc] returnMyPaprDictionary];
    
    NSArray *arrayOfPaprItemsPRE = [[NSArray alloc] initWithArray: [self.paprDictionary objectForKey:@"EDITION_POSTS"] ];
    
    self.arrayOfPaprItems = [[NSArray alloc] initWithArray: [[DataController dc] returnArrayOfFreshPaprItems: arrayOfPaprItemsPRE ] ];

    
    if (self.arrayOfPaprItems.count > 0) {

        [self hideViewEmptyPaper];

    } else {
    
        [self showViewEmptyPaper];
        
    }

    [self tableViewReload];

}

- (void) showViewEmptyPaper {

    NSMutableAttributedString *emptyPaprString = [[NSMutableAttributedString alloc] initWithString:@"Add a title..."];
    [emptyPaprString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlackHero] range:NSMakeRange(0,5)];
    [emptyPaprString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlue] range:NSMakeRange(6,5)];
    [emptyPaprString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlackHero] range:NSMakeRange(11,3)];
    self.labelEmptyPapr.attributedText = emptyPaprString;
    
    self.viewEmptyPapr.alpha = 1.0;

}
- (void) hideViewEmptyPaper {
    
    self.viewEmptyPapr.alpha = 0.0;
    
}
- (void) animateCheckmark {

    self.imageViewCheckmark.alpha = 1.0;

    [UIView animateWithDuration:2.0
                     animations: ^{
                         self.imageViewCheckmark.alpha = 0.0;
                     } completion: ^(BOOL finished){
                         //
                     }
     ];

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
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"PaprPostPreviewVC . numberOfRowsInSection . self.arrayOfPaprItems.count = %i", (int)self.arrayOfPaprItems.count);
    
    return self.arrayOfPaprItems.count + 1; // +1 FOR HEADER
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        // HEADER
        return cellHeightHeader;
        
    } else if (indexPath.row == 1) {

        return cellHeightContentNormal;

//        // TEST FOR TYPE
//        NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: (indexPath.row - 1) ];
//        NSString *cellType = [thisCellDictionary objectForKey:@"post_type"];
//        
//        if ([cellType isEqualToString:@"full"] && fullHeaderIsOff) {
//            
//            fullHeaderIsOn = TRUE;
//            
//            return cellHeightContentFull;
//            
//        } else {
//            
//            return cellHeightContentNormal;
//            
//        }
        
    } else {

        return cellHeightContentNormal;

//        if (fullHeaderIsOn) {
//            return cellHeightContentNormal - 4;
//        } else {
//            return cellHeightContentNormal;
//        }
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        return [self returnPaprCellHeaderPost : [self.paprDictionary objectForKey:@"EDITION_HEADER"] ];
        
    } else if (indexPath.row == 1) {

        NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: (indexPath.row - 1) ];

        return [self returnPaprCellText : thisCellDictionary : indexPath];

//        NSString *cellType = [thisCellDictionary objectForKey:@"post_type"];
//
//        if ([cellType isEqualToString:@"full"]) {
//            
//            return [self returnPaprCellFull : thisCellDictionary : indexPath];
//            
//        } else if ([cellType isEqualToString:@"image"]) {
//            
//            return [self returnPaprCellPhoto : thisCellDictionary : indexPath];
//            
//        } else {
//            
//            return [self returnPaprCellText : thisCellDictionary : indexPath];
//            
//        }
        
    } else {
        
        NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: (indexPath.row - 1) ];

        return [self returnPaprCellText : thisCellDictionary : indexPath];

//        NSString *cellType = [thisCellDictionary objectForKey:@"post_type"];
//        
//        if ([cellType isEqualToString:@"image"]) {
//
//            return [self returnPaprCellPhoto : thisCellDictionary : indexPath];
//
//        } else {
//            
//            return [self returnPaprCellText : thisCellDictionary : indexPath];
//            
//        }
        
    }

}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int indexPathRow = (int)indexPath.row;
    
    NSLog(@"didSelectRowAtIndexPath: %i", indexPathRow);
    //    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSubscriptions objectAtIndex:indexPathRow] ];
    //    NSString *subscription_id = [NSString stringWithFormat:@"%i", [[cellDictionary objectForKey:@"PUBLISHER_ID"] intValue] ];
    //
    //    [self sendSubscriptionToManager : subscription_id];
    
}
- (PaprCellHeaderPost *) returnPaprCellHeaderPost : (NSDictionary *)thisHeaderDictionary {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellHeaderPost *cell = [self.tableViewPreviewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellHeaderPost" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setTag:1000];

    NSURL *imageURL = [NSURL URLWithString:[thisHeaderDictionary objectForKey:@"edition_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];

    cell.labelAvatar.text = [thisHeaderDictionary objectForKey:@"edition_display_name"];
    
    [cell setupHeader : @"preview"];

    if (self.arrayOfPaprItems.count < 1) {
        
        cell.buEdit.alpha = 0.0;
        cell.buPlus.alpha = 0.0;
        
        // UPDATE FOLLOWERS
        NSDictionary *idDictionary = @{@"publisher_id" : [[DataController dc] returnMyUserID]};
        [[APIController api] getMyFollowers:idDictionary success:^(NSDictionary *responseDictionary) {
            
            NSLog(@"PaprMoreVC . getMyFollowers . responseDictionary = %@", responseDictionary);
            
            NSArray *arrayOfMyFollowers = [[NSArray alloc] initWithArray: [[responseDictionary objectForKey:@"item_dictionary"] objectForKey:@"SUBSCRIBERS"] ];
            
            NSString *titleFollowers = [NSString stringWithFormat:@"%i Followers", (int)arrayOfMyFollowers.count];
            [cell.buFollowers setTitle:titleFollowers forState:UIControlStateNormal];
            
            cell.buFollowers.alpha = 1.0;

            NSLog(@"");
            
        } failure:^(NSError *error) {
            
            NSLog(@"PaprMoreVC . getMyFollowers . error = %@", error);
            
        }];

        
    } else {
        cell.buEdit.alpha = 1.0;
        cell.buPlus.alpha = 1.0;
        cell.buFollowers.alpha = 0.0;
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = NO;
    
    return cell;
    
}
- (PaprCellText *) returnPaprCellText : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellText *cell = [self.tableViewPreviewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.cellDictionary = thisCellDictionary;
    
    NSString *cellTextString = [thisCellDictionary objectForKey:@"post_title"];
    
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: cellTextString ];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cellTextString.length)];
    [attributedString addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, cellTextString.length)];
    
    cell.labelText.attributedText = attributedString;

    NSString *iconType = [NSString stringWithFormat:@"icon_%@.png", [thisCellDictionary objectForKey:@"post_type"]];
    cell.imageViewIcon.image = [UIImage imageNamed:iconType];
    
    if (fullHeaderIsOn) {
        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentNormal - 4] ];;
    } else {
        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentNormal] ];;
    }

    // SHOW TIME REMAINING
    UILabel *labelTimeRemaining = [[UILabel alloc] init];
    labelTimeRemaining.frame =
    CGRectMake([[DataController dc] returnRelativeSizeForThisScreen:345],0,[[DataController dc] returnRelativeSizeForThisScreen:30],cellHeightContentNormal);
    labelTimeRemaining.font = [UIFont boldSystemFontOfSize:10];
    labelTimeRemaining.text = [[DataController dc] returnTimeRemaining:[thisCellDictionary objectForKey:@"post_timestamp"] ];
    labelTimeRemaining.textColor = [UIColor paprRed];
    labelTimeRemaining.textAlignment = NSTextAlignmentCenter;
    labelTimeRemaining.numberOfLines = 0;
    [cell addSubview:labelTimeRemaining];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (PaprCellPhoto *) returnPaprCellPhoto : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellPhoto *cell = [self.tableViewPreviewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellPhoto" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewPhoto setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewPhoto.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.cellDictionary = thisCellDictionary;
    cell.labelText.text = [thisCellDictionary objectForKey:@"post_title"];

    if (fullHeaderIsOn) {
        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentNormal - 4] ];;
    } else {
        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentNormal] ];;
    }

    // SHOW TIME REMAINING
    UILabel *labelTimeRemaining = [[UILabel alloc] init];
    labelTimeRemaining.frame =
    CGRectMake([[DataController dc] returnRelativeSizeForThisScreen:345],0,[[DataController dc] returnRelativeSizeForThisScreen:30],cellHeightContentNormal);
    labelTimeRemaining.font = [UIFont boldSystemFontOfSize:10];
    labelTimeRemaining.text = [[DataController dc] returnTimeRemaining:[thisCellDictionary objectForKey:@"post_timestamp"] ];
    labelTimeRemaining.textColor = [UIColor paprRed];
    labelTimeRemaining.textAlignment = NSTextAlignmentCenter;
    labelTimeRemaining.numberOfLines = 0;
    [cell addSubview:labelTimeRemaining];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (PaprCellFull *) returnPaprCellFull : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"PaprCellFull";
    PaprCellFull *cell = [self.tableViewPreviewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellFull" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewMain.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.cellDictionary = thisCellDictionary;
    cell.labelText.text = [thisCellDictionary objectForKey:@"post_title"];
    cell.imageViewIcon.image = [UIImage imageNamed:@"icon_news.png"];

    if (fullHeaderIsOn) {
        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentFull - 4] ];;
    } else {
        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentFull] ];;
    }

    // SHOW TIME REMAINING
    UILabel *labelTimeRemaining = [[UILabel alloc] init];
    int timeOriginY = cellHeightContentFull - cell.labelText.frame.size.height;
    labelTimeRemaining.frame =
    CGRectMake([[DataController dc] returnRelativeSizeForThisScreen:345],timeOriginY,[[DataController dc] returnRelativeSizeForThisScreen:30],cell.labelText.frame.size.height);
    labelTimeRemaining.font = [UIFont boldSystemFontOfSize:10];
    labelTimeRemaining.text = [[DataController dc] returnTimeRemaining:[thisCellDictionary objectForKey:@"post_timestamp"] ];
    labelTimeRemaining.textColor = [UIColor paprRed];
    labelTimeRemaining.textAlignment = NSTextAlignmentCenter;
    labelTimeRemaining.numberOfLines = 0;
    [cell addSubview:labelTimeRemaining];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;

}
- (UIView *) returnCellFooterLineWithHeight : (int)heightRCVD {
    
    float viewOriginX = [[DataController dc] returnRelativeSizeForThisScreen:15];
    float viewOriginY = [[DataController dc] returnRelativeSizeForThisScreen:heightRCVD] - 2;
    float viewSizeX = [[DataController dc] returnRelativeSizeForThisScreen:345];
    float viewSizeY = 1;
    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.frame = CGRectMake(viewOriginX, viewOriginY, viewSizeX, viewSizeY);
    viewLine.backgroundColor = [UIColor paprGreyLight];
    
    return viewLine;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprPostPreviewVC . tableViewReload");
    [self.tableViewPreviewPapr reloadData];
    
}

#pragma mark - IBACTION & NAVIGATION Methods

- (void) pushPaprPostCreateVC {

    self.paprPostCreateVC = [[PaprPostCreateVC alloc] init];
    [self.navigationController pushViewController:self.paprPostCreateVC animated:NO];

    // DEPRECATED in v1.3
//    if (self.arrayOfPaprItems.count < 6) {
//
//        self.paprPostCreateVC = [[PaprPostCreateVC alloc] init];
//        [self.navigationController pushViewController:self.paprPostCreateVC animated:NO];
//    
//    } else {
//    
//        self.paprPostEditVC = [[PaprPostEditVC alloc] init];
//        self.paprPostEditVC.weAreAtMaximum = TRUE;
//        [self.navigationController pushViewController:self.paprPostEditVC animated:NO];
//
//    }

}
- (void) popPaprPostCreateVC {

    //[self.navigationController popToViewController:self animated:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.paprPostCreateVC = nil;

}
- (void) pushPaprPostEditVC {
    
    // TODO: GGXGG: CHECK FOR EMPTY PAPR FIRST!! ALERT IF EMPTY!!
    
    self.paprPostEditVC = [[PaprPostEditVC alloc] init];
    if (self.arrayOfPaprItems.count < 6) {
        self.paprPostEditVC.weAreAtMaximum = FALSE;
    } else {
        self.paprPostEditVC.weAreAtMaximum = TRUE;
    }

    [self.navigationController pushViewController:self.paprPostEditVC animated:NO];
    
}
- (void) popPaprPostEditVC {
    
    //[self.navigationController popToViewController:self animated:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.paprPostEditVC = nil;
    
}
- (void) reloadPaprDictionary {

    [self setupPaprDictionary];
    
    [self animateCheckmark];
    
}
- (void) popThenReload {

    [self popPaprPostCreateVC];

    [self setupPaprDictionary];

}
- (IBAction) buEmpyPostSelected : (id)sender {

    NSLog(@"PaprPostPreviewVC . buPlusSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostPreviewVC.pushPaprPostCreateVC" object:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
