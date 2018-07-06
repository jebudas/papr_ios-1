//
//  PaprCellHeader.m
//  papr
//
//  Created by Brian WF Tobin on 8/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellHeader.h"

@implementation PaprCellHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // ROUNDED CORNER
    self.imageViewAvatar.backgroundColor = [UIColor cyanColor];
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.cornerRadius = 5;
    
    [self setupNotifications];
    
}
- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationButton) name:@"PaprCellHeader.updateNotificationButton" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprCellHeader.updateNotificationButton" object:nil];
    
}

- (void) updateNotificationButton {

    if ( [DataController dc].currentNotificationCount > 0) {
    
        self.imageViewComment.image = [UIImage imageNamed:@"header_papr_comment_on.png"];
    
    } else {

        self.imageViewComment.image = [UIImage imageNamed:@"header_papr_comment_off.png"];
    
    }
    
    
}

- (IBAction) buLogoSelected : (id)sender {
    
    [DataController dc].currentPaprDictionary = [[NSDictionary alloc] initWithDictionary: self.thisCellDictionary ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileVC" object:nil];
    
}

- (IBAction) buCommentSelected : (id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprUserNotificationsVC" object:nil];
    
}

@end
