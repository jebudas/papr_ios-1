//
//  PaprProgressVC.m
//  papr
//
//  Created by Brian WF Tobin on 11/21/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProgressVC.h"

@interface PaprProgressVC ()

@end

@implementation PaprProgressVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupNotifications];

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    frameBracketWidth = self.imageViewBracketLeft.frame.size.width;
    frameBracketHeight = self.imageViewBracketLeft.frame.size.height;

    [self setupProgressBar];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self updateProgressBar];   
    
    
}
- (void) setupNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgressBar) name:@"PaprProgressVC.updateProgressBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupProgressBrackets) name:@"PaprProgressVC.setupProgressBrackets" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PaprProgressVC.updateProgressBar" object:nil];
    
}

- (void) setupProgressBar {
    
    [self.viewProgressRed removeFromSuperview];
    self.viewProgressRed = nil;
    
    frameViewProgressRed = CGRectMake(self.viewProgress.frame.origin.x,
                                      0,
                                      0,
                                      self.viewProgress.frame.size.height);
    
    self.viewProgressRed = [[UIView alloc] initWithFrame:frameViewProgressRed];
    self.viewProgressRed.backgroundColor = [UIColor paprRed];
    [self.viewProgress addSubview:self.viewProgressRed];
    [self.viewProgress sendSubviewToBack:self.viewProgressRed];

}
- (void) setupProgressBrackets {

    int paprCounter;
    float paprCountTotal = [DataController dc].currentPaprCount + 2; // INCLUDES ACCOMPLISHMENT SCREEN
    float offsetX = (self.viewProgress.frame.size.width / paprCountTotal) - (frameBracketWidth/2);
    float offsetWidth = (self.viewProgress.frame.size.width / paprCountTotal);

    for (paprCounter = 1; paprCounter <= paprCountTotal; paprCounter++) {
    
        CGRect frameBracket = CGRectMake(offsetX, 0, frameBracketWidth, frameBracketHeight);

        [self addBracketWithFrame : frameBracket];
    
        offsetX += offsetWidth;
        
    }

}
- (void) updateProgressBar {

    float paprCountTotal = [DataController dc].currentPaprCount + 2; // INCLUDES ACCOMPLISHMENT SCREEN
    
    float width = (self.viewProgress.frame.size.width / (paprCountTotal) ) * ([DataController dc].currentPaprIndex + 1);
    
    self.viewProgressRed.frame = CGRectMake(self.viewProgress.frame.origin.x, 0, width, self.viewProgress.frame.size.height);

}
- (void) addBracketWithFrame : (CGRect)frameRCVD {

    UIImageView *bracket = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_bracket_center.png"] ];
    bracket.frame = frameRCVD;
    [self.viewProgress addSubview:bracket];
    [self.viewProgress bringSubviewToFront:bracket];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
