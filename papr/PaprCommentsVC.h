//
//  PaprCommentsVC.h
//  papr
//
//  Created by Brian WF Tobin on 2/22/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "PaprCommentCell.h"
#import "PaprCommentsCell.h"
#import "PaprCommentsReplyCell.h"
// API
#import "APIController+Comments.h"
#import "APIController+Statistics.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"

@interface PaprCommentsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    BOOL iHaveRequestedComments;
    BOOL iAmCommenting;
    
    int frameViewTextFieldOffsetY;
    CGRect frameViewTextFieldOriginal;
    
}

// v1.4
@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) NSString *commentSetID;
@property (nonatomic, strong) NSDictionary *parentCommentDictionary;
@property (nonatomic, strong) NSDictionary *postDictionary;
@property (nonatomic, strong) NSString *selectedCommentID;
@property (nonatomic, strong) NSString *selectedCommentUsername;
@property (nonatomic, weak) IBOutlet UITableView *tableViewComments;
@property (nonatomic, weak) IBOutlet UIView *viewTextField;
@property (nonatomic, weak) IBOutlet UIButton *buCancel;
@property (nonatomic, weak) IBOutlet UIView *viewSpinner;
@property (nonatomic, weak) IBOutlet UILabel *labelBeTheFirst;


// PRE v1.4
@property (nonatomic, strong) NSDictionary *commentDictionary;
@property (nonatomic, strong) NSArray *arrayOfComments;
@property (nonatomic, weak) IBOutlet UILabel *labelHeader;
@property (nonatomic, weak) IBOutlet UITextField *textFieldComment;



@end
