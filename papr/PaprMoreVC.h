//
//  PaprMoreVC.h
//  papr
//
//  Created by Brian WF Tobin on 12/19/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "APIController+User.h"


@interface PaprMoreVC : UIViewController {

    //
    
}


@property (nonatomic, strong) NSArray *arrayOfMyFollowers;
@property (nonatomic, weak) IBOutlet UIButton *buExit;
@property (nonatomic, weak) IBOutlet UIView *viewMenu;
@property (nonatomic, weak) IBOutlet UIView *viewButtons;
@property (nonatomic, weak) IBOutlet UIButton *buFollowers;
@property (nonatomic, weak) IBOutlet UIButton *buFollowing;

@end
