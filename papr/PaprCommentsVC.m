//
//  PaprCommentsVC.m
//  papr
//
//  Created by Brian WF Tobin on 2/22/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCommentsVC.h"

@interface PaprCommentsVC ()

@end

@implementation PaprCommentsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    // SETUP FOR TEXTFIELD
    self.buCancel.alpha = 0.0;
    self.viewSpinner.alpha = 0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(establishKeyboardEndFrame:) name:UIKeyboardDidShowNotification object:nil];
    
    // THIS REMOVES THE WEIRD HEADER PADDING AT THE TOP OF THE TABLEVIEW
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    frameViewTextFieldOriginal = self.viewTextField.frame;

    if (iHaveRequestedComments) {
        // CHILL
    } else {
        
        [self getCommentsForPublisher:[self.postDictionary objectForKey:@"post_publisher"] withID:self.commentSetID];
        
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
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *viewFooter = [[UIView alloc] init];
    viewFooter.backgroundColor = [UIColor clearColor];
    return viewFooter;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.arrayOfComments.count > 0) {
        self.labelBeTheFirst.alpha = 0.0;
    } else {
        self.labelBeTheFirst.alpha = 1.0;
    }
    
    return self.arrayOfComments.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *thisCommentDictionary = [self.arrayOfComments objectAtIndex: indexPath.row ];
    NSString *commentText = [thisCommentDictionary objectForKey:@"COMMENT_TEXT"];
    
    if ( [[thisCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"comment"] ) {
    
        return [[DataController dc] returnHeightForCommentCell : commentText : YES];
    
    } else if ( [[thisCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"reply"] ) {

        return [[DataController dc] returnHeightForCommentCell : commentText : NO];

    } else {

        // LOAD MORE
        return 50;

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *thisCommentDictionary = [self.arrayOfComments objectAtIndex: indexPath.row ];
    
    if ( [[thisCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"comment"] ) {
    
        return [self returnPaprCommentsCell : thisCommentDictionary : indexPath];
        
    } else if ( [[thisCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"reply"] ) {

        return [self returnPaprCommentsReplyCell : thisCommentDictionary : indexPath];

    } else if ( [[thisCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"load_more"] ) {

        return [self returnPaprCommentsReplyMoreCell : thisCommentDictionary : indexPath];

    } else {
    
        // WE SHOULD NEVER SEE THIS
        return nil;
        
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *thisCommentDictionary = [self.arrayOfComments objectAtIndex: indexPath.row ];
    
    if ( [[thisCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"load_more"] ) {
        
        NSString *commentID = [thisCommentDictionary objectForKey:@"COMMENT_ID"];

        [self insertRepliesForCommentID:commentID atIndexPath:(int)indexPath.row];
        
    }

    [self.tableViewComments deselectRowAtIndexPath:indexPath animated:NO];

}
- (PaprCommentsCell *) returnPaprCommentsCell : (NSDictionary *)thisCommentDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCommentsCell *cell = [self.tableViewComments dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCommentsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    // SET CELL . PUBLISHER ID
    cell.commentID = [thisCommentDictionary objectForKey:@"COMMENT_ID"];
    cell.publisherID = [thisCommentDictionary objectForKey:@"COMMENT_PUBLISHER_ID"];

    // SET CELL . AVATAR
    NSString *avatarURL = [[DataController dc] returnAvatarURL: cell.publisherID ];
    NSLog(@"thisCommentDictionary = %@", thisCommentDictionary);
    NSLog(@"avatarURL = %@", avatarURL);
    NSURL *imageURL = [NSURL URLWithString: avatarURL ];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

        cell.imageViewAvatar.image = image;
        
        // ROUNDED CORNER
        cell.imageViewAvatar.backgroundColor = [UIColor clearColor];
        cell.imageViewAvatar.layer.masksToBounds = YES;
        cell.imageViewAvatar.layer.cornerRadius = 5;

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    
    // SET CELL . LABEL . COMMENT
    NSString *username = [thisCommentDictionary objectForKey:@"COMMENT_USERNAME"];
    NSString *commentText = [thisCommentDictionary objectForKey:@"COMMENT_TEXT"];
    NSString *commentString = [NSString stringWithFormat:@"%@ %@", username, commentText];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: commentString ];
    [attributedString addAttribute:NSKernAttributeName value:@-0.25 range:NSMakeRange(0, commentString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlack111] range:NSMakeRange(0, username.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, username.length)];
    cell.labelText.attributedText = attributedString;
    cell.labelText.frame = [[DataController dc] returnFrameForCommentLabel:cell.labelText : commentString : YES];
    cell.labelText.numberOfLines = [[DataController dc] returnLineCountForCommentCell : commentString : YES];

    
    // SET CELL . LABEL . TIMESTAMP
    cell.labelTimestamp.text = [[DataController dc] returnHumanDateString:[thisCommentDictionary objectForKey:@"COMMENT_TIMESTAMP"]];
    int labelTimestampOriginY = cell.labelText.frame.origin.y + cell.labelText.frame.size.height + 2;
    cell.labelTimestamp.frame = CGRectMake(cell.labelTimestamp.frame.origin.x, labelTimestampOriginY, cell.labelTimestamp.frame.size.width, cell.labelTimestamp.frame.size.height);

    // SET CELL . LABEL . VOTES
    int votesUp = [[thisCommentDictionary objectForKey:@"COMMENT_VOTES_UP"] intValue];
    int votesDown = [[thisCommentDictionary objectForKey:@"COMMENT_VOTES_DOWN"] intValue];
    int voteTotal = votesUp - votesDown;
    [cell setVoteLabel:voteTotal];
    
    // BUTTON . REPLY
    CGRect buFrame = cell.labelTimestamp.frame;
    UIButton *buReply = [UIButton buttonWithType:UIButtonTypeCustom];
    buReply.frame = CGRectMake(buFrame.origin.x + 100, buFrame.origin.y, 100, buFrame.size.height);
    buReply.backgroundColor = [UIColor clearColor];
    buReply.titleLabel.font = cell.labelTimestamp.font;
    buReply.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buReply setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buReply addTarget:self action:@selector(buReplySelected:) forControlEvents:UIControlEventTouchUpInside];
    [buReply setTitle:@"reply" forState:UIControlStateNormal];
    buReply.tag = indexPath.row + 1;
    [cell addSubview:buReply];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (PaprCommentsReplyCell *) returnPaprCommentsReplyCell : (NSDictionary *)thisCommentDictionary : (NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    PaprCommentsReplyCell *cell = [self.tableViewComments dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaprCommentsReplyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // SET CELL . PUBLISHER ID
    cell.publisherID = [thisCommentDictionary objectForKey:@"COMMENT_PUBLISHER_ID"];
    
    // SET CELL . AVATAR
    NSString *avatarURL = [[DataController dc] returnAvatarURL: cell.publisherID ];
    NSURL *imageURL = [NSURL URLWithString: avatarURL ];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    [cell.imageViewAvatar setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        cell.imageViewAvatar.image = image;
        
        // ROUNDED CORNER
        cell.imageViewAvatar.backgroundColor = [UIColor clearColor];
        cell.imageViewAvatar.layer.masksToBounds = YES;
        cell.imageViewAvatar.layer.cornerRadius = 5;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
    }];
    
    // LABEL . COMMENT
    
    NSString *usernameParent = [NSString stringWithFormat:@"@%@", [thisCommentDictionary objectForKey:@"PARENT_COMMENT_USERNAME"]];
    NSString *username = [thisCommentDictionary objectForKey:@"COMMENT_USERNAME"];
    NSString *commentText = [thisCommentDictionary objectForKey:@"COMMENT_TEXT"];
    NSString *commentString = [NSString stringWithFormat:@"%@ %@ %@", username, usernameParent, commentText];

    cell.labelText.frame = [[DataController dc] returnFrameForCommentLabel:cell.labelText : commentString : NO];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: commentString ];
    [attributedString addAttribute:NSKernAttributeName value:@-0.25 range:NSMakeRange(0, commentString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlack111] range:NSMakeRange(0, username.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, username.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor paprBlue] range:NSMakeRange(username.length + 1, usernameParent.length)];
    cell.labelText.attributedText = attributedString;
    
    cell.labelText.frame = [[DataController dc] returnFrameForCommentLabel:cell.labelText : commentString : NO];
    cell.labelText.numberOfLines = [[DataController dc] returnLineCountForCommentCell : commentString : NO];

        // LABEL . TIMESTAMP
    cell.labelTimestamp.text = [[DataController dc] returnHumanDateString:[thisCommentDictionary objectForKey:@"COMMENT_TIMESTAMP"]];
    int labelTimestampOriginY = cell.labelText.frame.origin.y + cell.labelText.frame.size.height + 2;
    cell.labelTimestamp.frame = CGRectMake(cell.labelTimestamp.frame.origin.x, labelTimestampOriginY, cell.labelTimestamp.frame.size.width, cell.labelTimestamp.frame.size.height);
    
    // BUTTON . REPLY
    CGRect buFrame = cell.labelTimestamp.frame;
    UIButton *buReply = [UIButton buttonWithType:UIButtonTypeCustom];
    buReply.frame = CGRectMake(buFrame.origin.x + 100, buFrame.origin.y, 100, buFrame.size.height);
    buReply.backgroundColor = [UIColor clearColor];
    buReply.titleLabel.font = cell.labelTimestamp.font;
    buReply.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buReply setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [buReply addTarget:self action:@selector(buReplySelected:) forControlEvents:UIControlEventTouchUpInside];
    [buReply setTitle:@"reply" forState:UIControlStateNormal];
    buReply.tag = indexPath.row + 1;
    [cell addSubview:buReply];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    
    [cell setTag:indexPath.row];
    
    return cell;
    
}
- (UITableViewCell *) returnPaprCommentsReplyMoreCell : (NSDictionary *)thisCommentDictionary : (NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableViewComments dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *labelMore = [[UILabel alloc] initWithFrame: CGRectMake(97, 10, 200, 20)];
    labelMore.font = [UIFont systemFontOfSize:14];
    labelMore.text = @"-- Load more replies";
    labelMore.textColor = [UIColor lightGrayColor];
    labelMore.numberOfLines = 1;

    [cell addSubview:labelMore];
    
    return cell;

}
- (void) tableViewReload {
    
    NSLog(@"PaprCommentsVC . tableViewReload");
    [self.tableViewComments reloadData];
    
}
- (float) returnCellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    int cellHeight = 70;
    /*
    int indexPathRow = (int)indexPath.row;
    NSDictionary *cellDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfPaprArticles objectAtIndex:indexPathRow] ];
    
    // ADD CELL HEIGHT CONSTANTS . IMAGE
    if ( [[cellDictionary objectForKey:@"post_image_url"] isKindOfClass:[NSNull class]]) {
        cellHeight += 0;
    } else {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:240];
    }
    
    // ADD CELL HEIGHT CONSTANTS . TITLE / URL
    cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:88];
    
    // ADD CELL HEIGHT CONSTANTS . DESCRIPTION
    if ( [[cellDictionary objectForKey:@"post_description"] isEqualToString:@"-"] ) {
        cellHeight += 0;
    } else {
        cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:105];
    }
    
    // ADD CELL HEIGHT CONSTANTS . FOOTER
    cellHeight += [[DataController dc] returnRelativeSizeForThisScreen:46];
    */

    return cellHeight;
    
}

#pragma mark - UITEXTFIELD METHODS

- (void) prepareTextField {
    
    [self.textFieldComment becomeFirstResponder];
    
    [self animateViewTextField_UP];

}
- (void) prepareForComment {

    if (self.parentCommentDictionary) {

        self.selectedCommentUsername = [self.parentCommentDictionary objectForKey:@"COMMENT_USERNAME"];
        
        self.textFieldComment.text = [NSString stringWithFormat:@"@%@ ", self.selectedCommentUsername];

        [self prepareTextField];
        
    }

}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if (iAmCommenting) {
        // CHILL
    } else {
        [self prepareTextField];
    }

}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [self setupCommentForPublication];

        return NO;
        
    }
    
    return YES;
    
}
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
    
}
- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    [self animateViewTextField_DOWN];
    
    [textField resignFirstResponder];
    
}
- (void) establishKeyboardEndFrame : (NSNotification*)notification {

    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    NSLog(@"keyboardFrame.origin.y: %f", keyboardFrame.origin.y);
    NSLog(@"keyboardFrame.size.height: %f", keyboardFrame.size.height);

    /*
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* frameKeyboardEndValue = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frameKeyboardEnd = [frameKeyboardEndValue CGRectValue];
    frameViewTextFieldOffsetY = frameKeyboardEnd.origin.y;
     */

}
- (void) animateViewTextField_UP {
    
    iAmCommenting = TRUE;

    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         self.viewTextField.frame = CGRectMake(self.viewTextField.frame.origin.x,
                                                               409 - self.viewTextField.frame.size.height,
                                                               self.viewTextField.frame.size.width,
                                                               self.viewTextField.frame.size.height);
                     } completion: ^(BOOL finished){
                         self.buCancel.alpha = 1.0;
                     }
     ];
    
}
- (void) animateViewTextField_DOWN {
    
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         self.viewTextField.frame = frameViewTextFieldOriginal;
                     } completion: ^(BOOL finished){

                         iAmCommenting = FALSE;
                         
                         self.buCancel.alpha = 0.0;
                         
                     }
     ];
    
    
}

#pragma mark - API & RELATED METHODS

- (void) setupCommentForPublication {
    
    // LOAD SPINNER
    self.viewSpinner.alpha = 1.0;
    
    NSLog(@"setupCommentForPublication . self.parentCommentDictionary = %@", self.parentCommentDictionary);
    
    NSString *commentID;
    NSString *myComment = [self returnCleanComment];
    NSString *myPublisherID = [[DataController dc] returnMyUserID];
    NSString *currentTimestamp = [[DataController dc] returnTimestamp];
    NSString *parentCommentType = [self.parentCommentDictionary objectForKey:@"COMMENT_TYPE"];

    NSDictionary *fullCommentDictionary;
    
    if ( [parentCommentType isEqualToString:@"comment"] || [parentCommentType isEqualToString:@"reply"] ) {

        NSLog(@"setupCommentForPublication . parentCommentType = %@", parentCommentType);
        
        // COMMENT / REPLY
        if ( [parentCommentType isEqualToString:@"comment"] ) {
            commentID = [self.parentCommentDictionary objectForKey:@"COMMENT_ID"];
        } else {
            commentID = [self.parentCommentDictionary objectForKey:@"PARENT_COMMENT_ID"];
        }
        NSString *thisCommentID = [NSString stringWithFormat:@"%@_REPLY_%@-%@", commentID, myPublisherID, currentTimestamp];

        fullCommentDictionary = @{@"article_publisher_id": [self.postDictionary objectForKey:@"post_publisher"],
                                  @"comment_set_id": self.commentSetID,
                                  @"comment_id": thisCommentID,
                                  @"comment_username": [[DataController dc] returnMyUsername],
                                  @"comment_publisher_id": myPublisherID,
                                  @"comment_text": myComment,
                                  @"comment_type": @"reply",
                                  @"comment_timestamp": [[DataController dc] returnTimestamp],
                                  @"parent_comment_id": commentID,
                                  @"parent_comment_publisher_id": [self.parentCommentDictionary objectForKey:@"COMMENT_PUBLISHER_ID"],
                                  @"parent_comment_username": [self.parentCommentDictionary objectForKey:@"COMMENT_USERNAME"],
                                  @"comment_replies": @"0"
                                  };

    } else {

        // NEW COMMENT
        commentID = [self.parentCommentDictionary objectForKey:@"COMMENT_ID"];
        NSString *thisCommentID = [NSString stringWithFormat:@"%@_COMMENT_%@-%@", self.commentSetID, myPublisherID, currentTimestamp];
        
        fullCommentDictionary = @{@"article_publisher_id": [self.postDictionary objectForKey:@"post_publisher"],
                                  @"comment_set_id": self.commentSetID,
                                  @"comment_id": thisCommentID,
                                  @"comment_username": [[DataController dc] returnMyUsername],
                                  @"comment_publisher_id": myPublisherID,
                                  @"comment_text": myComment,
                                  @"comment_type": @"comment",
                                  @"comment_timestamp": [[DataController dc] returnTimestamp]
                                  };

    }
    
    NSLog(@"setupCommentForPublication . fullCommentDictionary = %@", fullCommentDictionary);

    [self publishCommentsWithDictionary : fullCommentDictionary];
    
}
- (NSString *) returnCleanComment {
    
    NSString *returnComment = self.textFieldComment.text;
    
    if ( [self.parentCommentDictionary objectForKey:@"COMMENT_USERNAME"] ) {
        
        NSString *usernameAT = [NSString stringWithFormat:@"@%@", [self.parentCommentDictionary objectForKey:@"COMMENT_USERNAME"]];
        NSString *usernameSPACED = [NSString stringWithFormat:@"%@ ", usernameAT];
        if ( [returnComment hasPrefix: usernameAT] ) {
            returnComment = [returnComment stringByReplacingOccurrencesOfString:usernameAT withString:@""];
        } else if ( [returnComment hasPrefix: usernameSPACED] ) {
            returnComment = [returnComment stringByReplacingOccurrencesOfString:usernameSPACED withString:@""];
        }

    }
    
    return returnComment;
    
}
- (void) getCommentsForPublisher:(NSString *)publisherRCVD withID:(NSString *)idRCVD {
    
    __weak PaprCommentsVC *weakSelf = self;
    
    self.labelBeTheFirst.alpha = 0.0;
    
    NSDictionary *parameters = @{@"publisher_id":publisherRCVD, @"comment_set_id" : idRCVD};
    NSLog(@"PaprCommentsVC . getCommentsWithID . parameters = %@", parameters);

    [[APIController api] getComments:parameters success:^(NSDictionary *responseDictionary) {
        
        weakSelf.arrayOfComments = [[NSArray alloc] initWithArray: [responseDictionary objectForKey:@"COMMENT_SET_THREADS"] ];
        
        NSLog(@"PaprCommentsVC . getCommentsWithID . responseDictionary = %@", responseDictionary);
        NSLog(@"PaprCommentsVC . getCommentsWithID . weakSelf.arrayOfComments = %@", weakSelf.arrayOfComments);

        [weakSelf surfaceRepliesAsComments];

        [weakSelf tableViewReload];

        [self resetCommentStatus];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprCommentsVC . getCommentsWithID . error = %@", error);
        
    }];
    
}
- (void) insertRepliesForCommentID:(NSString *)commentID atIndexPath:(int)indexPathRCVD {
    
    __weak PaprCommentsVC *weakSelf = self;
    
    NSDictionary *parameters = @{@"reply_set_id" : commentID};

    [[APIController api] getReplies:parameters success:^(NSDictionary *responseDictionary) {
        
//        weakSelf.arrayOfComments = [[NSArray alloc] initWithArray: [responseDictionary objectForKey:@"COMMENT_SET_THREADS"] ];
        
        NSLog(@"PaprCommentsVC . getRepliesForCommentID . responseDictionary = %@", responseDictionary);
        
        [self insertRepliesIntoThread:[responseDictionary objectForKey:@"REPLY_SET_THREADS"] atIndexPath:indexPathRCVD];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprCommentsVC . getRepliesForCommentID . error = %@", error);
        
    }];
    
}
- (void) publishCommentsWithDictionary : (NSDictionary *)dictionaryRCVD {
    
    NSDictionary *parameters  = @{@"comment_dictionary" : dictionaryRCVD};
    
    NSLog(@"parameters = %@", parameters);

    __weak PaprCommentsVC *weakSelf = self;
    
    [[APIController api] publishComment:parameters success:^(NSDictionary *responseDictionary) {
        
        [weakSelf getCommentsForPublisher:[self.postDictionary objectForKey:@"post_publisher"] withID:self.commentSetID];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendStats" object:nil userInfo:@{@"stats":dictionaryRCVD}];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendNotifications" object:nil userInfo:@{@"notifications":dictionaryRCVD}];
        
    } failure:^(NSError *error) {
        
        [self resetCommentStatus];
        
        NSLog(@"PaprCommentsVC . getCommentsWithDictionary . error = %@", error);
        NSLog(@"");
        
    }];
    
}
- (void) surfaceRepliesAsComments {

    NSLog(@"self.arrayOfComments = %@", self.arrayOfComments);
    
    //NSMutableArray *arrayOfCommentsUPDATED = @[];
    NSMutableArray *arrayOfCommentsUPDATED = [[NSMutableArray alloc] init];
    
    for (NSDictionary *commentDictionary in self.arrayOfComments) {
    
        int replyCount = [[commentDictionary objectForKey:@"COMMENT_REPLY_COUNT"] intValue];
        
        if ( replyCount > 1 ) {

            // ADD TOP LEVEL COMMENT
            [arrayOfCommentsUPDATED addObject:commentDictionary];

            // ADD FIRST REPLY
            NSDictionary *replyDictionary = [[NSDictionary alloc] initWithDictionary:[commentDictionary objectForKey:@"COMMENT_THREAD_FIRST_REPLY"]];
            [arrayOfCommentsUPDATED addObject:replyDictionary];

            // ADD LOAD MORE REPLIES
            NSDictionary *loadMoreDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                @"load_more", @"COMMENT_TYPE",
                                                [commentDictionary objectForKey:@"COMMENT_ID"], @"COMMENT_ID",
                                                [commentDictionary objectForKey:@"COMMENT_REPLY_COUNT"], @"COMMENT_REPLY_COUNT",
                                                [commentDictionary objectForKey:@"COMMENT_PUBLISHER_ID"], @"COMMENT_PUBLISHER_ID",
                                                nil];
            [arrayOfCommentsUPDATED addObject:loadMoreDictionary];

        } else if ( replyCount > 0 ) {

            // ADD TOP LEVEL COMMENT
            [arrayOfCommentsUPDATED addObject:commentDictionary];
            
            // ADD FIRST REPLY
            NSDictionary *replyDictionary = [[NSDictionary alloc] initWithDictionary:[commentDictionary objectForKey:@"COMMENT_THREAD_FIRST_REPLY"]];
            [arrayOfCommentsUPDATED addObject:replyDictionary];

        } else {
        
            // ADD TOP LEVEL COMMENT
            [arrayOfCommentsUPDATED addObject:commentDictionary];
            
        }
        
    }

    self.arrayOfComments = [[NSArray alloc] initWithArray: arrayOfCommentsUPDATED];
    
    NSLog(@"self.arrayOfComments.AFTA = %@", self.arrayOfComments);

}
- (void) insertRepliesIntoThread:(NSArray *)repliesRCVD atIndexPath:(int)indexPathRCVD {
    
    int removalIndex = indexPathRCVD;
    
    NSArray *arrayOfNewReplies = [[NSArray alloc] initWithArray: repliesRCVD ];

    NSMutableArray *arrayOfCommentsUPDATING = [[NSMutableArray alloc] initWithArray: self.arrayOfComments ];

    // REMOVE THE LOAD MORE && THE FIRST REPLY
    [arrayOfCommentsUPDATING removeObjectAtIndex: removalIndex];
    removalIndex--;
    [arrayOfCommentsUPDATING removeObjectAtIndex: removalIndex];

    // ADD ALL REPLIES
    for (NSDictionary *thisReply in arrayOfNewReplies) {
        
        [arrayOfCommentsUPDATING insertObject:thisReply atIndex:removalIndex];
        
        removalIndex++;
        
    }

    self.arrayOfComments = [[NSArray alloc] initWithArray:arrayOfCommentsUPDATING];
    
    [self tableViewReload];
    
}

#pragma mark - IBACTION & RELATED BUTTONS

- (void) buReplySelected : (id)sender {
    
    int indexPathRow = (int)[sender tag] - 1;
    
    self.parentCommentDictionary = [[NSDictionary alloc] initWithDictionary: [self.arrayOfComments objectAtIndex:indexPathRow] ];
    
    NSLog(@"self.parentCommentDictionary = %@", self.parentCommentDictionary);
    
    if ( [[self.parentCommentDictionary objectForKey:@"COMMENT_TYPE"] isEqualToString:@"load_more"] ) {
        
        
    } else {
        
        [self prepareForComment];
        
    }

}
- (void) resetCommentStatus {

    self.textFieldComment.text = @"";
    
    self.parentCommentDictionary = nil;
    
    self.viewSpinner.alpha = 0.0;
    
    [self.textFieldComment resignFirstResponder];

}
- (IBAction) buSendSelected : (id)sender {

    int acceptableLength = 1;
    
    if (self.textFieldComment.text.length < acceptableLength) {
        // CHILL
    } else {
        [self setupCommentForPublication];
        
    }
    
}
- (IBAction) buCancelSelected : (id)sender {
    
    [self resetCommentStatus];
    
}
- (IBAction) buExitSelected : (id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
