//
//  PaprAccomplishmentVC.h
//  papr
//
//  Created by Brian WF Tobin on 10/18/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"

@interface PaprAccomplishmentVC : UIViewController {
    
    CGRect framePushSliderORIG;

}

@property (nonatomic, weak) IBOutlet UIView *viewPush;
@property (nonatomic, weak) IBOutlet UIView *viewPushSlider;
@property (nonatomic, weak) IBOutlet UILabel *labelSettings;

@end
