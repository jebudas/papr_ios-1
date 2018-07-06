//
//  PaprCellHeaderPost.m
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellHeaderPost.h"

@implementation PaprCellHeaderPost

- (void)awakeFromNib {

    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // ROUNDED CORNER
    self.imageViewAvatar.backgroundColor = [UIColor cyanColor];
    self.imageViewAvatar.layer.masksToBounds = YES;
    self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.size.width / 5;

    // ROUNDED LABELS + TEXT UPDATE
    self.labelViews.layer.masksToBounds = YES;
    self.labelViews.layer.cornerRadius = 5;
    self.labelViews.text = [NSString stringWithFormat:@"%i Views", [DataController dc].currentPaprViewsCount ];

}

#pragma mark - HEADER SETUP

- (void) hideAllButtons {

    self.buDone.alpha = 0.0;
    self.buEdit.alpha = 0.0;
    self.buExit.alpha = 0.0;
    self.buPlus.alpha = 0.0;
    self.buPost.alpha = 0.0;
    self.buFollowers.alpha = 0.0;

}
- (void) setupHeader : (NSString *)statusRCVD {

    [self hideAllButtons];
    
    self.headerStatus = statusRCVD;
    
    if ( [self.headerStatus isEqualToString:@"create"] ) {
        
        self.buExit.alpha = 1.0;
        self.buPost.alpha = 1.0;
        
    } else if ( [self.headerStatus isEqualToString:@"edit"] ) {
        
        self.buDone.alpha = 1.0;
        
    } else if ( [self.headerStatus isEqualToString:@"preview"] ) {

        self.buEdit.alpha = 1.0;
        self.buPlus.alpha = 1.0;
        
    }
 
}


#pragma mark - IBACTION METHODS

- (IBAction) buDoneSelected : (id)sender {

    NSLog(@"PaprCellHeaderPost . buDoneSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostEditVC.popSelf" object:nil];

}
- (IBAction) buEditSelected : (id)sender {
    
    NSLog(@"PaprCellHeaderPost . buEditSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostPreviewVC.pushPaprPostEditVC" object:nil];

}
- (IBAction) buExitSelected : (id)sender {
    
    NSLog(@"PaprCellHeaderPost . buExitSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostCreateVC.popSelf" object:nil];

}
- (IBAction) buPlusSelected : (id)sender {
    
    NSLog(@"PaprCellHeaderPost . buPlusSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostPreviewVC.pushPaprPostCreateVC" object:nil];

}
- (IBAction) buPostSelected : (id)sender {
    
    NSLog(@"PaprCellHeaderPost . buPostSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostCreateVC.postPapr" object:nil];

}
- (IBAction) buFollowersSelected : (id)sender {
    
    NSLog(@"PaprCellHeaderPost . buFollowersSelected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileFollowersVC" object:nil];
    
}

@end
