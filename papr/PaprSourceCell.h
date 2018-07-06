//
//  PaprSourceCell.h
//  papr
//
//  Created by Brian WF Tobin on 2/11/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaprSourceCell : UICollectionViewCell <UIGestureRecognizerDelegate> {

}
@property (nonatomic, strong) NSString *publisherID;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewMask;
@property (nonatomic, weak) IBOutlet UILabel *labelDisplayName;
@property (nonatomic, weak) IBOutlet UIButton *buEdit;

- (void) setMaskOn;
- (void) setMaskOff;
- (void) setLabelTextBold;
- (void) setLabelTextRegular;

@end
