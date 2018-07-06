//
//  PaprTableCell.m
//  papr
//
//  Created by Brian WF Tobin on 2/14/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprTableCell.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"
// SAFARI
@import SafariServices;


@implementation PaprTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - TOOLS

- (void) launchArticle : (NSDictionary *)cellDictionaryRCVD {
    
    
}


- (IBAction) buLinkSelected : (id)sender {
    
    // NSLog(@"buLinkSelected");
    
    NSString *cellURL = [self.cellDictionary objectForKey:@"post_link"];
    
    // SNTAH
    if (cellURL.length < 7) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushSafariBrowser" object:nil userInfo:@{@"url" : cellURL}];
    
    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Article Clicked"}];

//    if ([self.delegate respondsToSelector:@selector(launchArticleWithTag:)]) {
//        [self.delegate launchArticleWithTag : (int)self.tag];
//    }

}
- (IBAction) buShareSelected : (id)sender {
    
    NSLog(@"buShareSelected");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showFullScreenSpinner" object:nil];

    NSLog(@"buShareActual . [self.cellDictionary objectForKey:@post_id] = %@", [self.cellDictionary objectForKey:@"post_id"]);
    
    NSString *shortyString = [[DataController dc] returnShortURL: [self.cellDictionary objectForKey:@"post_id"] ];

    NSDictionary *urlDictionary = @{@"url_actual": [self.cellDictionary objectForKey:@"post_link"],
                                    @"url_shorty": shortyString,
                                    @"post_title": [self.cellDictionary objectForKey:@"post_title"],
                                    @"post_image_url": [self.cellDictionary objectForKey:@"post_image_url"],
                                    @"post_publisher": [self.cellDictionary objectForKey:@"post_publisher"]};
    
    [[APIController api] postShareURL:urlDictionary success:^(NSDictionary *responseDictionary) {
        
        NSDictionary *shortyDictionary = [[NSDictionary alloc] initWithDictionary: [responseDictionary objectForKey:@"shorty_dictionary"] ];
        
        NSString *smartURL = [NSString stringWithFormat:@"%@/%@", PAPR_API_SHARE_URL, [shortyDictionary objectForKey:@"URL_SHORTY"]];
        
        NSDictionary *shareDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [self.cellDictionary objectForKey:@"post_title"], @"share_text",
                                         smartURL, @"share_url",
                                         nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hideFullScreenSpinner" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.sharePaperArticle" object:nil userInfo:shareDictionary];

        [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Shared"}];

    } failure:^(NSError *error) {
        
        NSLog(@"PaprTableCell . getShareURL . failure . error = %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hideFullScreenSpinner" object:nil];

        NSLog(@"");

    }];

}
- (IBAction) buCommentSelected : (id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprBaseVC.pushPaprCommentsWithDictionary" object:nil userInfo:@{@"post_dictionary":self.cellDictionary}];

    [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Comments . Read"}];
    
}
- (IBAction) buLikeSelected : (id)sender {
    
    NSLog(@"buLikeSelected");
    
    if (iLikeThis) {
        
        iLikeThis = FALSE;
        
        [self.buLike setBackgroundImage:[UIImage imageNamed:@"footer_bu_heart_0.png"] forState:UIControlStateNormal];

        [[APIController api] removeLikes: [self.cellDictionary objectForKey:@"post_id"] ];

    } else {
        
        iLikeThis = TRUE;
        
        [self.buLike setBackgroundImage:[UIImage imageNamed:@"footer_bu_heart_1.png"] forState:UIControlStateNormal];
        
        [[APIController api] addLikes: [self.cellDictionary objectForKey:@"post_id"] ];

        [[Mixpanel sharedInstance] track:@"Papr . Post Interaction" properties: @{@"Action": @"Liked"}];

    }
    
}


@end
