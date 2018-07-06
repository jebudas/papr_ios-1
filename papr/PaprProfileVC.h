//
//  PaprProfileVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaprCellText.h"
#import "PaprCellProfile.h"
#import "DataController.h"
// API
#import "APIController+User.h"
// TOOLS
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"


@interface PaprProfileVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    int cellTextHeight;
    int sectionCurrentCount;
    int sectionArchiveCount;
    
    BOOL iHaveAppeared;
    
}


@property (nonatomic, strong) NSArray *arrayOfPaprItems;
@property (nonatomic, strong) NSDictionary *headerDictionary;
@property (nonatomic, strong) NSDictionary *profileDictionary;
@property (nonatomic, assign) BOOL thisIsMe;
@property (nonatomic, assign) BOOL thisIsSearch;
@property (nonatomic, weak) IBOutlet UITableView *tableViewProfile;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labelEllipsis;
@property (nonatomic, weak) IBOutlet UIView *viewEmpty;



@end
