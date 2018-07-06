//
//  PaprProfilesVC.m
//  papr
//
//  Created by Brian WF Tobin on 4/5/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprProfilesVC.h"

@interface PaprProfilesVC ()

@end

@implementation PaprProfilesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBACTION & RELATED BUTTONS

- (IBAction) buExitSelected : (id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
