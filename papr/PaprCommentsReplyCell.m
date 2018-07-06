//
//  PaprCommentsReplyCell.m
//  papr
//
//  Created by Brian WF Tobin on 2/24/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCommentsReplyCell.h"

@implementation PaprCommentsReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) buAvatarSeelcted : (id)sender {
    
    NSLog(@"self.publisherID = %@", self.publisherID);
    
}

@end
