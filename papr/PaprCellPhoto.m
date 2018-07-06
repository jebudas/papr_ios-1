//
//  PaprCellPhoto.m
//  papr
//
//  Created by Brian WF Tobin on 9/7/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellPhoto.h"

@implementation PaprCellPhoto

- (void) awakeFromNib {
    
    [super awakeFromNib];

}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.imageViewPhoto.backgroundColor = [UIColor clearColor];
    self.imageViewPhoto.layer.masksToBounds = YES;
    self.imageViewPhoto.layer.cornerRadius = 5;

}

#pragma mark - GESTURE METHODS

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    CGPoint touchLocation = [touch locationInView:self];
    
    if (touchLocation.x > 30) {
        cellShouldOpen = TRUE;
    } else {
        cellShouldOpen = FALSE;
    }

    return YES;

}
- (void) cellDrag : (id)sender {
    
    // TESTING
    
    if ([DataController dc].cellSliderIsOpen) {
        // CHILL
    } else {
        
        NSLog(@"cellDrag . tag = %i", (int)self.tag);
        
        [self cellDragActual];
        
    }
    
}
- (void) cellDragActual {
    
    self.viewButtons.alpha = 1.0;

    [DataController dc].cellSliderIsMoving = TRUE;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         
                         self.viewSlider.frame = CGRectMake(192, self.viewSlider.frame.origin.y, self.viewSlider.frame.size.width,self.viewSlider.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         cellSliderIsOpen = TRUE;
                         cellSliderIsMoving = FALSE;
                         
                         NSString *tag = [NSString stringWithFormat:@"%i", (int)self.tag];
                         [DataController dc].cellOpenDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"tag":tag,@"type":@"image"}];
                         [DataController dc].cellSliderIsOpen = TRUE;
                         [DataController dc].cellSliderIsMoving = FALSE;
                         
                     }];
    
}
- (void) swipeLeft : (id)sender {
    
    if ([DataController dc].cellSliderIsOpen) {
        
        [self resetCell];
        
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
