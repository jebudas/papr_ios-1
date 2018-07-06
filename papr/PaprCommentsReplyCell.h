//
//  PaprCommentsReplyCell.h
//  papr
//
//  Created by Brian WF Tobin on 2/24/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaprCommentsReplyCell : UITableViewCell {
    //
}

@property (nonatomic, weak) NSString *publisherID;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UILabel *labelTimestamp;

@end
