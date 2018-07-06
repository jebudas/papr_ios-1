//
//  PaprCommentCell.h
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaprCommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UILabel *labelTime;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;

@end
