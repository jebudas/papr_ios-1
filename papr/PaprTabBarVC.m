//
//  PaprTabBarVC.m
//  papr
//
//  Created by Brian WF Tobin on 8/22/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprTabBarVC.h"

@interface PaprTabBarVC ()

@end

@implementation PaprTabBarVC

- (void)viewDidLoad {

    [super viewDidLoad];

}

#pragma mark - IBACTION && RELATED METHODS

- (void) turnOffAllButtons {
    
    [self.buPapr setBackgroundImage:[UIImage imageNamed:@"tab_papr_off.png"] forState:UIControlStateNormal];
    [self.buPlus setBackgroundImage:[UIImage imageNamed:@"tab_plus_off.png"] forState:UIControlStateNormal];
    [self.buPost setBackgroundImage:[UIImage imageNamed:@"tab_post_off.png"] forState:UIControlStateNormal];
    [self.buMore setBackgroundImage:[UIImage imageNamed:@"tab_more_off.png"] forState:UIControlStateNormal];
    
}
- (void) turnOnPapr {
    
    [self turnOffAllButtons];
    
    [self.buPapr setBackgroundImage:[UIImage imageNamed:@"tab_papr_on.png"] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.showPaprProgress" object:nil];

}
- (void) turnOnPlus {
    
    [self turnOffAllButtons];
    
    [self.buPlus setBackgroundImage:[UIImage imageNamed:@"tab_plus_on.png"] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hidePaprProgress" object:nil];

}
- (void) turnOnPost {
    
    [self turnOffAllButtons];
    
    [self.buPost setBackgroundImage:[UIImage imageNamed:@"tab_post_on.png"] forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hidePaprProgress" object:nil];

}
- (void) turnOnMore {
    
    [self turnOffAllButtons];
    
    [self.buMore setBackgroundImage:[UIImage imageNamed:@"tab_more_on.png"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.hidePaprProgress" object:nil];
    
}
- (IBAction) buPaprSelected : (id)sender {

    NSLog(@"buPaprSelected . [DataController dc].currentZone = %@", [DataController dc].currentZone);
    
    NSString *zone = [DataController dc].currentZone;
    
    if ([zone isEqualToString:@"papr"]) {
    
        [self turnOnPapr];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.scrollToFirstPapr" object:nil];
    
    } else if ([zone isEqualToString:@"create"]) {
        
        [self turnOnPapr];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRoot" object:nil];
        
    } else if ([zone isEqualToString:@"create_preview"]) {
        
        [self turnOnPapr];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRoot" object:nil];
        
    } else if ([zone isEqualToString:@"search"]) {
    
        [self turnOnPapr];
        
        if ([DataController dc].iUpdatedMySubscriberList) {
        
            // UPDATE ARRAY OF PAPRS
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.refreshPaprSubscriptions" object:nil];

            // GO TO PROPERPAPR
            
            // NOW RETURN HOME
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRoot" object:nil];

        } else {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRoot" object:nil];

        }

    
    }
    
}
- (IBAction) buPlusSelected : (id)sender {
    
    [self turnOnPlus];
    
    [DataController dc].currentZone = @"search";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprSearchVC" object:nil];
    
    [[Mixpanel sharedInstance] track: @"Search" properties: @{@"Status": @"Initiated"}];
    
}
- (IBAction) buPostSelected : (id)sender {
    
    NSLog(@"buPostSelected");
    
    NSString *zone = [DataController dc].currentZone;
    
    if ([zone isEqualToString:@"create_preview"]) {
        
        [self turnOnPost];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprPostPreviewVC.pushPaprPostCreateVC" object:nil];
        
    } else {
        
        [self turnOnPost];
        
        [DataController dc].currentZone = @"create";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.pushPaprPostPreviewVC" object:nil];
        
        [[Mixpanel sharedInstance] track: @"Papr . Create Post" properties: @{@"Status": @"Initiated"}];
        
    }
    
    
}
- (IBAction) buMoreSelected : (id)sender {
    
//    [self turnOnMore];
//    
//    [DataController dc].currentZone = @"more";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprMoreVC" object:nil];
    
    [[Mixpanel sharedInstance] track: @"More" properties: @{@"Status": @"Initiated"}];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
