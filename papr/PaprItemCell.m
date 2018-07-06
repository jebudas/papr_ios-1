//
//  PaprItemCell.m
//  papr
//
//  Created by Brian WF Tobin on 10/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprItemCell.h"

@implementation PaprItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void) resetCell {
    
    [DataController dc].cellSliderIsMoving = TRUE;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         
                         self.viewSlider.frame = CGRectMake(0, self.viewSlider.frame.origin.y, self.viewSlider.frame.size.width,self.viewSlider.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         self.viewButtons.alpha = 0.0;

                         cellSliderIsOpen = FALSE;
                         cellSliderIsMoving = FALSE;
                         
                         [DataController dc].cellOpenDictionary = nil;
                         [DataController dc].cellSliderIsOpen = FALSE;
                         [DataController dc].cellSliderIsMoving = FALSE;
                         
                     }];
    
}

#pragma mark - API METHODS

- (void) sendStats : (NSDictionary *)dictionaryRCVD {

    NSLog(@"PaprItemCell . sendStats . dictionaryRCVD = %@", dictionaryRCVD);
    
    NSString *notificationType = [dictionaryRCVD objectForKey:@"type_field"];
    NSString *commentString;
    
    if ( [notificationType isEqualToString:@"comment"] ) {
        commentString = [dictionaryRCVD objectForKey:@"comment"];
    } else {
        commentString = @"-";
    }
    
    NSDictionary *statsDictionary = @{@"type_field" : [dictionaryRCVD objectForKey:@"type_field"],
                                      @"friend_id": [[DataController dc] returnMyUserID],
                                      @"friend_username" : [[DataController dc] returnMyUsername],
                                      @"friend_avatar_url": [[DataController dc] returnMyAvatarURL],
                                      @"comment": commentString,
                                      @"timestamp": [dictionaryRCVD objectForKey:@"timestamp"],
                                      @"post_id":[dictionaryRCVD objectForKey:@"post_id"],
                                      @"publisher_id":[dictionaryRCVD objectForKey:@"publisher_id"]
                                      };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendStats" object:nil userInfo:@{@"stats" : statsDictionary}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.sendNotifications" object:nil userInfo:@{@"notifications" : statsDictionary}];

}

#pragma mark - IBACTION METHODS

- (IBAction) buLikeActual {

    NSLog(@"buLikeActual . self.cellDictionary = %@", self.cellDictionary);
    
    NSDictionary *parameters = @{ @"post_dictionary" : self.cellDictionary, @"user_id" : [[DataController dc] returnMyUserID]};
    
    [[APIController api] saveItemToSavedPosts:parameters success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            [self.buSave setBackgroundImage:[UIImage imageNamed:@"bu_icon_save_on.png"] forState:UIControlStateNormal];
            
        } else {
            
        }
        
        NSDictionary *statsDictionary = @{@"type_field" : @"likes",
                                          @"timestamp": [[DataController dc] returnTimestamp],
                                          @"post_id":[self.cellDictionary objectForKey:@"post_id"],
                                          @"publisher_id":[self.cellDictionary objectForKey:@"post_publisher"]
                                          };
        
        [self sendStats : statsDictionary];
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprCellText . buSaveSelected . failure . error = %@", error);
        
    }];
    
    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Saved Post"}];

}
- (IBAction) buRepostActual {
    
    NSLog(@"buRepostActual . self.cellDictionary = %@", self.cellDictionary);
    
    NSString *publisherID = [self.cellDictionary objectForKey:@"post_publisher"];
    
    if ([publisherID isEqualToString:[[DataController dc] returnMyUserID]]) {
        return;
    } else {
        
        [self.buRepost setBackgroundImage:[UIImage imageNamed:@"bu_icon_repost_on.png"] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprPostCreateVC" object:nil userInfo:self.cellDictionary];
        
        [self resetCell];
        
        NSDictionary *statsDictionary = @{@"type_field" : @"reposts",
                                          @"timestamp": [[DataController dc] returnTimestamp],
                                          @"post_id":[self.cellDictionary objectForKey:@"post_id"],
                                          @"publisher_id":[self.cellDictionary objectForKey:@"post_publisher"]
                                          };
        
        
        [self sendStats : statsDictionary];
        
    }
    
    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Repost"}];
    
}
- (IBAction) buShareActual {

    NSLog(@"buShareActual . self.cellDictionary = %@", self.cellDictionary);
    
    NSDictionary *shareDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [self.cellDictionary objectForKey:@"post_title"], @"share_text",
                                     [self.cellDictionary objectForKey:@"post_link"], @"share_url",
                                     nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.sharePaperArticle" object:nil userInfo:shareDictionary];
    
}

- (IBAction) buSaveActual {

    NSLog(@"buSaveActual . self.cellDictionary = %@", self.cellDictionary);
    
    NSDictionary *parameters = @{ @"post_dictionary" : self.cellDictionary, @"user_id" : [[DataController dc] returnMyUserID]};
    
    [[APIController api] saveItemToSavedPosts:parameters success:^(NSDictionary *responseDictionary) {
        
        if ([[responseDictionary objectForKey:@"success"] intValue]) {
            
            [self.buSave setBackgroundImage:[UIImage imageNamed:@"bu_icon_save_on.png"] forState:UIControlStateNormal];
            
        } else {
            
        }
        
        NSDictionary *statsDictionary = @{@"type_field" : @"likes",
                                          @"timestamp": [[DataController dc] returnTimestamp],
                                          @"post_id":[self.cellDictionary objectForKey:@"post_id"],
                                          @"publisher_id":[self.cellDictionary objectForKey:@"post_publisher"]
                                          };
        
        [self sendStats : statsDictionary];

    } failure:^(NSError *error) {
        
        NSLog(@"PaprCellText . buSaveSelected . failure . error = %@", error);
        
    }];

    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Saved Post"}];

}
- (IBAction) buCommentActual {
    
    NSLog(@"buCommentActual");

    [self.buComment setBackgroundImage:[UIImage imageNamed:@"bu_icon_comment_on.png"] forState:UIControlStateNormal];

    NSDictionary *commentDictionary = @{@"comment_id" : [self.cellDictionary objectForKey:@"post_id"],
                                        @"publisher_id" : [self.cellDictionary objectForKey:@"post_publisher"]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprCommentVC" object:nil userInfo:commentDictionary];
    
    [self resetCell];

    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Comment"}];

}



@end
