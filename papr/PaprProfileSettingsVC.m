//
//  PaprProfileSettingsVC.m
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProfileSettingsVC.h"

@interface PaprProfileSettingsVC ()

@end

@implementation PaprProfileSettingsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.myUserDictionary = [[NSMutableDictionary alloc] initWithDictionary: [[DataController dc] returnMyUserDictionary] ];
    
    self.settingsDictionary = [[NSMutableDictionary alloc] initWithDictionary: [self.myUserDictionary objectForKey:@"user_settings"] ];
    
    NSLog(@"self.settingsDictionary = %@", self.settingsDictionary);
    NSLog(@"");

    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.width],
                                 [[DataController dc] returnRelativeSizeForThisScreen:(int)self.view.frame.size.height]);

    [self setupSwitches];

    [self setupLocation];

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void) setupSwitches {

    self.switchFont.tintColor = [UIColor paprRed];
    self.switchPrivate.tintColor = [UIColor paprRed];
    self.switchPush.tintColor = [UIColor paprRed];
    
    self.switchFont.on = [[self.settingsDictionary objectForKey:@"user_settings_font"] boolValue];
    self.switchPrivate.on = [[self.settingsDictionary objectForKey:@"user_settings_private"] boolValue];
    self.switchPush.on = [[self.settingsDictionary objectForKey:@"user_settings_push"] boolValue];

}
- (void) setupLocation {

    self.locationDictionary = [[NSMutableDictionary alloc] initWithDictionary: [self.myUserDictionary objectForKey:@"user_location"] ];
    
    self.labelLocation.text = [self.locationDictionary objectForKey:@"locality"];

}


#pragma mark - IBACTION METHODS

- (void) updateUser {

    // UPDATE
    [[DataController dc] updateUserDictionaryWithNewSettings:self.settingsDictionary];
    
    [DataController dc].userNeedsUpdate = TRUE;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PaprVC.updateUserFromPaprVC" object:nil];

    // UPDATE SERIF SETTING LOCALLY
    if (profileWasChangedForSerif) {

        NSDictionary *serifDictionary = @{@"key":@"edition_is_serif", @"value":[self.settingsDictionary objectForKey:@"user_settings_font"]};
        
        [[DataController dc] updatePaprHeaderDictionaryWithKeyValue:serifDictionary];
    
    }
    
    
}
- (IBAction) buDoneSelected : (id)sender {

    if (profileWasChanged) {

        [self updateUser];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprProfileSettingsVC" object:nil];

    } else {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprProfileSettingsVC" object:nil];

    }

}
- (IBAction) buEditSelected : (id)sender {

    if (profileWasChanged) {
        
        [self updateUser];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileEditVC" object:nil];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.addPaprProfileEditVC" object:nil];
        
    }

}
- (IBAction) buLocationSelected : (id)sender {
    //
}

- (IBAction) switchPushNotificationsChanged : (UISwitch *) sender {
    
    profileWasChanged = TRUE;
    
    if ([sender isOn]) {
        NSLog(@"ON");
        [self.settingsDictionary setObject:@"1" forKey:@"user_settings_push"];
    } else {
        NSLog(@"OFF");
        [self.settingsDictionary setObject:@"0" forKey:@"user_settings_push"];
    }

}
- (IBAction) switchFontChanged : (UISwitch *) sender {

    profileWasChanged = TRUE;
    profileWasChangedForSerif = TRUE;
    
    if ([sender isOn]) {
        NSLog(@"ON");
        [self.settingsDictionary setObject:@"1" forKey:@"user_settings_font"];
    } else {
        NSLog(@"OFF");
        [self.settingsDictionary setObject:@"0" forKey:@"user_settings_font"];
    }

}
- (IBAction) switchPrivacyChanged : (UISwitch *) sender {

    profileWasChanged = TRUE;
    
    if ([sender isOn]) {
        NSLog(@"ON");
        [self.settingsDictionary setObject:@"1" forKey:@"user_settings_private"];
    } else {
        NSLog(@"OFF");
        [self.settingsDictionary setObject:@"0" forKey:@"user_settings_private"];
    }

}
- (IBAction) buPrivacySelected : (id)sender {
    // URL
}
- (IBAction) buTermsSelected : (id)sender {
    // URL
}
- (IBAction) buReportSelected : (id)sender {
    // v1.1
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
