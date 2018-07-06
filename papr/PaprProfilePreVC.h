//
//  PaprProfilePreVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"


@interface PaprProfilePreVC : UIViewController <UIGestureRecognizerDelegate> {
    
    CGRect frameOptionsIN;
    CGRect frameOptionsOUT;
    CGRect frameOptionsIN_02;
    CGRect frameOptionsOUT_02;

}


@property (nonatomic, strong) NSDictionary *thisPaprDictionary;
@property (nonatomic, weak) IBOutlet UIView *viewBG;
@property (nonatomic, weak) IBOutlet UIView *viewOptions;
@property (nonatomic, weak) IBOutlet UIView *viewOptions02;


@end
