//
//  PaprCellText.m
//  papr
//
//  Created by Brian WF Tobin on 8/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellText.h"

@implementation PaprCellText

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - GESTURE METHODS

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
- (void) swipeLeft : (id)sender {
    
    if ([DataController dc].cellSliderIsOpen) {
        
        NSString *thisTag = [NSString stringWithFormat:@"%i", (int)self.tag];
        NSString *openTag = [NSString stringWithFormat:@"%@", [[DataController dc].cellOpenDictionary objectForKey:@"tag"] ];
        
        if ([thisTag isEqualToString:openTag]) {

            [self resetCell];
            return;
        
        } else {
        
        }
        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToLeft" object:nil];

}
- (void) swipeRight : (id)sender {
    
    if (cellShouldOpen) {
        
        [self cellDrag:nil];
        return;
        
    } else if ([DataController dc].cellSliderIsOpen) {
        
        [self resetCell];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToRight" object:nil];
    
}


@end
