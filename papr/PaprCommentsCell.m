//
//  PaprCommentsCell.m
//  papr
//
//  Created by Brian WF Tobin on 2/24/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCommentsCell.h"

@implementation PaprCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) resetVoteImages {
    
    iHaveVotedUp = FALSE;
    iHaveVotedDown = FALSE;
    
    self.imageViewVoteUp.image = [UIImage imageNamed:@"comment_vote_up_0.png"];
    self.imageViewVoteDown.image = [UIImage imageNamed:@"comment_vote_down_0.png"];
    
}
- (void) updateVoteLabel : (int)voteRCVD {
    
    int intVotes = [self.labelVotes.text intValue];
    intVotes = intVotes + voteRCVD;
    
    [self setVoteLabel: intVotes ];
    
}
- (void) setVoteLabel : (int)voteRCVD {

    if (voteRCVD >= 0) {

        self.labelVotes.alpha = 1.0;
        self.imageViewVoteSkull.alpha = 0.0;
        self.labelVotes.text = [NSString stringWithFormat:@"%i", voteRCVD];

    } else {
        
        self.labelVotes.alpha = 0.0;
        self.imageViewVoteSkull.alpha = 1.0;
        self.labelVotes.text = @"-1";

    }
        
        

}
- (void) updateVoteUpArray : (BOOL)addVote {

    if (addVote) {
    
    
    } else {
    
    
    
    }
    
}

- (IBAction) buAvatarSeelcted : (id)sender {

    NSLog(@"self.publisherID = %@", self.publisherID);
    
}
- (IBAction) buVoteUp : (id)sender {
    
    NSLog(@"buVoteUp . self.publisherID = %@", self.publisherID);
    
    if (iHaveVotedUp) {

        // VOTE . ARRAY OF UPVOTES . REMOVE
        [[APIController api] removeUpVotes:self.commentID];
        
        // UPDATE VOTE
        [self updateVoteLabel: -1 ];

        // TURN OFF VOTE, RESET BOOLEANS
        [self resetVoteImages];

    } else {

        // UPDATE VOTE
        if (iHaveVotedDown) {

            // VOTE . ARRAY OF UPVOTES . ADD
            [[APIController api] addUpVotes:self.commentID];

            // VOTE . ARRAY OF DOWNVOTES . REMOVE
            [[APIController api] removeDownVotes:self.commentID];

            [self updateVoteLabel: 2 ];
        
        } else {

            // VOTE . ARRAY OF UPVOTES . ADD
            [[APIController api] addUpVotes:self.commentID];

            [self updateVoteLabel: 1 ];
        
        }

        // TURN OFF VOTE, RESET BOOLEANS
        [self resetVoteImages];

        // UPVOTE :)
        iHaveVotedUp = TRUE;
        iHaveVotedDown = FALSE;
        self.imageViewVoteUp.image = [UIImage imageNamed:@"comment_vote_up_1.png"];

    }
    
}
- (IBAction) buVoteDown : (id)sender {
    
    NSLog(@"buVoteDown . self.publisherID = %@", self.publisherID);

    if (iHaveVotedDown) {
    
        // VOTE . ARRAY OF DOWNVOTES . REMOVE
        [[APIController api] removeDownVotes:self.commentID];

        // UPDATE VOTE
        [self updateVoteLabel: 1 ];

        // TURN OFF VOTE, RESET BOOLEANS
        [self resetVoteImages];

    } else {

        // UPDATE VOTE
        if (iHaveVotedUp) {

            // VOTE . ARRAY OF DOWNVOTES . ADD
            [[APIController api] addDownVotes:self.commentID];

            // VOTE . ARRAY OF UPVOTES . REMOVE
            [[APIController api] removeUpVotes:self.commentID];

            [self updateVoteLabel: -2 ];
        
        } else {

            // VOTE . ARRAY OF DOWNVOTES . ADD
            [[APIController api] addDownVotes:self.commentID];

            [self updateVoteLabel: -1 ];
        
        }

        // TURN OFF VOTE, RESET BOOLEANS
        [self resetVoteImages];

        // DOWNVOTE :(
        iHaveVotedUp = FALSE;
        iHaveVotedDown = TRUE;
        self.imageViewVoteDown.image = [UIImage imageNamed:@"comment_vote_down_1.png"];
    
    }

}



@end
