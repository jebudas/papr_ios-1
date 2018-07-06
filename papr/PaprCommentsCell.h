//
//  PaprCommentsCell.h
//  papr
//
//  Created by Brian WF Tobin on 2/24/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
// API
#import "APIController.h"


@interface PaprCommentsCell : UITableViewCell {
    
    BOOL iHaveVotedUp;
    BOOL iHaveVotedDown;
    
}

@property (nonatomic, weak) NSString *commentID;
@property (nonatomic, weak) NSString *publisherID;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UILabel *labelTimestamp;
// VOTING
@property (nonatomic, weak) IBOutlet UIButton *buVoteUp;
@property (nonatomic, weak) IBOutlet UIButton *buVoteDown;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewVoteUp;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewVoteDown;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewVoteSkull;
@property (nonatomic, weak) IBOutlet UILabel *labelVotes;

- (void) setVoteLabel : (int)voteRCVD;

@end
