//
//  PaprCellText04.m
//  papr
//
//  Created by Brian WF Tobin on 12/14/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellText04.h"

@implementation PaprCellText04

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - SUB-BUTTON METHODS

- (void) cellDrag : (id)sender {
    
    // TESTING
    
    if ([DataController dc].cellSliderIsOpen) {
        // CHILL
    } else {
        
        [self cellDragActual];
        
    }
    
}
- (void) cellDragActual {
    
    [DataController dc].cellSliderIsMoving = TRUE;
    
    self.viewButtons.alpha = 1.0;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         
                         self.viewSlider.frame = CGRectMake(192, self.viewSlider.frame.origin.y, self.viewSlider.frame.size.width,self.viewSlider.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         cellSliderIsOpen = TRUE;
                         cellSliderIsMoving = FALSE;
                         
                         NSString *tag = [NSString stringWithFormat:@"%i", (int)self.tag];
                         [DataController dc].cellOpenDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"tag":tag,@"type":@"text"}];
                         [DataController dc].cellSliderIsOpen = TRUE;
                         [DataController dc].cellSliderIsMoving = FALSE;
                         
                         [self performSelector:@selector(resetCell) withObject:nil afterDelay:3.0];
                         
                     }];
    
}


@end
