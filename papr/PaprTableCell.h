//
//  PaprTableCell.h
//  papr
//
//  Created by Brian WF Tobin on 2/14/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
// API
#import "APIController.h"
#import "APIController+Share.h"


@protocol PaprTableCellDelegate <NSObject>
- (void) launchArticleWithTag : (int)tagRCVD;
@end

@interface PaprTableCell : UITableViewCell {
    
    BOOL iLikeThis;
    id <PaprTableCellDelegate> delegate;

}

@property (nonatomic, strong) NSDictionary *cellDictionary;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewMain;
@property (nonatomic, weak) IBOutlet UIView *viewImage;
@property (nonatomic, weak) IBOutlet UIView *viewTitle;
@property (nonatomic, weak) IBOutlet UIView *viewDescription;

@property (nonatomic, weak) IBOutlet UILabel *labelTitle01;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle02;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle03;
@property (nonatomic, weak) IBOutlet UILabel *labelURL;
@property (nonatomic, weak) IBOutlet UILabel *labelDescription;
// FOOTER
@property (nonatomic, weak) IBOutlet UIView *viewFooter;
@property (nonatomic, weak) IBOutlet UIView *viewFooterFinal;
@property (nonatomic, weak) IBOutlet UIButton *buLike;
@property (nonatomic, weak) IBOutlet UILabel *labelComments;
@property (nonatomic, weak) IBOutlet UILabel *labelTimestamp;

@property (nonatomic, weak) id <PaprTableCellDelegate> delegate;

@end



