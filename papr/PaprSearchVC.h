//
//  PaprSearchVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "SearchCellEditor.h"
#import "SearchCellAccount.h"
// API
#import "APIController+Search.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"


@interface PaprSearchVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    BOOL searchIsActive;
    BOOL editorCellIsOpen;
    CGRect frameTextFieldOriginal;
    
}

// DATA
@property (nonatomic, strong) NSArray *arrayOfFeatured;
@property (nonatomic, strong) NSMutableArray *arrayOfSearchUsers;
// IBOUTLET
@property (nonatomic, weak) IBOutlet UILabel *labelNotification;
@property (nonatomic, weak) IBOutlet UIButton *buCancel;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSearch;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewNotification;
@property (nonatomic, weak) IBOutlet UITableView *tableViewFeatured;
@property (nonatomic, weak) IBOutlet UIView *viewSearch;
@property (nonatomic, weak) IBOutlet UIView *viewSearchEmpty;
@property (nonatomic, weak) IBOutlet UIView *viewSearchSpinner;
@property (nonatomic, weak) IBOutlet UITableView *tableViewSearch;


@end
