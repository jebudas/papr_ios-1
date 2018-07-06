//
//  PaprCellHeaderPost.h
//  papr
//
//  Created by Brian WF Tobin on 8/29/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "APIController+User.h"


@interface PaprCellHeaderPost : UITableViewCell {
    //
}

@property (nonatomic, strong) NSString *headerStatus;


@property (nonatomic, weak) IBOutlet UIButton *buDone;
@property (nonatomic, weak) IBOutlet UIButton *buEdit;
@property (nonatomic, weak) IBOutlet UIButton *buExit;
@property (nonatomic, weak) IBOutlet UIButton *buPlus;
@property (nonatomic, weak) IBOutlet UIButton *buPost;
@property (nonatomic, weak) IBOutlet UIButton *buFollowers;

@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelComments;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewComment;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewCommentCircle;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewProgress;
@property (nonatomic, weak) IBOutlet UILabel *labelViews;

- (void) setupHeader : (NSString *)statusRCVD;

@end
