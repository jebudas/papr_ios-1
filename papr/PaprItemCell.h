//
//  PaprItemCell.h
//  papr
//
//  Created by Brian WF Tobin on 10/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
// API
#import "APIController+Paprboy.h"
#import "APIController+Comments.h"
// MIXPANEL
#import "Mixpanel/Mixpanel.h"


@interface PaprItemCell : UITableViewCell {
    
    BOOL cellShouldOpen;
    BOOL cellSliderIsOpen;
    BOOL cellSliderIsMoving;

}

// ALL
@property (nonatomic, strong) NSDictionary *cellDictionary;
@property (nonatomic, weak) IBOutlet UIView *viewSlider;
@property (nonatomic, weak) IBOutlet UIView *viewButtons;
@property (nonatomic, weak) IBOutlet UIButton *buComment;
@property (nonatomic, weak) IBOutlet UIButton *buRepost;
@property (nonatomic, weak) IBOutlet UIButton *buSave;
@property (nonatomic, weak) IBOutlet UILabel *labelText;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewPhoto;
// TEXT && FULL
@property (nonatomic, weak) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewMain;

// IBACTIONS METHODS
- (IBAction) buLikeActual;
- (IBAction) buSaveActual;
- (IBAction) buShareActual;
// DEPRECATED
- (IBAction) buRepostActual;
- (IBAction) buCommentActual;

// PUBLIC METHODS
- (void) resetCell;

@end

