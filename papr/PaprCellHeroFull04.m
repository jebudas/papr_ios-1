//
//  PaprCellHeroFull04.m
//  papr
//
//  Created by Brian WF Tobin on 12/21/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprCellHeroFull04.h"

@implementation PaprCellHeroFull04


- (void) awakeFromNib {
    
    [super awakeFromNib];
    
}
- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

#pragma mark - GESTURE METHODS

- (IBAction) buButtonsSelected : (id)sender {
    
    [self cellDrag:nil];
    
}
- (void) cellDrag : (id)sender {
    
    // TESTING
    
    if ([DataController dc].cellSliderIsOpen) {
        
        [self resetCell];
        
    } else {
        
        [self cellDragActual];
        
    }
    
}
- (void) cellDragActual {
    
    [DataController dc].cellSliderIsMoving = TRUE;
    
    self.viewButtons.alpha = 1.0;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         
                         int offsetX = [[DataController dc] returnRelativeSizeForThisScreen:192] * -1;
                         
                         NSLog(@"offsetX = %i", offsetX);
                         
                         self.viewSlider.frame = CGRectMake(offsetX, self.viewSlider.frame.origin.y, self.viewSlider.frame.size.width, self.viewSlider.frame.size.height);
                         
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

#pragma mark - IBACTION METHODS

- (IBAction) buEllipsisOpen : (id)sender {
    
    return;
    
    if (cellShouldOpen) {
        
        [self cellDrag:nil];
        return;
        
    } else if ([DataController dc].cellSliderIsOpen) {
        
        [self resetCell];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToRight" object:nil];
    
    
}
- (IBAction) buEllipsisClose : (id)sender {
    
    return;
    
    if (cellShouldOpen) {
        
        [self cellDrag:nil];
        return;
        
    } else if ([DataController dc].cellSliderIsOpen) {
        
        [self resetCell];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToRight" object:nil];
    
    
}
- (IBAction) buCommentSelected : (id)sender {
    
    NSLog(@"buCommentSelected . self.cellDictionary = %@", self.cellDictionary);
    
    NSDictionary *commentDictionary = @{@"comment_id" : [self.cellDictionary objectForKey:@"post_id"],
                                        @"publisher_id" : [self.cellDictionary objectForKey:@"post_publisher"]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprCommentVC" object:nil userInfo:commentDictionary];
    
    [self.buComment setBackgroundImage:[UIImage imageNamed:@"bu_icon_comment_on.png"] forState:UIControlStateNormal];
    
    [self resetCell];
    
}
- (IBAction) buShareSelected : (id)sender {

    NSLog(@"buShareSelected pressed");
    NSString *texttoshare = @"text to share";
    UIImage *imagetoshare = [UIImage imageNamed:@"beck.png"];
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
//    [self.view presentViewController:activityVC animated:TRUE completion:nil];
    
}

@end
