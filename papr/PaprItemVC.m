//
//  PaprItemVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprItemVC.h"

@interface PaprItemVC ()

@end

@implementation PaprItemVC

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNotifications];

    self.arrayOfPaprItems = [[NSArray alloc] initWithArray: [[DataController dc] returnArrayOfFreshPaprItems: [self.paprDictionary objectForKey:@"EDITION_POSTS"] ] ];

    [self setupHeader];

    [self setupSwipeGestures];

    [self setupHeightVariables];

    [self setupArrayOfLineHints];

}
- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self sendStats : @{@"type_field" : @"views"}];

}
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}
- (void) setupHeader {

    NSDictionary *headerDictionary = [self.paprDictionary objectForKey:@"EDITION_HEADER"];

    if ( [headerDictionary objectForKey:@"edition_mast_url"] ) {
        
        NSURL *mastURL = [NSURL URLWithString:[headerDictionary objectForKey:@"edition_mast_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:mastURL];
        [self.imageViewMast setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.imageViewMast.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
        
        self.labelAvatar.alpha = 0.0;
        self.imageViewAvatar.alpha = 0.0;
        
    } else {
        
        NSURL *imageURL = [NSURL URLWithString:[headerDictionary objectForKey:@"edition_avatar_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        [self.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.imageViewAvatar.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
        
        NSString *avatarLabelString = [NSString stringWithFormat:@"%@", [headerDictionary objectForKey:@"edition_display_name"] ];
        self.labelAvatar.text = avatarLabelString;
        
    }

    // FONT IS SERIF??
    if ( [[headerDictionary objectForKey:@"edition_is_serif"] boolValue]) {
        editionIsSerif = TRUE;
    } else {
        editionIsSerif = FALSE;
    }

}
- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewReload) name:@"PaprItemVC.tableViewReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTheBumpHintUp) name:@"PaprItemVC.showTheBumpHintUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationButton) name:@"PaprItemVC.updateNotificationButton" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprItemVC.showTheBumpHintUp" object:nil];
    
}
- (void) setupHeightVariables {

    // ALL VARIABLES ARE PROPORTIONAL TO 750x1334 (375x667)
    screenHeight = [[DataController dc] returnRelativeSizeForThisScreen: 667 ];
    cellFontSizeHero = [[DataController dc] returnRelativeSizeForThisScreen: 20 ];
    cellFontSizeNormal = [[DataController dc] returnRelativeSizeForThisScreen: 15 ];
    cellHeroImageWidth = [[DataController dc] returnRelativeSizeForThisScreen: 375 ];
    cellHeroImageHeight = [[DataController dc] returnRelativeSizeForThisScreen: 225 ];
    cellTextWidth = [[DataController dc] returnRelativeSizeForThisScreen: 331 ];
    cellTextMarginTop = [[DataController dc] returnRelativeSizeForThisScreen: 20 ];
    cellTextMarginLeft = [[DataController dc] returnRelativeSizeForThisScreen: 15 ];
    
    cellHeroHeight_01 = [[DataController dc] returnRelativeSizeForThisScreen: 300 ];
    cellHeroHeight_02 = [[DataController dc] returnRelativeSizeForThisScreen: 325 ];
    cellHeroHeight_03 = [[DataController dc] returnRelativeSizeForThisScreen: 350 ];
    cellHeroHeight_04 = [[DataController dc] returnRelativeSizeForThisScreen: 375 ];

    cellNormalHeight_01 = [[DataController dc] returnRelativeSizeForThisScreen: 74 ];
    cellNormalHeight_02 = [[DataController dc] returnRelativeSizeForThisScreen: 98 ];
    cellNormalHeight_03 = [[DataController dc] returnRelativeSizeForThisScreen: 86 ];
    cellNormalHeight_04 = [[DataController dc] returnRelativeSizeForThisScreen: 73 ];

    cellHeightContentNormal_01 = 52;
    cellHeightContentNormal_02 = 72;
    cellHeightContentNormal_03 = 92;

    // ESTABLISH NON-DYNAMIC HEIGHTS
    if ([[UIScreen mainScreen] bounds].size.width < 321) {
        screenHeight = 568;
        cellFontSizeNormal = 17;
        cellFontSizeHero = 17;
        cellHeroImageWidth = 320;
        cellHeroImageHeight = 192;
        cellTextWidth = 290;
        cellTextMarginTop = 26;
        cellTextMarginLeft = 13;
        cellHeightContentNormal_01 = 73;
        cellHeightContentNormal_02 = 73;
        cellHeightContentNormal_03 = 73;
    } else if ([[UIScreen mainScreen] bounds].size.width < 376) {
        // CHILL BC/ WE ALREADY SET THIS UP.
    } else if ([[UIScreen mainScreen] bounds].size.width < 415) {
        screenHeight = 736;
        cellFontSizeNormal = 15;
        cellFontSizeHero = 20;
        cellHeroImageWidth = 414;
        cellHeroImageHeight = 248;
        cellTextWidth = 375;
        cellTextMarginTop = 33;
        cellTextMarginLeft = 17;
        cellHeightContentNormal_01 = 98;
        cellHeightContentNormal_02 = 98;
        cellHeightContentNormal_03 = 98;
    }
    
}
- (void) setupArrayOfLineHints {

    self.arrayOfLineHints = [[NSMutableArray alloc] init];
    
    int lineCount = 0;
    int lineCountHero = 0;
    int subHeroCounter = 0;
    int subHeroLimiter = 0;

    int indexCounter = 0;
    self.arrayOfHeroIndexes = [[NSMutableArray alloc] init];
    
    pageTotal = 0;
    pageCurrent = 1;

    for (NSDictionary *thisCellDictionary in self.arrayOfPaprItems) {
        
        NSString *cellTitle = [thisCellDictionary objectForKey:@"post_title"];
        NSString *cellType;
        NSString *cellHasImage;
        NSString *cellLineCount;
        
        if (editionIsHeroText) {
        
            
            
        } else if (subHeroCounter == 0) {

            // DO WE HAVE A HEADER IMAGE?
            if ( [[thisCellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {

                // TODO: GGXGG:
                // FOR NOW TREAT EVERYTHING LIKE IT HAS AN IMAGE
                // EVENTUALLY, THIS WILL BE WHERE WE START THE PLAN TO DEFAULT EVERYTHING TO TEXT:
                // editionIsHeroText = TRUE;

                cellType = @"heroFull";
                cellHasImage = @"1";
            
            } else {
            
                cellType = @"heroFull";
                cellHasImage = @"1";
            
            }

            // HOW MANY LINES IS THE HERO TEXT?
            lineCount = [[DataController dc] returnNumberOfLinesForTextCell : cellTitle : editionIsSerif : cellTextWidth : cellFontSizeHero];
            lineCountHero = lineCount;
            cellLineCount = [NSString stringWithFormat:@"%i", lineCount];

            // HOW MANY SUBHERO CELLS
            subHeroCounter++;

            if (lineCount > 1) {
                subHeroLimiter = 2;
            } else {
                subHeroLimiter = 3;
            }
            
            // UPDATE TOTAL PAGES
            pageTotal++;

            // UPDATE HERO INDEX
            NSString *thisIndex = [NSString stringWithFormat:@"%i", indexCounter];
            [self.arrayOfHeroIndexes insertObject:thisIndex atIndex:self.arrayOfHeroIndexes.count];
            
        } else {
        
            cellType = [NSString stringWithFormat:@"normal_0%i", lineCountHero];
            cellHasImage = @"0";

            // HOW MANY LINES IS THE NORMAL TEXT?
            lineCount = [[DataController dc] returnNumberOfLinesForTextCell : cellTitle : editionIsSerif : cellTextWidth : cellFontSizeNormal];
            cellLineCount = [NSString stringWithFormat:@"%i", lineCount];

            // ARE WE GOING TO STAY IN THIS HERO'S SECTION?
            if (subHeroCounter >= subHeroLimiter) {
                subHeroCounter = 0;
            } else {
                subHeroCounter++;
            }
            
            
        }

        // ADD HINTS TO DICTIONARY, ADD DICTIONARY TO ARRAY
        NSDictionary *hintDictionary = @{@"cellType":cellType,
                                         @"cellHasImage":cellHasImage,
                                         @"cellLineCount":cellLineCount};

        [self.arrayOfLineHints insertObject:hintDictionary atIndex:self.arrayOfLineHints.count];

        // INCREMENT FOR HERO INDEX ARRAY
        indexCounter++;
        
    }

    [self checkEditionForHeroImageIntegrity];
    
    [self updatePageCounter];

    NSLog(@"self.arrayOfLineHints = %@", self.arrayOfLineHints);
    
}
- (void) checkEditionForHeroImageIntegrity {

    for (NSString *thisIndex in self.arrayOfHeroIndexes) {
    
        int actualIndex = [thisIndex intValue];
        
        NSDictionary *thisCellHintDictionary = [self.arrayOfLineHints objectAtIndex: actualIndex];
        
        int cellHasImage = [[thisCellHintDictionary objectForKey:@"cellHasImage"] intValue];
        
        if (cellHasImage) {
            // ALRIGHT, ALRIGHT... SO FAR, SO GOOD.
        } else {
            editionIsHeroText = TRUE;
        }
        
    }
    
}
- (void) showTheBumpHintUp {

    if (self.paprTag == 2) {

        [self.tableViewPapr setContentOffset:CGPointMake(0,100) animated:YES];
        
        [self performSelector:@selector(showTheBumpHintDown) withObject:nil afterDelay:0.5];

    }

}
- (void) showTheBumpHintDown {

    [self.tableViewPapr setContentOffset:CGPointMake(0,0) animated:YES];

}

#pragma mark - GESTURE METHODS

- (void) setupSwipeGestures {

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];

    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDown];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableViewPapr addGestureRecognizer:swipeRight];

}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    NSLog(@"PaprItemVC . gestureRecognizer");

//    CGPoint touchLocation = [touch locationInView:self.view];
    
//    if (touchLocation.x > 30) {
//        cellShouldOpen = TRUE;
//    } else {
//        cellShouldOpen = FALSE;
//    }
    
    return NO;

}
- (void) swipeUp : (id)sender {
    
    NSLog(@"PaprItemVC . swipeUp");
    
    if (pageCurrent < pageTotal) {

        NSLog(@"PaprItemVC . swipeUp . self.arrayOfHeroIndexes = %@", self.arrayOfHeroIndexes);
        int cellDestination = [[self.arrayOfHeroIndexes objectAtIndex:pageCurrent] intValue];
        NSLog(@"PaprItemVC . swipeUp . cellDestination = %i", cellDestination);
        NSLog(@"PaprItemVC . swipeUp . self.arrayOfPaprItems = %@", self.arrayOfPaprItems);
        NSLog(@"PaprItemVC . swipeUp . self.arrayOfPaprItems.count = %i", self.arrayOfPaprItems.count);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellDestination inSection:0];
        [self.tableViewPapr scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        pageCurrent++;
        
        [self updatePageCounter];
        
    }

}
- (void) swipeDown : (id)sender {

    NSLog(@"PaprItemVC . swipeDown");

    if (pageCurrent > 1) {

        NSLog(@"PaprItemVC . swipeDown . self.arrayOfHeroIndexes = %@", self.arrayOfHeroIndexes);
        NSLog(@"PaprItemVC . swipeDown . self.arrayOfPaprItems.count = %i", (int)self.arrayOfPaprItems.count);
        int cellDestination = [[self.arrayOfHeroIndexes objectAtIndex:pageCurrent-2] intValue];
        NSLog(@"PaprItemVC . swipeDown . cellDestination = %i", cellDestination);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellDestination inSection:0];
        [self.tableViewPapr scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

        pageCurrent--;

        [self updatePageCounter];

    }

}
- (void) swipeLeft : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToLeft" object:nil];
    
}
- (void) swipeRight : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToRight" object:nil];
    
}
- (void) swipeAlert {
    
    NSDictionary *alertDictionary = @{@"alert_type":@"swipe_papr"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprAlertVC" object:nil userInfo:alertDictionary];
    
}
- (void) updatePageCounter {

    NSString *pageCountString = [NSString stringWithFormat:@"%i of %i", pageCurrent, pageTotal];
    
    self.labelPageCount.text = pageCountString;
    
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

    if (self.arrayOfPaprItems.count > 0) {
        return self.arrayOfPaprItems.count + 1; // ALL ROWS PLUS FOOTER
    } else {
        return 0;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.row = %i", (int)indexPath.row);
    NSLog(@"self.arrayOfPaprItems.count + 1 = %i", (int)self.arrayOfPaprItems.count + 1);
    
    // THIS IS THE CELL FOOTER
    if (indexPath.row >= self.arrayOfPaprItems.count) {
        return 500;
    }

    // THIS IS THE WORLD OF HERO TEXT (NO IMAGES)
    if (editionIsHeroText) {
        //return 100;
        // CHANGE EVERYTHING HERE, WE ENTER INTO HERO ZONE.
    }

    NSDictionary *thisCellHintDictionary = [self.arrayOfLineHints objectAtIndex: indexPath.row ];
    NSLog(@"thisCellHintDictionary = %@", thisCellHintDictionary);
    NSString *cellType = [thisCellHintDictionary objectForKey:@"cellType"];
    int cellLineCount = [[thisCellHintDictionary objectForKey:@"cellLineCount"] intValue];

    NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: indexPath.row ];
    NSLog(@"post_publisher = %@", [thisCellDictionary objectForKey:@"post_publisher"]);
    NSLog(@"post_title = %@", [thisCellDictionary objectForKey:@"post_title"]);
    NSLog(@"thisCellDictionary = %@", thisCellDictionary);

    
    if ( [cellType isEqualToString:@"heroFull"] ) {
        
        if (cellLineCount == 1) {
            cellHeroHeight = cellHeroHeight_01;
        } else if (cellLineCount == 2) {
            cellHeroHeight = cellHeroHeight_02;
        } else if (cellLineCount == 3) {
            cellHeroHeight = cellHeroHeight_03;
        } else if (cellLineCount == 4) {
            cellHeroHeight = cellHeroHeight_04;
        } else {
            // DEFAULT TO 03, JUST IN CASE.
            cellHeroHeight = cellHeroHeight_03;
        }
        
        return cellHeroHeight;
        
    } else if ( [cellType isEqualToString:@"heroText"] ) {
        
        if (cellLineCount == 1) {
            cellHeroHeight = cellHeroHeight_01 - cellHeroImageHeight;
        } else if (cellLineCount == 2) {
            cellHeroHeight = cellHeroHeight_02 - cellHeroImageHeight;
        } else if (cellLineCount == 3) {
            cellHeroHeight = cellHeroHeight_03 - cellHeroImageHeight;
        } else if (cellLineCount == 4) {
            cellHeroHeight = cellHeroHeight_04 - cellHeroImageHeight;
        } else {
            // DEFAULT TO 03, JUST IN CASE.
            cellHeroHeight = cellHeroHeight_03 - cellHeroImageHeight;
        }
        
        return cellHeroHeight;
        
    } else {

        if ( [cellType isEqualToString:@"normal_01"] ) {
            return cellNormalHeight_01;
        } else if ( [cellType isEqualToString:@"normal_02"] ) {
            return cellNormalHeight_02;
        } else if ( [cellType isEqualToString:@"normal_03"] ) {
            return cellNormalHeight_03;
        } else if ( [cellType isEqualToString:@"normal_04"] ) {
            return cellNormalHeight_04;
        } else {
            return cellNormalHeight_03;
        }

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row >= self.arrayOfPaprItems.count) {
        
        // THIS IS THE FOOTER
        return [self returnPaprCellFooter];
        
    }

    NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: indexPath.row ];
    NSDictionary *thisCellHintDictionary = [self.arrayOfLineHints objectAtIndex: indexPath.row ];
    NSString *cellType = [thisCellHintDictionary objectForKey:@"cellType"];
    int cellLineCount = [[thisCellHintDictionary objectForKey:@"cellLineCount"] intValue];

    if ( [cellType isEqualToString:@"heroFull"] ) {

        if (cellLineCount == 1) {
            return [self returnPaprCellHeroFull01 : thisCellDictionary : indexPath];
        } else if (cellLineCount == 2) {
            return [self returnPaprCellHeroFull02 : thisCellDictionary : indexPath];
        } else if (cellLineCount == 3) {
            return [self returnPaprCellHeroFull03 : thisCellDictionary : indexPath];
        } else if (cellLineCount == 4) {
            return [self returnPaprCellHeroFull04 : thisCellDictionary : indexPath];
        } else {
            return [self returnPaprCellHeroFull03 : thisCellDictionary : indexPath];
        }
        
    } else if ( [cellType isEqualToString:@"heroText"] ) {
        
        // GGXGG
        editionIsHeroText = TRUE;
        
        return [self returnPaprCellHeroText : thisCellDictionary : indexPath];

    } else {

        if (editionIsHeroText) {
        
            if (indexPath.row < 5) {
                return [self returnPaprCellTextBoring : thisCellDictionary : indexPath];
            }
            
        } else if ( [cellType isEqualToString:@"normal_01"] ) {
            return [self returnPaprCellText01 : thisCellDictionary : indexPath];
        } else if ( [cellType isEqualToString:@"normal_02"] ) {
            return [self returnPaprCellText02 : thisCellDictionary : indexPath];
        } else if ( [cellType isEqualToString:@"normal_03"] ) {
            return [self returnPaprCellText03 : thisCellDictionary : indexPath];
        } else if ( [cellType isEqualToString:@"normal_04"] ) {
            return [self returnPaprCellText04 : thisCellDictionary : indexPath];
        }

        return [self returnPaprCellText03 : thisCellDictionary : indexPath];

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"PaprItemVC . didSelectRowAtIndexPath");

    [self.tableViewPapr deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row >= self.arrayOfPaprItems.count) {
        
        // THIS IS THE FOOTER
        return;
        
    }
    
    if ([DataController dc].cellSliderIsMoving) {

        return;
    
    } else if ([DataController dc].cellSliderIsOpen) {
    
        [self tableViewCloseOpenCells];

        return;
    }

    NSDictionary *cellDictionary = [self.arrayOfPaprItems objectAtIndex:indexPath.row];
 
    NSString *cellURL = [cellDictionary objectForKey:@"post_link"];
    
    NSLog(@"cellURL = %@", cellURL);
    
    if (cellURL.length < 7) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:cellURL];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
    
    [self showViewController:safariVC sender:nil];

    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Viewed"}];

}
- (PaprCellFull *) returnPaprCellHeroFull : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    // METHOD VARIABLES
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellFull *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellFull" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        
        cell.cellDictionary = thisCellDictionary;
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        cell.labelText.alpha = 0.0;
        
        // ADD YOUTUBE ICON?
        NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
        if (postLink.length > 20) {
            if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
                //            cell.imageViewIcon.alpha = 1.0;
                //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
            }
        }
        
        // HERO TEXT LABEL
        NSDictionary *thisCellHintDictionary = [self.arrayOfLineHints objectAtIndex: indexPath.row ];
        int cellHeroLineCount = [[thisCellHintDictionary objectForKey:@"cellLineCount"] intValue];
        [cell.viewSlider addSubview: [self returnHeroTextLabel : [thisCellDictionary objectForKey:@"post_title"] : cellHeroLineCount] ];

        NSLog(@"cell.viewSlider.frame.size.height . B4 = %f", cell.viewSlider.frame.size.height);

        cell.viewSlider.frame = CGRectMake(0,0,375,50);
        [cell.viewSlider setNeedsLayout];
        [cell.viewSlider setNeedsDisplay];
        [cell setNeedsLayout];
        [cell setNeedsDisplay];
        cell.viewSlider.backgroundColor = [UIColor cyanColor];

        // GREY FOOTER LINE
        NSString *cellType = [thisCellHintDictionary objectForKey:@"cellType"];
        
        int cellFooterOriginY;
        
        if ( [cellType isEqualToString:@"heroFull"] ) {
            
            if (cellHeroLineCount == 1) {
                cellFooterOriginY = cellHeroHeight_01;
            } else if (cellHeroLineCount == 2) {
                cellFooterOriginY = cellHeroHeight_02;
            } else if (cellHeroLineCount == 3) {
                cellFooterOriginY = cellHeroHeight_03;
            } else if (cellHeroLineCount == 4) {
                cellFooterOriginY = cellHeroHeight_04;
            } else {
                // DEFAULT TO 03, JUST IN CASE.
                cellFooterOriginY = cellHeroHeight_03;
            }
            
        }
        
        [cell.viewSlider addSubview: [self returnCellFooterLineWithHeight : cell.viewSlider.frame.size.height] ];

    }
    
    // LOAD HERO IMAGE
    if ( [[thisCellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        // IL Y A RIEN ICI
    } else {
        NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        UIImageView *imageViewHero = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight)];
        imageViewHero.frame = CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight);
        imageViewHero.contentMode = UIViewContentModeScaleAspectFill;
        imageViewHero.clipsToBounds = TRUE;
        [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageViewHero.image = image;
            [cell addSubview:imageViewHero];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
    }
    
    
    // FIN
    return cell;
    
}
- (PaprCellHeroFull01 *) returnPaprCellHeroFull01 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    // METHOD VARIABLES
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellHeroFull01 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellHeroFull01" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        
        cell.cellDictionary = thisCellDictionary;
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD YOUTUBE ICON?
        NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
        if (postLink.length > 20) {
            if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
                //            cell.imageViewIcon.alpha = 1.0;
                //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
            }
        }
        
    }
    
    // LOAD HERO IMAGE
    if ( [[thisCellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        // IL Y A RIEN ICI
    } else {
        NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        UIImageView *imageViewHero = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight)];
        imageViewHero.frame = CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight);
        imageViewHero.contentMode = UIViewContentModeScaleAspectFill;
        imageViewHero.clipsToBounds = TRUE;
        [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageViewHero.image = image;
            [cell addSubview:imageViewHero];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
    }
    
    
    // FIN
    return cell;
    
}
- (PaprCellHeroFull02 *) returnPaprCellHeroFull02 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    // METHOD VARIABLES
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellHeroFull02 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellHeroFull02" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        
        cell.cellDictionary = thisCellDictionary;
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD YOUTUBE ICON?
        NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
        if (postLink.length > 20) {
            if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
                //            cell.imageViewIcon.alpha = 1.0;
                //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
            }
        }
        
    }
    
    // LOAD HERO IMAGE
    if ( [[thisCellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        // IL Y A RIEN ICI
    } else {
        NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        UIImageView *imageViewHero = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight)];
        imageViewHero.frame = CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight);
        imageViewHero.contentMode = UIViewContentModeScaleAspectFill;
        imageViewHero.clipsToBounds = TRUE;
        [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageViewHero.image = image;
            [cell addSubview:imageViewHero];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
    }
    
    
    // FIN
    return cell;
    
}
- (PaprCellHeroFull03 *) returnPaprCellHeroFull03 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    // METHOD VARIABLES
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellHeroFull03 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellHeroFull03" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        
        cell.cellDictionary = thisCellDictionary;
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD YOUTUBE ICON?
        NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
        if (postLink.length > 20) {
            if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
                //            cell.imageViewIcon.alpha = 1.0;
                //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
            }
        }
        
    }
    
    // LOAD HERO IMAGE
    if ( [[thisCellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        // IL Y A RIEN ICI
    } else {
        NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        UIImageView *imageViewHero = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight)];
        imageViewHero.frame = CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight);
        imageViewHero.contentMode = UIViewContentModeScaleAspectFill;
        imageViewHero.clipsToBounds = TRUE;
        [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageViewHero.image = image;
            [cell addSubview:imageViewHero];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
    }
    
    
    // FIN
    return cell;
    
}
- (PaprCellHeroFull04 *) returnPaprCellHeroFull04 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    // METHOD VARIABLES
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellHeroFull04 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellHeroFull04" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        
        cell.cellDictionary = thisCellDictionary;
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD YOUTUBE ICON?
        NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
        if (postLink.length > 20) {
            if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
                //            cell.imageViewIcon.alpha = 1.0;
                //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
            }
        }
        
    }
    
    // LOAD HERO IMAGE
    if ( [[thisCellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        // IL Y A RIEN ICI
    } else {
        NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_image_url"]];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        UIImageView *imageViewHero = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight)];
        imageViewHero.frame = CGRectMake(0,0,cellHeroImageWidth,cellHeroImageHeight);
        imageViewHero.contentMode = UIViewContentModeScaleAspectFill;
        imageViewHero.clipsToBounds = TRUE;
        [cell.imageViewMain setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageViewHero.image = image;
            [cell addSubview:imageViewHero];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            //
        }];
    }
    
    
    // FIN
    return cell;
    
}
- (PaprCellFull *) returnPaprCellHeroText : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellFull *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellFull" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    [cell setTag:indexPath.row];
    
    cell.cellDictionary = thisCellDictionary;
    cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
    cell.labelText.alpha = 0.0;
    
    
    // GREY FOOTER LINE
    NSDictionary *thisCellHintDictionary = [self.arrayOfLineHints objectAtIndex: indexPath.row ];
    int cellHeroLineCount = [[thisCellHintDictionary objectForKey:@"cellLineCount"] intValue];
    [cell addSubview: [self returnHeroTextLabel : [thisCellDictionary objectForKey:@"post_title"] : cellHeroLineCount] ];
    
    // ADD YOUTUBE ICON?
    NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
    if (postLink.length > 20) {
        if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
            //            cell.imageViewIcon.alpha = 1.0;
            //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
        }
    }
    
    
    // GREY FOOTER LINE
    [cell addSubview: [self returnCellFooterLineWithHeight : cellHeroHeight] ];
    
    // FIN
    return cell;
    
}
- (UITableViewCell *) returnPaprCellFooter {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // FIN
    return cell;
    
}
- (PaprCellText01 *) returnPaprCellText01 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellText01 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText01" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        // STUP CELL DICTIONARY
        cell.cellDictionary = thisCellDictionary;
        
        // CHECK FOR YOUTUBE LINK && SET WHETHER LINK EXISTS
        BOOL weHaveLinkage = [self returnLinkStatus:thisCellDictionary];
        
        // ADJUST TEXT/FONT BASED ON SERIF SETTING && LINK STATUS
        cell.labelText.font = [self returnProperFont : weHaveLinkage : editionIsSerif];
        cell.labelText.textColor = [UIColor paprBlackNormal];
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD FOOTER
        [cell addSubview: [self returnCellFooterLineWithHeight : cellNormalHeight_01] ];
        
        // COVER THE BASICS
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        [cell layoutIfNeeded];

    }

    // RETURN
    return cell;
    
}
- (PaprCellText02 *) returnPaprCellText02 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellText02 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText02" owner:self options:nil];
        cell = [nib objectAtIndex:0];

        // STUP CELL DICTIONARY
        cell.cellDictionary = thisCellDictionary;
        
        // CHECK FOR YOUTUBE LINK && SET WHETHER LINK EXISTS
        BOOL weHaveLinkage = [self returnLinkStatus:thisCellDictionary];
        
        // ADJUST TEXT/FONT BASED ON SERIF SETTING && LINK STATUS
        cell.labelText.font = [self returnProperFont : weHaveLinkage : editionIsSerif];
        cell.labelText.textColor = [UIColor paprBlackNormal];
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD FOOTER
        [cell addSubview: [self returnCellFooterLineWithHeight : cellNormalHeight_02] ];
        
        // COVER THE BASICS
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        [cell layoutIfNeeded];

    }
    
    // RETURN
    return cell;
    
}
- (PaprCellText03 *) returnPaprCellText03 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellText03 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText03" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    
        // STUP CELL DICTIONARY
        cell.cellDictionary = thisCellDictionary;
        
        // CHECK FOR YOUTUBE LINK && SET WHETHER LINK EXISTS
        BOOL weHaveLinkage = [self returnLinkStatus:thisCellDictionary];
        
        // ADJUST TEXT/FONT BASED ON SERIF SETTING && LINK STATUS
        cell.labelText.font = [self returnProperFont : weHaveLinkage : editionIsSerif];
        cell.labelText.textColor = [UIColor paprBlackNormal];
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD FOOTER
        [cell addSubview: [self returnCellFooterLineWithHeight : cellNormalHeight_03] ];
        
        // COVER THE BASICS
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        [cell layoutIfNeeded];

    }
    
    // RETURN
    return cell;
    
}
- (PaprCellText01 *) returnPaprCellText04 : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellText01 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText01" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    // STUP CELL DICTIONARY
    cell.cellDictionary = thisCellDictionary;
    
    // CHECK FOR YOUTUBE LINK && SET WHETHER LINK EXISTS
    BOOL weHaveLinkage = [self returnLinkStatus:thisCellDictionary];
    
    // ADJUST TEXT/FONT BASED ON SERIF SETTING && LINK STATUS
    cell.labelText.font = [self returnProperFont : weHaveLinkage : editionIsSerif];
    cell.labelText.textColor = [UIColor paprBlackNormal];
    cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
    
    // ADD FOOTER
    [cell addSubview: [self returnCellFooterLineWithHeight : cellNormalHeight_04] ];

    // COVER THE BASICS
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    [cell setTag:indexPath.row];
    [cell layoutIfNeeded];
    
    // RETURN
    return cell;
    
}
- (PaprCellText01 *) returnPaprCellTextBoring : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellText01 *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText01" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        // STUP CELL DICTIONARY
        cell.cellDictionary = thisCellDictionary;
        
        // CHECK FOR YOUTUBE LINK && SET WHETHER LINK EXISTS
        BOOL weHaveLinkage = [self returnLinkStatus:thisCellDictionary];
        
        // ADJUST TEXT/FONT BASED ON SERIF SETTING && LINK STATUS
        cell.labelText.font = [self returnProperFont : weHaveLinkage : editionIsSerif];
        cell.labelText.textColor = [UIColor paprBlackNormal];
        cell.labelText.text = [self returnProperLabelText : thisCellDictionary];
        
        // ADD FOOTER
        [cell addSubview: [self returnCellFooterLineWithHeight : cellNormalHeight_01] ];
        
        // COVER THE BASICS
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        [cell setTag:indexPath.row];
        [cell layoutIfNeeded];
        
    }
    
    // RETURN
    return cell;
    
}

- (BOOL) returnLinkStatus : (NSDictionary *)dictionaryRCVD {

    NSString *postLink = [dictionaryRCVD objectForKey:@"post_link"];

    if (postLink.length > 20) {
        return YES;
    } else {
        return NO;
    }

    //        if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
    //            //            cell.imageViewIcon.alpha = 1.0;
    //            //            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
    //        }

}
- (UIFont *) returnProperFont : (BOOL)linkage : (BOOL)serif {

    UIFont *returnFont;
    
    if (serif) {
        
        // THIS IS SERIF
        if (linkage) {
            returnFont = [UIFont fontWithName:@"Georgia-Bold" size:cellFontSizeNormal];
        } else {
            returnFont = [UIFont fontWithName:@"Georgia" size:cellFontSizeNormal];
        }
        
    } else {
        
        // SANS SERIF
        if (linkage) {
            returnFont = [UIFont systemFontOfSize:cellFontSizeNormal weight:UIFontWeightBold];

        } else {
            returnFont = [UIFont systemFontOfSize:cellFontSizeNormal weight:UIFontWeightRegular];
        }

    }

    return returnFont;
    
}
- (NSString *) returnProperLabelText : (NSDictionary *)dictionaryRCVD {

    NSString *cellTextString = [dictionaryRCVD objectForKey:@"post_title"];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    
    return cellTextString;

    
}

- (PaprCellText *) returnPaprCellText : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellText *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // ESTABLISH CELL HEIGHT
    int cellHeight;
    NSDictionary *thisHintDictionary = [self.arrayOfLineHints objectAtIndex: indexPath.row ];
    int cellNormalLineCount = [[thisHintDictionary objectForKey:@"cellLineCount"] intValue];
    
    if (cellNormalLineCount == 1) {
        cellHeight = cellHeightContentNormal_01 + cellTextMarginTop;
    } else if (cellNormalLineCount == 2) {
        cellHeight = cellHeightContentNormal_02 + cellTextMarginTop;
    } else if (cellNormalLineCount == 3) {
        cellHeight = cellHeightContentNormal_03 + cellTextMarginTop;
    } else {
        cellHeight = cellHeightContentNormal_02 + cellTextMarginTop;
    }

    BOOL weHaveLinkage;
    cell.cellDictionary = thisCellDictionary;
    NSString *cellTextString = [thisCellDictionary objectForKey:@"post_title"];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"</em>" withString:@""];

    // LABEL = DYNAMIC
    UILabel *labelTextNormal = [[UILabel alloc] init];
    labelTextNormal.frame = CGRectMake(cellTextMarginLeft,0,cellTextWidth,cellHeight);
    
    // FONT IS SERIF??
    if ( editionIsSerif ) {
        UIFont *font = cell.labelText.font;
        labelTextNormal.font = [font fontWithSize:cellFontSizeNormal];
    } else {
        [labelTextNormal setFont: [UIFont systemFontOfSize:cellFontSizeNormal weight:UIFontWeightHeavy] ];
    }
    labelTextNormal.text = [thisCellDictionary objectForKey:@"post_title"];
    labelTextNormal.textColor = [UIColor paprBlackNormal];
    labelTextNormal.numberOfLines = 0;
    //labelTextNormal.backgroundColor = [UIColor cyanColor];
    [cell addSubview:labelTextNormal];

    
//    NSString *georgiaTEST = @"Supreme Court says trump travel ban can go into effect for now Supreme Court says trump travel ban can go into effect for now";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: georgiaTEST ];
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: cellTextString ];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 3.0;
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cellTextString.length)];
//    [attributedString addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, cellTextString.length)];
//    cell.labelText.attributedText = attributedString;

    cell.labelText.text = cellTextString;
    
    NSLog(@"cell.labelText.font = %@", cell.labelText.font); //HiraMinProN-W6
    
    
    // CHECK FOR YOUTUBE LINK && SET WHETHER LINK EXISTS
    NSString *postLink = [thisCellDictionary objectForKey:@"post_link"];
    
    if (postLink.length > 20) {
        
        weHaveLinkage = TRUE;
        
        if ([postLink containsString:@"youtube.com"] || [postLink containsString:@"youtu.be"]) {
            
            cell.imageViewIcon.alpha = 1.0;
            cell.imageViewIcon.image = [UIImage imageNamed:@"icon_video.png"];
            
        }
        
    } else {
        
        weHaveLinkage = FALSE;
        
    }
    
    // ADJUST FONT BASED ON SERIF SETTING && LINK STATUS
    
    if ( editionIsSerif ) {
        
        // THIS IS SERIF
        if (weHaveLinkage) {
            cell.labelText.font = [UIFont fontWithName:@"Georgia-Bold" size:cellFontSizeNormal];
        } else {
            cell.labelText.font = [UIFont fontWithName:@"Georgia" size:cellFontSizeNormal];
        }
        
    } else {
        
        // SANS SERIF
        if (weHaveLinkage) {
            [cell.labelText setFont: [UIFont systemFontOfSize:cellFontSizeNormal weight:UIFontWeightHeavy] ];
        } else {
            [cell.labelText setFont: [UIFont systemFontOfSize:cellFontSizeNormal weight:UIFontWeightRegular] ];
            
        }
        
        
    }

    [cell addSubview: [self returnCellFooterLineWithHeight : cellHeight] ];;

    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    [cell layoutIfNeeded];
    
    return cell;
    
}
- (PaprCellPhoto *) returnPaprCellPhoto : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    PaprCellPhoto *cell = [self.tableViewPapr dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
    NSString *cellTextString = [thisCellDictionary objectForKey:@"post_title"];
    
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cellTextString = [cellTextString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: cellTextString ];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cellTextString.length)];
    [attributedString addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, cellTextString.length)];
    
    cell.labelText.attributedText = attributedString;
    
    if ( editionIsSerif ) {
        UIFont *font = cell.labelText.font;
        cell.labelText.font = [font fontWithSize:cellFontSizeNormal];
    } else {
        [cell.labelText setFont: [UIFont systemFontOfSize:cellFontSizeNormal weight:UIFontWeightHeavy] ];
    }
    
    if (fullHeaderIsOn) {
//        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentNormal - 4] ];;
    } else {
//        [cell addSubview: [self returnCellFooterLineWithHeight : cellHeightContentNormal] ];;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    [cell layoutIfNeeded];
    
    return cell;
    
}
- (UILabel *) returnHeroTextLabel : (NSString *)heroTextString : (int)heroLineCount {
    
    int cellTextHeight;
    
    UILabel *labelTextHero = [[UILabel alloc] init];
    
    if (heroLineCount == 1) {
        cellTextHeight = cellHeroHeight_01 - cellHeroImageHeight;
    } else if (heroLineCount == 2) {
        cellTextHeight = cellHeroHeight_02 - cellHeroImageHeight;
    } else if (heroLineCount == 3) {
        cellTextHeight = cellHeroHeight_03 - cellHeroImageHeight;
    } else if (heroLineCount == 4) {
        cellTextHeight = cellHeroHeight_04 - cellHeroImageHeight;
    } else {
        cellTextHeight = cellHeroHeight_03 - cellHeroImageHeight;
    }
    
    labelTextHero.frame = CGRectMake(cellTextMarginLeft,0,cellTextWidth,cellTextHeight);
    //labelTextHero.backgroundColor = [UIColor cyanColor];
    labelTextHero.numberOfLines = 0;
    // FONT IS SERIF??
    if ( editionIsSerif ) {
        labelTextHero.font = [UIFont fontWithName:@"Georgia-Bold" size:cellFontSizeHero];
    } else {
        labelTextHero.font = [UIFont systemFontOfSize:cellFontSizeHero weight:UIFontWeightHeavy];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: heroTextString ];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, heroTextString.length)];
    [attributedString addAttribute:NSKernAttributeName value:@-0.5 range:NSMakeRange(0, heroTextString.length)];
    labelTextHero.attributedText = attributedString;
    
    labelTextHero.textColor = [UIColor paprBlackHero];
    labelTextHero.numberOfLines = 0;
    
    return labelTextHero;
    
}

- (UIView *) returnCellFooterLineWithHeight : (int)heightRCVD {

    float viewOriginX = [[DataController dc] returnRelativeSizeForThisScreen:15];
    float viewOriginY = [[DataController dc] returnRelativeSizeForThisScreen:heightRCVD] - 2;
    float viewSizeX = [[DataController dc] returnRelativeSizeForThisScreen:345];
    float viewSizeY = 1;

    
    UIView *viewLine = [[UIView alloc] init];
    viewLine.frame = CGRectMake(viewOriginX, viewOriginY, viewSizeX, viewSizeY);
    viewLine.backgroundColor = [UIColor paprGreyVeryLight];
    
    return viewLine;

}
- (void) tableViewReload {
    
    NSLog(@"PaprItemVC . tableViewReload");
    [self.tableViewPapr reloadData];
    
}
- (void) tableViewCloseOpenCells {
    
    NSDictionary *headerDictionary = [self.paprDictionary objectForKey:@"EDITION_HEADER"];
    
    if ([DataController dc].cellOpenDictionary) {
        
        int indexPathRow = [[[DataController dc].cellOpenDictionary objectForKey:@"tag"] intValue];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPathRow inSection:0];
        
        if ( [[[DataController dc].cellOpenDictionary objectForKey:@"type"] isEqualToString:@"image"]) {

            PaprCellPhoto *currentOpenCell = [self.tableViewPapr cellForRowAtIndexPath:indexPath];
        
            if ( [currentOpenCell respondsToSelector:@selector(resetCell)] ) {
                
                [currentOpenCell resetCell];
                
            }
        
        } else if ( [[[DataController dc].cellOpenDictionary objectForKey:@"type"] isEqualToString:@"full"]) {
            
            PaprCellFull *currentOpenCell = [self.tableViewPapr cellForRowAtIndexPath:indexPath];
            
            if ( [currentOpenCell respondsToSelector:@selector(resetCell)] ) {
                
                [currentOpenCell resetCell];
                
            }
        
        } else if ( [[headerDictionary objectForKey:@"edition_is_fun"] boolValue]) {

            PaprCellFull *currentOpenCell = [self.tableViewPapr cellForRowAtIndexPath:indexPath];
            
            if ( [currentOpenCell respondsToSelector:@selector(resetCell)] ) {
                
                [currentOpenCell resetCell];
                
            }

        } else if ( [[[DataController dc].cellOpenDictionary objectForKey:@"type"] isEqualToString:@"text"]) {
            
            PaprCellText *currentOpenCell = [self.tableViewPapr cellForRowAtIndexPath:indexPath];
            
            if ( [currentOpenCell respondsToSelector:@selector(resetCell)] ) {
                
                [currentOpenCell resetCell];
                
            }
            
        }

    }
    
}

- (NSString *) returnCircleProgressString {
    
    int tagCount = self.paprTag - 1;
    if (tagCount == 0) {
        tagCount = 1;
    }
    float progressAmount = (float)tagCount / (float)[DataController dc].currentPaprCount;
    
    int progressCircleInteger = roundf(20 * progressAmount);
    
    NSString *progressCircleString;
    
    if (progressCircleInteger < 10) {
        progressCircleString = [NSString stringWithFormat:@"progress_0%i.png", progressCircleInteger];
    } else {
        progressCircleString = [NSString stringWithFormat:@"progress_%i.png", progressCircleInteger];
    }

    NSLog(@"PaprItemVC . progressCircleString = %@", progressCircleString);

    return progressCircleString;
    
}

#pragma mark - Notifications

- (void) updateNotificationButton {
    
    if ([DataController dc].currentNotificationCount > 0) {
    
        
        
    } else {
    
    }

}

#pragma mark API

- (NSArray *) returnArrayOfPaprItemPostIDS {

    NSMutableArray *arrayOfPaprItemsEDITED = [[NSMutableArray alloc] init];
    
    for (NSDictionary *thisPaprDictionary in self.arrayOfPaprItems) {
    
        [arrayOfPaprItemsEDITED addObject:[thisPaprDictionary objectForKey:@"post_id"] ];

    }

    return arrayOfPaprItemsEDITED;
    
}
- (void) sendStats : (NSDictionary *)statsRCVD {

    if (iHaveSentStats) {
        // CHILL
    } else {

        NSDictionary *statsDictionary  = @{@"type_field" : [statsRCVD objectForKey:@"type_field"],
                                           @"post_id_array" : [self returnArrayOfPaprItemPostIDS],
                                           @"publisher_id" : [self.paprDictionary objectForKey:@"PUBLISHER_ID"]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendStats" object:nil userInfo:@{@"stats" : statsDictionary}];
        
        iHaveSentStats = TRUE;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
