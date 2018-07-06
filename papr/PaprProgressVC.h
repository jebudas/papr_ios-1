//
//  PaprProgressVC.h
//  papr
//
//  Created by Brian WF Tobin on 11/21/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "UIColor+PAPRColor.h"


@interface PaprProgressVC : UIViewController {

    float frameBracketWidth;
    float frameBracketHeight;
    
    CGRect frameViewProgressRed;
    
}

@property (nonatomic, weak) IBOutlet UIView *viewProgress;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewBracketLeft;

@property (nonatomic, strong) UIView *viewProgressRed;

@end
