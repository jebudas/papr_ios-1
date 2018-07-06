 //
//  PaprPostEditVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprPostEditVC.h"

@interface PaprPostEditVC ()

@end

@implementation PaprPostEditVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"PaprPostEditVC . viewDidLoad");
    
    [self setupNotifications];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupPaprDictionary];

    [self.tableViewEditPapr setEditing: YES animated: YES];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.weAreAtMaximum) {
    
        // self.viewMaximum.alpha = 1.0;

    }
    
}

- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSelf) name:@"PaprPostEditVC.popSelf" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostEditVC.popSelf" object:nil];
    
}
- (void) setupPaprDictionary {
    
    self.paprDictionary = [[NSDictionary alloc] initWithDictionary: [[DataController dc] returnMyPaprDictionary] ];
    
    NSArray *arrayOfPaprItemsPRE = [[NSArray alloc] initWithArray: [self.paprDictionary objectForKey:@"EDITION_POSTS"] ];
    
    self.arrayOfPaprItems = [[NSArray alloc] initWithArray: [[DataController dc] returnArrayOfFreshPaprItems: arrayOfPaprItemsPRE ] ];
    
    if (self.arrayOfPaprItems.count > 0) {
        
        [self tableViewReload];
        
    }
    
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
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,100)];
    return viewFooter;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"PaprPostEditVC . numberOfRowsInSection . self.arrayOfPaprItems.count = %i", (int)self.arrayOfPaprItems.count);
    
    return self.arrayOfPaprItems.count + 1; // +1 FOR HEADER
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        // HEADER
        
        return 82;
        
    } else {
        
        // TEST FOR TYPE
        
        return 79;
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return [self returnPaprCellHeaderPost : [self.paprDictionary objectForKey:@"EDITION_HEADER"] ];
        
    } else {
        
        NSDictionary *thisCellDictionary = [self.arrayOfPaprItems objectAtIndex: (indexPath.row - 1) ];
    
        return [self returnPaprCellText : thisCellDictionary : indexPath];

    }
    
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int indexPathRow = (int)indexPath.row;
    //    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfSubscriptions objectAtIndex:indexPathRow] ];
    //    NSString *subscription_id = [NSString stringWithFormat:@"%i", [[cellDictionary objectForKey:@"PUBLISHER_ID"] intValue] ];
    //
    //    [self sendSubscriptionToManager : subscription_id];
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }

}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {

    int indexSource = (int)sourceIndexPath.row - 1;
    int indexDestination = (int)destinationIndexPath.row - 1;
    
    NSLog(@"moveRowAtIndexPath: %i to %i", indexSource, indexDestination);
    
    NSMutableArray *arrayOfPaprItemsEDITED = [[NSMutableArray alloc] initWithArray:self.arrayOfPaprItems];
    
    NSDictionary *itemToBeMoved = [[NSDictionary alloc] initWithDictionary: [arrayOfPaprItemsEDITED objectAtIndex:indexSource] ];
    
    [arrayOfPaprItemsEDITED removeObjectAtIndex:indexSource];

    [arrayOfPaprItemsEDITED insertObject:itemToBeMoved atIndex:indexDestination];

    self.arrayOfPaprItems = [[NSArray alloc] initWithArray:arrayOfPaprItemsEDITED];
    
    [[DataController dc] updatePaprDictionaryWithNewPosts:self.arrayOfPaprItems];
    
    [self tableViewReload];
    
    iHaveEditedMyPapr = TRUE;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *arrayOfPaprItemsEDITED = [[NSMutableArray alloc] initWithArray:self.arrayOfPaprItems];

        [arrayOfPaprItemsEDITED removeObjectAtIndex:indexPath.row - 1];
        
        self.arrayOfPaprItems = [[NSArray alloc] initWithArray:arrayOfPaprItemsEDITED];

        [[DataController dc] updatePaprDictionaryWithNewPosts:self.arrayOfPaprItems];
        
        [self tableViewReload];
    
        iHaveEditedMyPapr = TRUE;
        
    }

}
- (PaprCellHeaderPost *) returnPaprCellHeaderPost : (NSDictionary *)thisHeaderDictionary {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellHeaderPost *cell = [self.tableViewEditPapr dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
    [cell setupHeader : @"edit"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    return cell;
    
}
- (PaprCellText *) returnPaprCellText : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellText *cell = [self.tableViewEditPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellText" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.labelText.text = [thisCellDictionary objectForKey:@"post_description"];
    NSString *iconType = [NSString stringWithFormat:@"icon_%@.png", [thisCellDictionary objectForKey:@"post_type"]];
    cell.imageViewIcon.image = [UIImage imageNamed:iconType];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (PaprCellPhoto *) returnPaprCellPhoto : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCellPhoto *cell = [self.tableViewEditPapr dequeueReusableCellWithIdentifier:cellIdentifier];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (PaprCellFull *) returnPaprCellFull : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PaprCellFull";
    PaprCellFull *cell = [self.tableViewEditPapr dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCellFull" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"returnPaprCellFull . thisCellDictionary = %@", thisCellDictionary);
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprPostEditVC . tableViewReload");
    [self.tableViewEditPapr reloadData];
    
}

#pragma mark - IBACTION & NAVIGATION Methods

- (void) popSelf {

    NSLog(@"PaprPostEditVC . popSelf");
    
    // via PaprCellHeaderPost > buDoneSelected
    
    if (iHaveEditedMyPapr) {

        [self insertPaprIntoScrollView : [[DataController dc] returnMyPaprDictionary] ];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.publishUpdatedDictionary" object:nil];
        
        iHaveEditedMyPapr = FALSE;
    
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (IBAction) buEmpyPostSelected : (id)sender {
    //
}
- (void) insertPaprIntoScrollView : (NSDictionary *)newEditionDictionary {
    
    NSString *newIndex = [NSString stringWithFormat:@"%i", [DataController dc].currentPaprIndex];
    
    NSDictionary *newPaprAndIndex = @{@"newPapr":newEditionDictionary,
                                      @"newIndex":newIndex};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.updatePaprSubscriptionsWithNewPapr" object:nil userInfo:newPaprAndIndex];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

/*
 
 CLEANUP:
 
 -(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewRowAction *button =
 [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Button 1" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
 NSLog(@"Action to perform with Button 1");
 }];
 
 button.backgroundColor = [UIColor greenColor]; //arbitrary color
 UITableViewRowAction *button2 =
 [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Button 2" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
 NSLog(@"Action to perform with Button2!");
 }];
 button2.backgroundColor = [UIColor blueColor]; //arbitrary color
 
 return @[button, button2];
 }
 
 */
