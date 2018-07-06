//
//  SearchCellAccount.h
//  papr
//
//  Created by Brian WF Tobin on 9/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "APIController+User.h"
#import "UIColor+PAPRColor.h"


@interface SearchCellAccount : UITableViewCell {

    BOOL iAmSubscribedToThisAccount;

}

@property (nonatomic, strong) NSDictionary *cellDictionary;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelPublisher;
@property (nonatomic, weak) IBOutlet UILabel *labelUsername;
@property (nonatomic, weak) IBOutlet UIButton *buFollow;

@end
