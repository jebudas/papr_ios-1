//
//  PaprSourceCell.m
//  papr
//
//  Created by Brian WF Tobin on 2/11/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprSourceCell.h"

@implementation PaprSourceCell

- (void)awakeFromNib {

    [super awakeFromNib];

    [self setupCollectionViewGesture];

}
- (void) setupCollectionViewGesture {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressActivated:)];
    longPress.delegate = self;
    longPress.delaysTouchesBegan = YES;
    longPress.minimumPressDuration = 5.0;
    [self addGestureRecognizer:longPress];
    
}
- (void) setMaskOn {
    
    self.imageViewMask.image = [UIImage imageNamed:@"source_mask_on.png"];
    
}
- (void) setMaskOff {
    
    self.imageViewMask.image = [UIImage imageNamed:@"source_mask_off.png"];
    
}
- (void) setLabelTextBold {

    [self.labelDisplayName setFont: [UIFont systemFontOfSize:11 weight:UIFontWeightBold] ];

}
- (void) setLabelTextRegular {

    [self.labelDisplayName setFont: [UIFont systemFontOfSize:11 weight:UIFontWeightLight] ];

}

- (void) longPressActivated : (UILongPressGestureRecognizer *)gestureRecognizer {

    NSLog(@"longPressActivated.tag = %i", (int)self.tag);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.turnEditingOn" object:nil];

}
- (IBAction) buDeleteSelected : (id)sender {
    
    NSString *sourceTag = [NSString stringWithFormat:@"%i", (int)self.tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.deleteSource" object:nil userInfo:@{@"source_tag":sourceTag}];

}

@end
