//
//  PaprCommentVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/17/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "PaprCommentCell.h"
#import "APIController+Comments.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"


@interface PaprCommentVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    //
}


@property (nonatomic, strong) NSDictionary *commentDictionary;
@property (nonatomic, strong) NSArray *arrayOfComments;
@property (nonatomic, weak) IBOutlet UILabel *labelHeader;
@property (nonatomic, weak) IBOutlet UIView *viewComment;
@property (nonatomic, weak) IBOutlet UITextField *textFieldComment;
@property (nonatomic, weak) IBOutlet UITableView *tableViewComments;


@end
