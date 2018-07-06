//
//  PaprTableVC.m
//  papr
//
//  Created by Brian WF Tobin on 2/14/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprTableVC.h"

@interface PaprTableVC ()

@end

@implementation PaprTableVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupSwipeGestures];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.arrayOfPaprArticles = [[NSArray alloc] initWithArray: [[DataController dc] returnArrayOfFreshPaprItems: [self.paprDictionary objectForKey:@"EDITION_POSTS"] ] ];

    [self.tableViewPapr reloadData];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

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
    
    return 1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,100)];
    return viewFooter;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPaprArticles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self returnCellHeightForRowAtIndexPath:(NSIndexPath *)indexPath];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    int indexPathRow = (int)indexPath.row;
    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprArticles objectAtIndex:indexPathRow] ];

    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprTableCell *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.tag = indexPathRow + 1;
        cell.delegate = self;
        cell.cellDictionary = cellDictionary;
        
        [cell setTag:indexPath.row+1];

        NSLog(@"PaprTableVC . cellDictionary = %@", cellDictionary);
        NSString *imageString = [cellDictionary objectForKey:@"post_image_url"];

        if ([imageString isKindOfClass:[NSString class]]) {

            NSURL *imageURL = [NSURL URLWithString:imageString];
            NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
            
            [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                cell.imageViewMain.image = image;
                cell.imageViewMain.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageViewMain.clipsToBounds = TRUE;
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //
                //p7000046_mia.png
                NSString *postPublisher = [NSString stringWithFormat:@"%@_mia.png", [cellDictionary objectForKey:@"post_publisher"]];
                cell.imageViewMain.image = [UIImage imageNamed:postPublisher];

                cell.imageViewMain.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageViewMain.clipsToBounds = TRUE;

            }];

        }

        // LABEL . URL
        NSString *urlString = [self returnCleanText : [cellDictionary objectForKey:@"post_link"]];
        NSURL *url = [NSURL URLWithString:urlString];
        cell.labelURL.text = [url host];
        // TESTING:
        // cell.labelURL.text = @"wsj.com";

        // LABEL . TITLE
        CGRect frameTitle;
        // HOW MANY LINES?
        NSString *cleanTitleText = [self returnCleanText : [cellDictionary objectForKey:@"post_title"]];
        // TESTING:
        // cleanTitleText = @"NBC Bet $69 Million on Megyn";
        // cleanTitleText = @"NBC Bet $69 Million on Megyn Kelly--Then Viewers Vanished";
        // cleanTitleText = @"NBC Bet $69 Million on Megyn Kelly--Then Viewers Vanished and they're not coming back.";
        CGRect labelRECT = CGRectMake(0, 0,
                                      [[DataController dc] returnRelativeSizeForThisScreen:321],
                                      [[DataController dc] returnRelativeSizeForThisScreen:1000]);
        UILabel *labelTitleTEMP = [[UILabel alloc] initWithFrame : labelRECT];
        int lineCountTitle = [[DataController dc] returnLineCountForTitle : cleanTitleText];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: cleanTitleText ];
        [attributedString addAttribute:NSKernAttributeName value:@-0.8 range:NSMakeRange(0, cleanTitleText.length)];

        if (lineCountTitle >= 3) {
            lineCountTitle = 3;
            cell.labelTitle03.alpha = 1.0;
            frameTitle = cell.labelTitle03.frame;
            cell.labelTitle03.attributedText = attributedString;
            cell.labelTitle03.font = [UIFont systemFontOfSize:22.5 weight:UIFontWeightBold];
        } else if (lineCountTitle == 2) {
            lineCountTitle = 2;
            cell.labelTitle02.alpha = 1.0;
            frameTitle = cell.labelTitle02.frame;
            cell.labelTitle02.attributedText = attributedString;
            cell.labelTitle02.font = [UIFont systemFontOfSize:22.5 weight:UIFontWeightBold];
        } else {
            lineCountTitle = 1;
            cell.labelTitle01.alpha = 1.0;
            frameTitle = cell.labelTitle01.frame;
            cell.labelTitle01.attributedText = attributedString;
            cell.labelTitle01.font = [UIFont systemFontOfSize:22.5 weight:UIFontWeightBold];
        }
        
        NSLog(@"attributedString = %@", attributedString);
        
        
        // LABEL . DESCRIPTION (BLURB)
        CGRect frameBlurb = cell.labelDescription.frame;
        NSString *cleanDescription = [self returnCleanText : [cellDictionary objectForKey:@"post_description"]];
        NSString *cleanDescriptionText = [NSString stringWithFormat:@"• %@", cleanDescription];
        // TESTING:
        // cleanDescriptionText = @"The former Fox News star was supposed to bring a bigger audience for \"Today.\"      Instead, ratings declines...";
        // HOW MANY LINES?
        int maxAvailableLines = 6 - lineCountTitle;
        int lineCountDescription = [[DataController dc] returnLineCountForDescription : cleanDescriptionText : cell.labelDescription];
        if (lineCountDescription > maxAvailableLines) {
            lineCountDescription = maxAvailableLines;
        }
        
        int frameOriginY = frameTitle.origin.y + frameTitle.size.height + 3;
        int frameSizeY = 0;
        
        if ( [cleanDescription isEqualToString:@"-"] ) {
            cell.labelDescription.alpha = 0.0;
        } else if (lineCountDescription >= 5) {
            frameSizeY = [[DataController dc] returnRelativeSizeForThisScreen:114];
            cell.labelDescription.alpha = 1.0;
            cell.labelDescription.numberOfLines = 5;
            cell.labelDescription.text = cleanDescriptionText;
        } else if (lineCountDescription == 4) {
            frameSizeY = [[DataController dc] returnRelativeSizeForThisScreen:95];
            cell.labelDescription.alpha = 1.0;
            cell.labelDescription.numberOfLines = 4;
            cell.labelDescription.text = cleanDescriptionText;
        } else if (lineCountDescription == 3) {
            frameSizeY = [[DataController dc] returnRelativeSizeForThisScreen:76];
            cell.labelDescription.alpha = 1.0;
            cell.labelDescription.numberOfLines = 3;
            cell.labelDescription.text = cleanDescriptionText;
        } else if (lineCountDescription == 2) {
            frameSizeY = [[DataController dc] returnRelativeSizeForThisScreen:57];
            cell.labelDescription.alpha = 1.0;
            cell.labelDescription.numberOfLines = 2;
            cell.labelDescription.text = cleanDescriptionText;
        } else {
            frameSizeY = [[DataController dc] returnRelativeSizeForThisScreen:38];
            cell.labelDescription.alpha = 1.0;
            cell.labelDescription.numberOfLines = 1;
            cell.labelDescription.text = cleanDescriptionText;
        }

        cell.labelDescription.frame = CGRectMake(frameBlurb.origin.x, frameOriginY, frameBlurb.size.width, frameSizeY);
        
        // NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: cellTextString ];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 2.0;
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cellTextString.length)];
//        [attributedString addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, cellTextString.length)];
        
        // cell.labelDescription.attributedText = attributedString;
        // cell.labelDescription.numberOfLines = 4;
         CGRect labelFrame = cell.labelDescription.frame;
         cell.labelDescription.frame = CGRectMake(labelFrame.origin.x,labelFrame.origin.y,labelFrame.size.width,1000);
         [cell.labelDescription sizeToFit];
        
        // SETUP THE FOOTER
//         HIDING THE COMMENTS LABEL FOR NOW
//         ADDING VIEWS TO arrayOfViews
//         [self setupFooterWithTag : (int)cell.tag : [cellDictionary objectForKey:@"post_publisher"] : [cellDictionary objectForKey:@"post_id"] ];
        
        cell.labelTimestamp.text = [[DataController dc] returnHumanDateStringFancy: [cellDictionary objectForKey:@"post_timestamp"] ];

        [[APIController api] addViews: [cellDictionary objectForKey:@"post_id"] ];

        if (indexPathRow == (self.arrayOfPaprArticles.count - 1)) {
            cell.viewFooter.backgroundColor = [UIColor paprCharcoal];
            cell.viewFooterFinal.backgroundColor = [UIColor paprCharcoal];
        }

        NSLog(@"CELL . post_title = %@\ntitle count = %i, \nblurb count = %i, ", cleanTitleText, lineCountTitle, lineCountDescription);

    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableViewPapr deselectRowAtIndexPath:indexPath animated:NO];

}
- (void) tableViewReload {
    [self.tableViewPapr reloadData];
}
- (void) setupFooterWithTag : (int)tagRCVD : (NSString *)publisherID  : (NSString *)postID {
    
    NSLog(@"setupFooterWithTag(%i) . %@ : %@", tagRCVD, publisherID, postID);

    // HERE'S THE TRICK, WE'RE GONNA SEND THE VIEW INCREMENT,
    // AND HOPEFULLY GET THE STATS JSON AS THE RETURN!
    // DOS BIRDS WITH UNO STONO
    
    NSDictionary *parameters = @{@"publisher_id":publisherID, @"post_id":postID};

    [[APIController api] postStatisticsViews:parameters success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"PaprTableVC . postArticleViews . success = %@", responseDictionary);
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprTableVC . postArticleViews . error = %@", error);
        
    }];
    
    
}

#pragma mark - GESTURE METHODS

- (void) setupSwipeGestures {
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableViewPapr addGestureRecognizer:swipeRight];
    
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"PaprTableVC . gestureRecognizer");

    return NO;
    
}
- (void) swipeLeft : (id)sender {

    NSLog(@"PaprTableVC . swipeLeft");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.setupSwipeLeft" object:nil];

}
- (void) swipeRight : (id)sender {
    
    NSLog(@"PaprTableVC . swipeRight");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.setupSwipeRight" object:nil];

}

#pragma mark - TOOLS

- (void) launchArticleWithTag : (int)tagRCVD {

/*
    // SNTAH
    if (tagRCVD > self.arrayOfPaprArticles.count) {
        return;
    }

    int indexPathRow = (int)tagRCVD - 1;
    
    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprArticles objectAtIndex:indexPathRow] ];
    NSString *cellURL = [cellDictionary objectForKey:@"post_link"];
    
    // SNTAH
    if (cellURL.length < 7) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushSafariBrowser" object:nil userInfo:@{@"url" : cellURL}];
    
    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Viewed"}];
*/

}
- (NSString *) returnCleanText : (NSString *)textRCVD {

    NSString *textString = textRCVD;

    textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    textString = [textString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    textString = [textString stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
    textString = [textString stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
    textString = [textString stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    textString = [textString stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    textString = [textString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    return textString;
    
}
- (float) returnCellHeightForRowAtIndexPath : (NSIndexPath *)indexPath {

    int cellHeight = 0;
    int indexPathRow = (int)indexPath.row;
    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprArticles objectAtIndex:indexPathRow] ];
    
    // ADD CELL HEIGHT CONSTANTS . IMAGE
    if ( [[cellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        cellHeight += 0;
    } else {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:250];
    }
    
    // ADD CELL HEIGHT CONSTANTS . URL + TITLE + TITLE/BLURB PADDING
    NSString *cleanTitleText = [self returnCleanText : [cellDictionary objectForKey:@"post_title"]];
    // TESTING:
    // cleanTitleText = @"NBC Bet $69 Million on Megyn";
    // CGRect SIZES ARE FROM PaprTableCell.labelTitle01;
    CGRect labelRECT = CGRectMake(0,
                                  0,
                                  [[DataController dc] returnRelativeSizeForThisScreen:321],
                                  [[DataController dc] returnRelativeSizeForThisScreen:1000]);
    UILabel *labelTitleTEMP = [[UILabel alloc] initWithFrame : labelRECT];
    int lineCountTitle = [[DataController dc] returnLineCountForTitle : cleanTitleText];
    if (lineCountTitle >= 3) {
        lineCountTitle = 3;
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:110];
    } else if (lineCountTitle == 2) {
        lineCountTitle = 2;
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:84];
    } else {
        lineCountTitle = 1;
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:58];
    }

    // ADD CELL HEIGHT CONSTANTS . DESCRIPTION (BLURB)
    NSString *cleanDescription = [self returnCleanText : [cellDictionary objectForKey:@"post_description"]];
    NSString *cleanDescriptionText = [NSString stringWithFormat:@"• %@", cleanDescription];

    // CGRect SIZES ARE FROM PaprTableCell.labelDescription;
    CGRect labelDescriptionRECT = CGRectMake(0, 0,
                                             [[DataController dc] returnRelativeSizeForThisScreen:325],
                                             [[DataController dc] returnRelativeSizeForThisScreen:1000]);
    UILabel *labelDescriptionTEMP = [[UILabel alloc] initWithFrame : labelDescriptionRECT];
    int lineCountDescription = [[DataController dc] returnLineCountForDescription : cleanDescriptionText : labelDescriptionTEMP];
    int maxAvailableLines = 6 - lineCountTitle;
    if (lineCountDescription > maxAvailableLines) {
        lineCountDescription = maxAvailableLines;
    }

    // ADD CELL HEIGHT CONSTANTS . TITLE/BLURB PADDING
    cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:14];
    
    
    // ADD CELL HEIGHT CONSTANTS . BLURB
    if ( [[cellDictionary objectForKey:@"post_description"] isEqualToString:@"-"] ) {
        // WE ADD IN THE PADDING BELOW, THIS NEGATES THAT.
        cellHeight -= [[DataController dc] returnRelativeSizeForThisScreen:25];
    } else if (lineCountDescription >= 5) {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:78];
    } else if (lineCountDescription == 4) {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:62];
    } else if (lineCountDescription == 3) {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:46];
    } else if (lineCountDescription == 2) {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:30];
    } else {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:10];
    }


    // ADD CELL HEIGHT CONSTANTS . BLURB/FOOTER PADDING
    cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:25];

    
    // ADD CELL HEIGHT CONSTANTS . FOOTER
    cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:46];

    return cellHeight;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
