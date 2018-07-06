//
//  PaprCellHeader.h
//  papr
//
//  Created by Brian WF Tobin on 8/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"


@interface PaprCellHeader : UITableViewCell {
    //
}

@property (nonatomic, strong) NSDictionary *thisCellDictionary;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewMast;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelAvatar;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewComment;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewProgress;

@end
