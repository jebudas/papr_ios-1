//
//  PaprBaseVC.m
//  papr
//
//  Created by Brian WF Tobin on 2/7/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprBaseVC.h"

@interface PaprBaseVC ()

@end

@implementation PaprBaseVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupCollectionView];
        
    [self setupNotifications];
    
    [self setupSourceRowAndFirstPapr];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"iHaveShownDragAndDropMessage"] ) {
        // CHILL
    } else {
        self.viewDragAndDrop.alpha = 1.0;
    }
    
    [self setupPaprFrames];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}
- (void) setupCollectionView {

    [DataController dc].paprIndexCurrent = 0;

    self.collectionViewSource.scrollEnabled = FALSE;
    self.collectionViewSource.scrollEnabled = TRUE;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *) self.collectionViewSource.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    [self.collectionViewSource registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self.collectionViewSource registerNib:[UINib nibWithNibName:@"PaprSourceCell" bundle:nil] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self.collectionViewSource setBackgroundColor:[UIColor paprWhite250]];

}

- (void) setupPaprFrames {

    frameCenter = self.viewCenter.frame;

    int width = frameCenter.size.width;
    int height = frameCenter.size.height;
    
    frameLeft = CGRectMake(0 - width,frameCenter.origin.y,width,height);
    frameRight = CGRectMake(0 + width,frameCenter.origin.y,width,height);
    
}
- (void) setupNotifications {
    
    // API
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processCommentVotes:) name:@"PaprBaseVC.processCommentVotes" object:nil];
    // EDITING
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnEditingOn) name:@"PaprBaseVC.turnEditingOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSource:) name:@"PaprBaseVC.deleteSource" object:nil];
    // NAVIGATION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprCommentsWithDictionary:) name:@"PaprBaseVC.pushPaprCommentsWithDictionary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprNotificationsWithDictionary:) name:@"PaprBaseVC.pushPaprNotificationsWithDictionary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprPlusWithDictionary:) name:@"PaprBaseVC.pushPaprPlusWithDictionary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaprProfilesWithDictionary:) name:@"PaprBaseVC.pushPaprProfilesWithDictionary" object:nil];
    // SWIPE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSwipeLeft) name:@"PaprBaseVC.setupSwipeLeft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSwipeRight) name:@"PaprBaseVC.setupSwipeRight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(determinePaprScrollAction) name:@"PaprBaseVC.determinePaprScrollAction" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.turnEditingOn" object:nil];

}

#pragma mark - UICOLLECTIONVIEW

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPaprs.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(85, 124);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //    GalleryItemCommentView *commentView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GalleryItemCommentView" forIndexPath:indexPath];
    //    commentView.commentLabel.text = [NSString stringWithFormat:@"Supplementary view of kind %@", kind];
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PaprSourceCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row + 1;

    // LABEL . TEXT
    NSDictionary *editionDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprs objectAtIndex:indexPath.row] ];
    NSDictionary *editonHeaderDictionary = [[NSDictionary alloc] initWithDictionary: [editionDictionary objectForKey:@"EDITION_HEADER"] ];
    
    // AVATAR
    NSURL *imageURL = [NSURL URLWithString:[editonHeaderDictionary objectForKey:@"edition_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        cell.imageViewAvatar.image = [UIImage imageNamed:@"header_empty_avatar_07.png"];
    }];
    
    // DISPLAY NAME
    cell.labelDisplayName.text = [editonHeaderDictionary objectForKey:@"edition_display_name"];
    
    if (userIsEditing) {

        [UIView animateWithDuration: 0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations: ^{
                             cell.buEdit.alpha = 1.0;
                         } completion: ^(BOOL finished){
                             //
                         }
         ];

        // IMAGE . AVATAR
        if (indexPath.row == [DataController dc].paprIndexSelected) {
            [cell setMaskOn];
        } else {
            [cell setMaskOff];
        }

    } else {

        [UIView animateWithDuration: 0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations: ^{
                             cell.buEdit.alpha = 0.0;
                         } completion: ^(BOOL finished){
                             //
                         }
         ];

        if (! self.arrayOfPaprCells) {
            self.arrayOfPaprCells = [[NSMutableArray alloc] init];
        }
        [self.arrayOfPaprCells addObject:cell];

        // IMAGE . AVATAR
        if (indexPath.row == [DataController dc].paprIndexCurrent) {
            [cell setMaskOn];
        } else {
            [cell setMaskOff];
        }

    }

    return cell;

    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (userIsEditing) {

        NSLog(@"didSelectItemAtIndexPath . EDIT");

//        NSIndexPath *indexPathTO = [NSIndexPath indexPathForRow:0 inSection:0];
//        NSIndexPath *indexPathFROM = [NSIndexPath indexPathForRow:1 inSection:0];
//
//        [self.collectionViewSource performBatchUpdates:^{
//            [self.collectionViewSource moveItemAtIndexPath:indexPathFROM toIndexPath:indexPathTO];
//        } completion:^(BOOL finished) {
//            userIsEditing = FALSE;
//        }];

    } else {

        NSLog(@"didSelectItemAtIndexPath . LOAD PAPER");

        [DataController dc].paprIndexSelected = (int)indexPath.row;

        [self determinePaprScrollAction];

        // MIXPANEL
        NSDictionary *editionDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprs objectAtIndex:indexPath.row] ];
        NSDictionary *editonHeaderDictionary = [[NSDictionary alloc] initWithDictionary: [editionDictionary objectForKey:@"EDITION_HEADER"] ];

        NSString *publisherName = [editonHeaderDictionary objectForKey:@"edition_display_name"];
        NSString *sourceString = [NSString stringWithFormat: @"User Selected Source: %@", publisherName];
        [[Mixpanel sharedInstance] track:@"Papr . Sources" properties: @{@"Action": sourceString}];

        
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSLog(@"moveItemAtIndexPath");
//    _cells[sourceIndexPath.row][1] = [NSString stringWithFormat:@"%li", (long)destinationIndexPath.row];
//    _cells[destinationIndexPath.row][1] = [NSString stringWithFormat:@"%li", (long)sourceIndexPath.row];
//    [self saveCellorder];
}
- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - LXReorderableCollectionView DataSource && DelegateFlowLayout METHODS

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {

    NSLog(@"willMoveToIndexPath . originalFromIndex = %i", originalFromIndex);
    NSLog(@"willMoveToIndexPath . fromIndexPath.row = %i", (int)fromIndexPath.row);

    if (originalFromIndex < 0) {
        originalFromIndex = (int)fromIndexPath.row;
    }

    originalToIndex = (int)toIndexPath.row;
    
    //    PlayingCard *playingCard = self.deck[fromIndexPath.item];
//    [self.deck removeObjectAtIndex:fromIndexPath.item];
//    [self.deck insertObject:playingCard atIndex:toIndexPath.item];

}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;

}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {

    NSLog(@"canMoveToIndexPath");

    return YES;

}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
    originalFromIndex = -1;
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
    [self turnEditingOn];
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"will end drag");

}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"did end drag");

    if (originalFromIndex >= 0 && originalFromIndex != originalToIndex) {

        NSDictionary *moveThisDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprs objectAtIndex:originalFromIndex] ];
        
        [self.arrayOfPaprs removeObjectAtIndex:originalFromIndex];
        [self.arrayOfPaprs insertObject:moveThisDictionary atIndex:originalToIndex];
        
        [self.collectionViewSource reloadData];
        
        [[DataController dc] moveUserSubscriptionsFromIndex:originalFromIndex toIndex:originalToIndex];
        
        if ( [DataController dc].paprIndexCurrent == originalFromIndex) {
            postEditingIndex = originalToIndex;
        } else {
            postEditingIndex = -1;
        }
        
    }
    
}

- (void) turnOffEverySourceCell {
    
    int cellCounter = 0;
    
    for (cellCounter = 0; cellCounter < self.arrayOfPaprs.count; cellCounter++) {
        
        NSIndexPath *indexPathCurrent = [NSIndexPath indexPathForRow:cellCounter inSection:0];
        PaprSourceCell *cellOff = (PaprSourceCell *)[self.collectionViewSource cellForItemAtIndexPath:indexPathCurrent];
        [cellOff setMaskOff];
        [cellOff setLabelTextRegular];
    }

}
- (void) updateCurrentSourceCell {

    [self turnOffEverySourceCell];
    
    NSIndexPath *indexPathSelected = [NSIndexPath indexPathForRow:[DataController dc].paprIndexSelected inSection:0];
    PaprSourceCell *cellOn = (PaprSourceCell *)[self.collectionViewSource cellForItemAtIndexPath:indexPathSelected];
    [cellOn setMaskOn];
    [cellOn setLabelTextBold];
    
    [self updateSourceCellOffset];
    
}
- (int) returnHappyOffset : (NSString *)offsetSide {
    
    if ([offsetSide isEqualToString:@"right"]) {
        
        return [DataController dc].paprIndexSelected * 85;

    } else {
        
        int properLeftIndex = [DataController dc].paprIndexSelected - 3;
        if (properLeftIndex < 0) {
            properLeftIndex = 0;
        }
        
        return properLeftIndex * 85;
    }
    
}
- (void) updateSourceCellOffset {
    
    NSLog(@"self.collectionViewSource.contentOffset.x = %f", self.collectionViewSource.contentOffset.x);

    int offsetHappyLeft = [self returnHappyOffset : @"left"];
    int offsetHappyRight = [self returnHappyOffset : @"right"];
    int offsetCurrently = (int)self.collectionViewSource.contentOffset.x;

    if (offsetCurrently >= offsetHappyLeft && offsetCurrently <= offsetHappyRight) {

        // CHILL
        [DataController dc].paprIndexCurrent = [DataController dc].paprIndexSelected;

    } else {
        
        // MOTIVATE
        int offsetX;
        int offsetCheck = [DataController dc].paprIndexCurrent + 2;
        int offsetTweak = [[DataController dc] returnRelativeSizeForThisScreen:20];
        int sourceCellWidth = [[DataController dc] returnRelativeSizeForThisScreen:85];

        if ([DataController dc].paprIndexCurrent < [DataController dc].paprIndexSelected) {
            
            offsetX = (([DataController dc].paprIndexSelected - 3) * sourceCellWidth) - offsetTweak;

        } else {
            
            offsetX = [DataController dc].paprIndexSelected * sourceCellWidth;
            
        }

        [self.collectionViewSource setContentOffset:CGPointMake(offsetX, 0) animated:YES];

        [DataController dc].paprIndexCurrent = [DataController dc].paprIndexSelected;

    }

}

#pragma mark - MAIN CELL METHODS

- (void) returnLineCount {

}
- (UIView *) returnDynamicViewForCell {

    //UIView *
    
    return nil;
    
}

#pragma mark - TOUCH METHODS

- (void) turnEditingOn {
    
    if (userIsEditing) { return; }
    
    userIsEditing = TRUE;
    
    [self.collectionViewSource reloadData];

    self.viewEditingMode.alpha = 0.0;
    [self.view bringSubviewToFront:self.viewEditingMode];
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         self.viewEditingMode.alpha = 1.0;
                     } completion: ^(BOOL finished){
                         //
                     }
     ];

}
- (void) turnEditingOff {
    
    userIsEditing = FALSE;

    [self.collectionViewSource reloadData];

    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         self.viewEditingMode.alpha = 0.0;
                     } completion: ^(BOOL finished){
                        //
                     }
     ];
    
    if (postEditingIndex > 0) {
        
        [DataController dc].paprIndexCurrent = postEditingIndex;
        [DataController dc].paprIndexSelected = postEditingIndex;

        [self updateCurrentSourceCell];

    }
    
}
- (IBAction) buEditingModeSelected : (id)sender {
    
    NSLog(@"buEditingModeSelected");

    [self turnEditingOff];

}
- (void) deleteSource : (NSNotification *)notification {
    
    NSString *sourceTag = [notification.userInfo objectForKey:@"source_tag"];

    [self deleteSourceAlert : sourceTag];

}
- (void) deleteSourceAlert : (NSString*)sourceTag {
    
    int paprIndex = [sourceTag intValue] - 1;
    NSDictionary *deleteThisDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprs objectAtIndex:paprIndex] ];
    NSString *publisherName = [NSString stringWithFormat:@"%@", [[deleteThisDictionary objectForKey:@"EDITION_HEADER"] objectForKey:@"edition_display_name"] ];
    NSString *deleteMessage = [NSString stringWithFormat:@"Are you sure you want to delete %@?", publisherName];
    
    // UIALERT
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Delete?"
                                                                         message:deleteMessage
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionReport = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self deleteSourceActual : sourceTag];
    }];
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    [actionSheet addAction:actionReport];
    [actionSheet addAction:actionCancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
- (void) deleteSourceActual : (NSString*)sourceTag {
    
    int paprIndex = [sourceTag intValue] - 1;
    NSDictionary *deleteThisDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprs objectAtIndex:paprIndex] ];
    NSString *publisherID = [NSString stringWithFormat:@"%@", [deleteThisDictionary objectForKey:@"PUBLISHER_ID"] ];

    ////////////
    
    [self.arrayOfPaprs removeObjectAtIndex:paprIndex];
    
    [self.collectionViewSource reloadData];
    
    [[DataController dc] updateUserSubscriptions:publisherID subscribeToThisUser:NO];
    
    if ([DataController dc].paprIndexCurrent > paprIndex) {
        
        [DataController dc].paprIndexSelected = [DataController dc].paprIndexCurrent - 1;
        
        [self updateCurrentSourceCell];
        
    } else if ([DataController dc].paprIndexCurrent == paprIndex) {

        [DataController dc].paprIndexCurrent = -1;

        if (paprIndex > 0) {
            
            if (self.arrayOfPaprs.count < 3) {
                [DataController dc].paprIndexSelected = 0;
            } else {
                [DataController dc].paprIndexSelected = paprIndex;
            }
            
        } else {
            [DataController dc].paprIndexSelected = 0;
        }

        [self determinePaprScrollAction];

        [self updateCurrentSourceCell];

        [self.view bringSubviewToFront:self.viewEditingMode];

    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
}


#pragma mark - API METHODS

- (void) setupSourceRowAndFirstPapr {

    self.arrayOfUserSubscriptions = [[DataController dc] returnUserSubscriptions];
    
    // RETURN WALL
    if (self.arrayOfUserSubscriptions.count < 1) { return; }
    // RETURN WALL

    NSLog(@"First 3 INIT: %@, %@, %@",
          [self.arrayOfUserSubscriptions objectAtIndex:0], [self.arrayOfUserSubscriptions objectAtIndex:1], [self.arrayOfUserSubscriptions objectAtIndex:2] );

    self.arrayOfPaprs = [[NSMutableArray alloc] init];
    self.arrayOfPaprViews = [[NSMutableArray alloc] initWithObjects:@"PaprTablePlaceholder", @"PaprTablePlaceholder", @"PaprTablePlaceholder", nil];
    
    paprIndexCounter = 0;
    paprSubscriptionCounter = 0;

    [self getNextSubscription];
    
    // DEPRECATED
    
//    for (NSString *thisID in userSubscriptionArray) {
//
//        [self getPaprWithSubscriptionID : thisID];
//
//    }
    
}
- (void) getNextSubscription {
    
    if (paprSubscriptionCounter < self.arrayOfUserSubscriptions.count) {
        
        [self getPaprWithSubscriptionID : [self.arrayOfUserSubscriptions objectAtIndex: paprSubscriptionCounter] ];

    }

}
- (void) getNextSubscriptionAfterFailure {
    
    paprSubscriptionCounter++;
    
    [self getNextSubscription];

}
- (void) testingAdditionOfEdtions {

    NSLog(@"PaprVC . testingAdditionOfEdtions . self.arrayOfPaprs.count = %i", (int)self.arrayOfPaprs.count);

    if (self.arrayOfPaprs.count > 0) {
        
        // WE ALREADY HAVE POPULATED THE FIRST PAPR
        
    } else {
                
        // SETUP PAPRs IN SCROLLVIEW
        // [self setupScrollViewPapr];
        // [self addPaprsToScrollview];
        
        // MIXPANEL
        // [[Mixpanel sharedInstance] identify: [[DataController dc] returnMyUserID] ];
        
        
    }

    
}
- (void) getPaprWithSubscriptionID : (NSString *)idRCVD {

    if (loadingTimerWasStarted) {
        // CHILL
    } else {
        loadingTimerWasStarted = TRUE;
        [self performSelector:@selector(showLabelLoading) withObject:nil afterDelay:5.0];
    }
    
    [DataController dc].currentZone = @"papr";
    
    NSDictionary *publisherDictionary = @{@"publisher_id" : idRCVD};
    
    [[APIController api] getEdition:publisherDictionary success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            NSDictionary *editionDictionary = [[NSDictionary alloc] initWithDictionary: [[responseDictionary objectForKey:@"edition"] objectForKey:@"Item"] ];
            if ( ! editionDictionary ) {
                [self getNextSubscriptionAfterFailure];
                return;
            }
            
            
            NSArray *arrayEditionPosts = [[NSArray alloc] initWithArray: [editionDictionary objectForKey:@"EDITION_POSTS"] ];
            if ( arrayEditionPosts.count == 0 ) {
                [self getNextSubscriptionAfterFailure];
                return;
            }

            
            NSDictionary *editionDictionaryPOSTS = [[NSDictionary alloc] initWithDictionary: [arrayEditionPosts objectAtIndex:0] ];
            if (editionDictionaryPOSTS) {

                NSString *thisTimestamp = [editionDictionaryPOSTS objectForKey:@"post_timestamp"];
                if ( [[DataController dc] thisPostIsFresh: thisTimestamp ] ) {
                    [self.arrayOfPaprs addObject:editionDictionary];
                } else {
                    [self getNextSubscriptionAfterFailure];
                    return;
                }

            } else {
                [self getNextSubscriptionAfterFailure];
                return;
            }

            if (paprIndexCounter > 0) {
                
                // WE ALREADY HAVE POPULATED THE FIRST PAPR

                // TODO . GGXGG . CRASHED HERE ONCE
                //NSLog(@"getPaprWithSubscriptionID . self.arrayOfPaprs = %@", self.arrayOfPaprs);
                NSLog(@"getPaprWithSubscriptionID . self.arrayOfPaprs.count = %i", (int)self.arrayOfPaprs.count);
                NSLog(@"getPaprWithSubscriptionID . paprIndexCounter = %i", paprIndexCounter);
                NSLog(@"getPaprWithSubscriptionID . paprSubscriptionCounter = %i", paprSubscriptionCounter);

                NSIndexPath *indexPathUPDATE = [NSIndexPath indexPathForRow:paprIndexCounter inSection:0];

                NSLog(@"getPaprWithSubscriptionID . indexPathUPDATE = %@", indexPathUPDATE);
                NSLog(@"getPaprWithSubscriptionID . indexPathUPDATE.row = %i", (int)indexPathUPDATE.row);
                NSLog(@"getPaprWithSubscriptionID . ABOUT TO CALL > [self.collectionViewSource insertItemsAtIndexPaths:@[indexPathUPDATE]]");

                [self.collectionViewSource insertItemsAtIndexPaths:@[indexPathUPDATE]];

                paprIndexCounter++;
                paprSubscriptionCounter++;

                [self getNextSubscription];

            } else {
                
                // CANCEL LABEL LOADING TIMER
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLabelLoading) object:nil];

                // ADD FIRST PAPER
                [self addPaprToCenter:editionDictionary];
                [self.collectionViewSource reloadData];
                
                paprIndexCounter++;
                paprSubscriptionCounter++;

                [self getNextSubscription];

                // START LAUNCH ANIMATION
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popViewLaunch" object:nil];
                
                // MIXPANEL
                [[Mixpanel sharedInstance] identify: [[DataController dc] returnMyUserID] ];

            }
            
        } else {
            
            NSLog(@"PaprBaseVC . getPaprWithSubscriptionID . ELSE . responseDictionary = %@", responseDictionary);
            
            [self getNextSubscriptionAfterFailure];

        }
        
    } failure:^(NSError *error) {

        NSLog(@"PaprBaseVC . getPaprWithSubscriptionID . failure . error = %@", error);

        [self getNextSubscriptionAfterFailure];

    }];

}
- (void) processCommentVotes : (NSDictionary *)voteDictionaryRCVD {

    NSLog(@"voteDictionaryRCVD = %@", voteDictionaryRCVD);
    
}
- (void) showLabelLoading {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showLabelLoading" object:nil];
    
}

#pragma mark - NAVIGATION METHODS

- (void) pushPaprCommentsWithDictionary : (NSNotification *)notification {
    
    self.paprCommentsVC = [[PaprCommentsVC alloc] init];
    self.paprCommentsVC.postDictionary = [[NSDictionary alloc] initWithDictionary: [notification.userInfo objectForKey:@"post_dictionary"] ];
    self.paprCommentsVC.commentSetID = [self.paprCommentsVC.postDictionary objectForKey:@"post_id"];
    [self.navigationController pushViewController:self.paprCommentsVC animated:YES];

}
- (void) pushPaprNotificationsWithDictionary : (NSNotification *)notification {
    
    self.paprNotificationsVC = [[PaprNotificationsVC alloc] init];
    [self.navigationController pushViewController:self.paprNotificationsVC animated:YES];
    
}
- (void) pushPaprPlusWithDictionary : (NSNotification *)notification {
    
    self.paprPlusVC = [[PaprPlusVC alloc] init];
    [self.navigationController pushViewController:self.paprPlusVC animated:YES];
    
}
- (void) pushPaprProfilesWithDictionary : (NSNotification *)notification {
    
    self.paprProfilesVC = [[PaprProfilesVC alloc] init];
    [self.navigationController pushViewController:self.paprProfilesVC animated:YES];
    
}
- (void) pushPaprPostSignupVC {
    
    self.paprPostSignupVC = [[PaprPostSignupVC alloc] init];
    [self.navigationController pushViewController:self.paprPostSignupVC animated:YES];
    
}

#pragma mark - PaprTableVC NAVIGATION METHODS

- (void) determinePaprScrollAction {

    if ([DataController dc].paprIndexSelected != [DataController dc].paprIndexCurrent) {
        
        if ([DataController dc].paprIndexSelected == [DataController dc].paprIndexCurrent + 1) {
            
            [self setupSwipeLeft];
            
        } else if ([DataController dc].paprIndexSelected == [DataController dc].paprIndexCurrent - 1) {
            
            [self setupSwipeRight];
            
        } else {
            
            [self addPaprToCenter : [self.arrayOfPaprs objectAtIndex:[DataController dc].paprIndexSelected] ];
            
        }
        
    }

}


- (void) setupSwipeLeft {

    int indexPaprNext = [DataController dc].paprIndexCurrent + 1;
    
    if (indexPaprNext < self.arrayOfPaprs.count) {

        [DataController dc].paprIndexSelected = indexPaprNext;
        
        [self addPaprToRight : [self.arrayOfPaprs objectAtIndex:indexPaprNext] ];
        
        [self activatePaprSwipeLeft];

    }

}
- (void) setupSwipeRight {

    int indexPaprPrevious = [DataController dc].paprIndexCurrent - 1;

    if (indexPaprPrevious >= 0) {

        [DataController dc].paprIndexSelected = indexPaprPrevious;

        [self addPaprToLeft : [self.arrayOfPaprs objectAtIndex:indexPaprPrevious] ];
        
        [self activatePaprSwipeRight];
        
    }

}
- (void) addPaprToLeft:(NSDictionary *)paprDictionaryRCVD {

    // SCROLLVIEW . ADD paprVC
    PaprTableVC *paprTable = [[PaprTableVC alloc] init];
    // paprTable.paprTag = 1;
    paprTable.paprDictionary = [[NSDictionary alloc] initWithDictionary:paprDictionaryRCVD];
    paprTable.view.frame = frameLeft;
    
    [self.view addSubview:paprTable.view];
    [self.arrayOfPaprViews replaceObjectAtIndex:0 withObject:paprTable];

}
- (void) addPaprToCenter:(NSDictionary *)paprDictionaryRCVD {
    
    // SCROLLVIEW . ADD paprVC
    PaprTableVC *paprTable = [[PaprTableVC alloc] init];
    // paprTable.paprTag = 1;
    paprTable.paprDictionary = [[NSDictionary alloc] initWithDictionary:paprDictionaryRCVD];
    paprTable.view.frame = frameCenter;
    
    [self.view addSubview:paprTable.view];
    [self.arrayOfPaprViews replaceObjectAtIndex:1 withObject:paprTable];

    [self updateCurrentSourceCell];

}
- (void) addPaprToRight:(NSDictionary *)paprDictionaryRCVD {
    
    // SCROLLVIEW . ADD paprVC
    PaprTableVC *paprTable = [[PaprTableVC alloc] init];
    // paprTable.paprTag = 1;
    paprTable.paprDictionary = [[NSDictionary alloc] initWithDictionary:paprDictionaryRCVD];
    paprTable.view.frame = frameRight;
    
    [self.view addSubview:paprTable.view];
    [self.arrayOfPaprViews replaceObjectAtIndex:2 withObject:paprTable];
    
}
- (void) addPapr:(NSDictionary *)paprDictionaryRCVD toLocation:(CGRect)frameRCVD {
    
    NSLog(@"addPaprToLocationCenter . paprDictionaryRCVD = %@", paprDictionaryRCVD);
    
    // SCROLLVIEW . ADD paprVC
    PaprTableVC *paprTable = [[PaprTableVC alloc] init];
    paprTable.paprTag = 1;
    paprTable.paprDictionary = [[NSDictionary alloc] initWithDictionary:paprDictionaryRCVD];
    paprTable.view.frame = frameRCVD;
    
    [self.view addSubview:paprTable.view];

    [self.arrayOfPaprViews replaceObjectAtIndex:1 withObject:paprTable];

//    [self addChildViewController:paprTable];
//    [paprTable didMoveToParentViewController:self];
    // [paprTable removeFromSuperview];
    // [paprTable removeFromParentViewController];
    
}
- (void) activatePaprSwipeLeft {

    // SWIPE LEFT == SHOW RIGHT

    if (paprsBeMoving) {return;}
    
    paprsBeMoving = TRUE;

    NSLog(@"activatePaprSwipeLeft");

    PaprTableVC *slideFromRight = [self.arrayOfPaprViews objectAtIndex:2];
    PaprTableVC *slideFromCenter = [self.arrayOfPaprViews objectAtIndex:1];
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         slideFromRight.view.frame = frameCenter;
                         slideFromCenter.view.frame = frameLeft;
                     } completion: ^(BOOL finished){
                     
                         [self.arrayOfPaprViews replaceObjectAtIndex:0 withObject:slideFromCenter];
                         [self.arrayOfPaprViews replaceObjectAtIndex:1 withObject:slideFromRight];

                         paprsBeMoving = FALSE;

                         [self updateCurrentSourceCell];

                     }
     
     ];
    
    
}
- (void) activatePaprSwipeRight {

    // SWIPE RIGHT == SHOW LEFT
    
    if (paprsBeMoving) {return;}
    
    paprsBeMoving = TRUE;
    
    NSLog(@"activatePaprSwipeLeft");
    
    PaprTableVC *slideFromLeft = [self.arrayOfPaprViews objectAtIndex:0];
    PaprTableVC *slideFromCenter = [self.arrayOfPaprViews objectAtIndex:1];
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         slideFromLeft.view.frame = frameCenter;
                         slideFromCenter.view.frame = frameRight;
                     } completion: ^(BOOL finished){
                         
                         [self.arrayOfPaprViews replaceObjectAtIndex:2 withObject:slideFromCenter];
                         [self.arrayOfPaprViews replaceObjectAtIndex:1 withObject:slideFromLeft];
                         
                         paprsBeMoving = FALSE;
                         
                         [self updateCurrentSourceCell];

                     }
     
     ];
}

#pragma mark - IBACTION

- (IBAction) buProfileSelected : (id)sender {
    
    NSLog(@"buProfileSelected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.pushPaprProfilesWithDictionary" object:nil];

}
- (IBAction) buDragAndDropSelected : (id)sender {
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         self.viewDragAndDrop.alpha = 0.0;
                     } completion: ^(BOOL finished){

                         [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"iHaveShownDragAndDropMessage"];
                         [[NSUserDefaults standardUserDefaults] synchronize];

                     }
     
     ];
    
}
- (IBAction) buNotificationsSelected : (id)sender {
    
    NSLog(@"buNotificationsSelected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.pushPaprNotificationsWithDictionary" object:nil];

}
- (IBAction) buAddSelected : (id)sender {
    
    NSLog(@"buAddSelected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.pushPaprPlusWithDictionary" object:nil];

}
- (IBAction) buCreateSelected : (id)sender {
    
    NSLog(@"buCreateSelected");

    // WE ARE IN SIGNUP MODE
    [self pushPaprPostSignupVC];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
