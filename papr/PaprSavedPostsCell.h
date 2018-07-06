//
//  PaprSavedPostsCell.h
//  papr
//
//  Created by Brian WF Tobin on 10/23/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaprSavedPostsCell : UITableViewCell {
    //
}

@property (nonatomic, strong) NSDictionary *cellDictionary;
@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UILabel *labelAvatar;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;


@end
