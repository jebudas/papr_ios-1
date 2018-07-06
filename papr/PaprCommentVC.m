//
//  PaprCommentVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCommentVC.h"

@interface PaprCommentVC ()

@end

@implementation PaprCommentVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    NSLog(@"PaprCommentVC . viewDidLoad . self.commentDictionary = %@", self.commentDictionary);

    [self setupBlurBG];
    [self setupCommentTextField];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    self.labelHeader.alpha = 0.0;

    [self getCommentsWithDictionary : self.commentDictionary];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void) setupBlurBG {

    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view insertSubview:blurEffectView atIndex:0];
        
    } else {
        
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0.70;
        
    }
    
    
}
- (void) setupCommentTextField {

    self.viewComment.backgroundColor = [UIColor paprGreyVeryLight];
    
}
- (void) setupHeader {

    NSString *header;
    if (self.arrayOfComments.count > 0) {
        header = [NSString stringWithFormat:@"COMMENTS (%i)", (int)self.arrayOfComments.count];
    } else {
        header = @"COMMENTS";
    }

    self.labelHeader.text = header;
    self.labelHeader.alpha = 1.0;

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
    
    return self.arrayOfComments.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *thisCommentDictionary = [self.arrayOfComments objectAtIndex: indexPath.row ];
    
    return [self returnPaprCommentCell : thisCommentDictionary : indexPath];
            
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return;

}
- (PaprCommentCell *) returnPaprCommentCell : (NSDictionary *)thisCommentDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCommentCell *cell = [self.tableViewComments dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCommentCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[thisCommentDictionary objectForKey:@"user_profile_avatar_url"]];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageViewAvatar.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    cell.labelText.text = [thisCommentDictionary objectForKey:@"comment"];
    cell.labelTime.text = [[DataController dc] returnHumanDateString:[thisCommentDictionary objectForKey:@"timestamp"]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (void) tableViewReload {
    
    NSLog(@"PaprCommentsVC . tableViewReload");
    [self.tableViewComments reloadData];
    
}

#pragma mark - UITEXTFIELD METHODS

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField becomeFirstResponder];
    
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {

        [self setupCommentDictionaryToPublish];
        
        self.viewComment.alpha = 0.0;
        
        [self.textFieldComment resignFirstResponder];
        
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

- (void) setupCommentDictionaryToPublish {

    NSDictionary *myUserDictionary = [[NSDictionary alloc] initWithDictionary:[[DataController dc] returnMyUserDictionary] ];
    NSDictionary *myProfileDictionary = [[NSDictionary alloc] initWithDictionary: [myUserDictionary objectForKey:@"user_profile"] ];
    
    NSString *myComment = self.textFieldComment.text;
    
    NSDictionary *fullCommentDictionary = @{@"comment": myComment,
                                            @"timestamp": [[DataController dc] returnTimestamp],
                                            @"user_profile_avatar_url": [myProfileDictionary objectForKey:@"user_profile_avatar_url"],
                                            @"user_id": [myUserDictionary objectForKey:@"fb_user_id"],
                                            @"user_profile_display_name": [myProfileDictionary objectForKey:@"user_profile_display_name"],
                                            @"comment_id":[self.commentDictionary objectForKey:@"comment_id"],
                                            @"publisher_id":[self.commentDictionary objectForKey:@"publisher_id"]
                                            };
    
    [self publishCommentsWithDictionary : fullCommentDictionary];
    
}
- (void) getCommentsWithDictionary : (NSDictionary *)dictionaryRCVD {
    [self getCommentsWithDictionary : self.commentDictionary];

    __weak PaprCommentVC *weakSelf = self;
    
    [[APIController api] getComments:dictionaryRCVD success:^(NSDictionary *responseDictionary) {

        weakSelf.arrayOfComments = [[NSArray alloc] initWithArray: [responseDictionary objectForKey:@"COMMENTS"] ];

        NSLog(@"PaprCommentVC . getCommentsWithDictionary . weakSelf.arrayOfComments = %@", weakSelf.arrayOfComments);
        
        [weakSelf setupHeader];

        [weakSelf tableViewReload];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprCommentVC . getCommentsWithDictionary . error = %@", error);
        
    }];
    
}
- (void) publishCommentsWithDictionary : (NSDictionary *)dictionaryRCVD {

    NSDictionary *parameters  = @{@"comment_dictionary" : dictionaryRCVD};

    __weak PaprCommentVC *weakSelf = self;
    
    [[APIController api] publishComment:parameters success:^(NSDictionary *responseDictionary) {
        
        weakSelf.arrayOfComments = [[NSArray alloc] initWithArray: [responseDictionary objectForKey:@"COMMENTS"] ];
        
        NSLog(@"PaprCommentVC . getCommentsWithDictionary . weakSelf.arrayOfComments = %@", weakSelf.arrayOfComments);
        
        [weakSelf setupHeader];
        
        [weakSelf tableViewReload];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendStats" object:nil userInfo:@{@"stats":dictionaryRCVD}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendNotifications" object:nil userInfo:@{@"notifications":dictionaryRCVD}];

    } failure:^(NSError *error) {
        
        NSLog(@"PaprCommentVC . getCommentsWithDictionary . error = %@", error);
        
    }];

}

- (IBAction) buXSelected : (id)sender {

    self.viewComment.alpha = 0.0;
    
    [self.textFieldComment becomeFirstResponder];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprCommentVC" object:nil];
    
}
- (IBAction) buAddSelected : (id)sender {

    self.viewComment.alpha = 1.0;
    
    [self.textFieldComment becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
