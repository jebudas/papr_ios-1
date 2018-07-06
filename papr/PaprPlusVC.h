//
//  PaprPlusVC.h
//  papr
//
//  Created by Brian WF Tobin on 4/5/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "LoginSelectionCell.h"
// API
#import "APIController+User.h"
#import "APIController+Search.h"
// AUTRE
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"


@interface PaprPlusVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    BOOL iAmExploring;
    BOOL iAmFiltering;
    BOOL searchIsActive;
    
    CGRect frameSearchBG;
    CGRect frameSearchTextField;

}

// DATA
@property (nonatomic, strong) NSArray *arrayOfSources;
@property (nonatomic, strong) NSMutableArray *arrayOfSourcesMINE;
@property (nonatomic, strong) NSMutableArray *arrayOfSourcesEXPLORE;
@property (nonatomic, strong) NSMutableArray *arrayOfSourcesFILTERED;
// IBOUTLET
@property (nonatomic, weak) IBOutlet UILabel *labelHeader;
@property (nonatomic, weak) IBOutlet UIView *viewNoResults;
@property (nonatomic, weak) IBOutlet UIView *viewRequestSource;
@property (nonatomic, weak) IBOutlet UIButton *buCancelSearch;
@property (nonatomic, weak) IBOutlet UIButton *buExploreAndSubscriptions;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSearchRequest;
@property (nonatomic, weak) IBOutlet UITextField *textFieldSearchSources;
@property (nonatomic, weak) IBOutlet UITableView *tableViewAddSources;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewGlyphLeft;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewGlyphRight;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewTextFieldBG;

@end

