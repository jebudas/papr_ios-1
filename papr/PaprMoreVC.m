//
//  PaprMoreVC.m
//  papr
//
//  Created by Brian WF Tobin on 12/19/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprMoreVC.h"
#import "APIController+User.h"

@interface PaprMoreVC ()

@end

@implementation PaprMoreVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self setupBlur];
    
    [self setupLabels];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
//    UIImageView *test = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"papr_more_menu.png"] ];
//    [self.view addSubview:test];
    
}
- (void) setupBlur {

    //only apply the blur if the user hasn't disabled transparency effects
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
        
        [self.view bringSubviewToFront:self.buExit];
        [self.view bringSubviewToFront:self.viewMenu];
        [self.view bringSubviewToFront:self.viewButtons];
        
    } else {
        
        self.view.backgroundColor = [UIColor blackColor];
        
    }

}
- (void) setupLabels {

    // UPDATE FOLLOWING
    NSArray *arrayOfSubscriptions = [[DataController dc] returnUserSubscriptions];
    NSString *titleFollowing = [NSString stringWithFormat:@"Following (%i)", (int)arrayOfSubscriptions.count];
    [self.buFollowing setTitle:titleFollowing forState:UIControlStateNormal];
    
    // UPDATE FOLLOWERS
    NSDictionary *idDictionary = @{@"publisher_id" : [[DataController dc] returnMyUserID]};
    [[APIController api] getMyFollowers:idDictionary success:^(NSDictionary *responseDictionary) {

        NSLog(@"PaprMoreVC . getMyFollowers . responseDictionary = %@", responseDictionary);
        
        self.arrayOfMyFollowers = [[NSArray alloc] initWithArray: [[responseDictionary objectForKey:@"item_dictionary"] objectForKey:@"SUBSCRIBERS"] ];

        NSString *titleFollowers = [NSString stringWithFormat:@"Followers (%i)", (int)self.arrayOfMyFollowers.count];
        [self.buFollowers setTitle:titleFollowers forState:UIControlStateNormal];

        NSLog(@"");
        
    } failure:^(NSError *error) {
        
        NSLog(@"PaprMoreVC . getMyFollowers . error = %@", error);
        
    }];

}

#pragma mark - IBACTION METHODS

- (IBAction) buProfileSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprMoreVC" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileForUser" object:nil];
    
}
- (IBAction) buSavedSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprMoreVC" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprSavedPostsVC" object:nil];
    
}
- (IBAction) buFollowingSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprMoreVC" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileFollowingVC" object:nil];
    
}
- (IBAction) buFollowersSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprMoreVC" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileFollowersVC" object:nil];
    
}
- (IBAction) buNotificationsSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprMoreVC" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprUserNotificationsVC" object:nil];
    
}
- (IBAction) buExitSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprMoreVC" object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
