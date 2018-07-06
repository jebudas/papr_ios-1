//
//  PaprSavedPostsVC.m
//  papr
//
//  Created by Brian WF Tobin on 10/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprSavedPostsVC.h"

@interface PaprSavedPostsVC ()

@end

@implementation PaprSavedPostsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self getSavedPosts];
    
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
    
    return self.arrayOfSavedPosts.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[DataController dc] returnRelativeSizeForThisScreen:134];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *thisCellDictionary = [self.arrayOfSavedPosts objectAtIndex: indexPath.row ];
    
    return [self returnPaprSavedPostsCell : thisCellDictionary : indexPath];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"self.arrayOfSavedPosts = %@", [self.arrayOfSavedPosts objectAtIndex:indexPath.row]);

    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSDictionary *cellDictionary = [self.arrayOfSavedPosts objectAtIndex:indexPath.row];
    
    NSString *cellURL = [cellDictionary objectForKey:@"post_link"];
    
    NSLog(@"cellURL = %@", cellURL);
    
    if (cellURL.length < 7) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:cellURL];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
    
    [self showViewController:safariVC sender:nil];

    return;
    
}
- (PaprSavedPostsCell *) returnPaprSavedPostsCell : (NSDictionary *)thisCellDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprSavedPostsCell *cell = [self.tableViewSavedPosts dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprSavedPostsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"thisCellDictionary = %@", thisCellDictionary);
    
    NSURL *imageURL = [NSURL URLWithString:[thisCellDictionary objectForKey:@"post_publisher_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.labelAvatar.text = [thisCellDictionary objectForKey:@"post_publisher_display_name"];
    cell.labelText.text = [thisCellDictionary objectForKey:@"post_title"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprSavedPostsVC . tableViewReload");
    [self.tableViewSavedPosts reloadData];
    
}

#pragma mark - API METHODS

- (void) getSavedPosts {
    
    __weak PaprSavedPostsVC *weakSelf = self;
    
    [[APIController api] getSavedPosts:^(NSDictionary *responseDictionary) {

        weakSelf.arrayOfSavedPosts = [[NSArray alloc] initWithArray: [responseDictionary objectForKey:@"EDITION_POSTS"] ];

        [weakSelf tableViewReload];
        
        self.viewSpinner.alpha = 0.0;
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprSavedPostsVC . getSavedPosts . error = %@", error);
        
    }];
    
}


#pragma mark - IBACTION METHODS

- (IBAction) buBackSelected : (id)sender {
    
    NSLog(@"buBackSelected");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprSavedPostsVC" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
