//
//  PaprPostSignupVC.h
//  papr
//
//  Created by Brian WF Tobin on 4/19/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController+User.h"


@interface PaprPostSignupVC : UIViewController <UITextViewDelegate> {
    
    int currentInviteProgress;
    
}

// IBOUTLET
@property (nonatomic, weak) IBOutlet UIView *viewHello;
@property (nonatomic, weak) IBOutlet UIView *viewTellus;
@property (nonatomic, weak) IBOutlet UIView *viewThanks;
@property (nonatomic, weak) IBOutlet UIView *viewPatience;
@property (nonatomic, weak) IBOutlet UITextView *textViewTellus;
@property (nonatomic, weak) IBOutlet UITextView *textViewTellusFakie;

@property (nonatomic, weak) IBOutlet UIButton *buBio;
@property (nonatomic, weak) IBOutlet UIButton *buRequest;


@end
