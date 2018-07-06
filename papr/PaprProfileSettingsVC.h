//
//  PaprProfileSettingsVC.h
//  papr
//
//  Created by Brian WF Tobin on 9/2/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "UIColor+PAPRColor.h"
#import "UIImageView+AFNetworking.h"


@interface PaprProfileSettingsVC : UIViewController {

    BOOL profileWasChanged;
    BOOL profileWasChangedForSerif;

}

@property (nonatomic, strong) NSMutableDictionary *myUserDictionary;
@property (nonatomic, strong) NSMutableDictionary *settingsDictionary;
@property (nonatomic, strong) NSMutableDictionary *locationDictionary;
@property (nonatomic, weak) IBOutlet UILabel *labelLocation;
@property (nonatomic, weak) IBOutlet UISwitch *switchFont;
@property (nonatomic, weak) IBOutlet UISwitch *switchPrivate;
@property (nonatomic, weak) IBOutlet UISwitch *switchPush;

@end
