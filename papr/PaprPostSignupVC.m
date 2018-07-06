//
//  PaprPostSignupVC.m
//  papr
//
//  Created by Brian WF Tobin on 4/19/18.
//  Copyright © 2018 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprPostSignupVC.h"

@interface PaprPostSignupVC ()

@end

@implementation PaprPostSignupVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"iHaveSubmittedPostRequest"] ) {

        [self hideAllViews];

        self.viewPatience.alpha = 1.0;

    } else {

        [self hideAllViews];

        self.viewHello.alpha = 1.0;

        // ROUNDED CORNER
        self.buBio.layer.masksToBounds = YES;
        self.buBio.layer.cornerRadius = 5;
        self.buRequest.layer.masksToBounds = YES;
        self.buRequest.layer.cornerRadius = 5;

    }

}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    currentInviteProgress = 0;
    
}
- (void) hideAllViews {
    
    self.viewHello.alpha = 0.0;
    self.viewTellus.alpha = 0.0;
    self.viewThanks.alpha = 0.0;
    self.viewPatience.alpha = 0.0;

}


#pragma mark - UITEXTVIEW METHODS

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"textViewDidBeginEditing");

}
- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.textViewTellus.text.length > 0) {
        self.textViewTellusFakie.alpha = 0.0;
    } else {
        self.textViewTellusFakie.alpha = 1.0;
    }

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;

}
#pragma mark - IBACTION METHODS

- (IBAction) buBioSelected : (id)sender {
    
    [self hideAllViews];
    
    self.viewTellus.alpha = 1.0;
    self.textViewTellus.textColor = [UIColor darkGrayColor];
    self.textViewTellusFakie.text = @"leave us a brief bio which \nincludes links to your URL or\nsocial media accounts.";
    self.textViewTellusFakie.textColor = [UIColor lightGrayColor];
    
    [self.textViewTellus resignFirstResponder];
    [self.textViewTellus performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];
    
}
- (IBAction) buRequestSelected : (id)sender {
    
    if (self.textViewTellus.text.length < 7) {
        // TOO SHORT!!
        return;
    } else if (self.textViewTellus.text.length > 665) {
        // TOO LONG!!!
        return;
    }

    NSDictionary *requestDictionary = @{@"publisher_id" : [[DataController dc] returnMyUserID],
                                        @"request_text" : self.textViewTellus.text};

    [[APIController api] requestPublisherAbility:requestDictionary success:^(NSDictionary *responseDictionary) {
        
        NSLog(@"buRequestSelected . success = %@", responseDictionary);

        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"iHaveSubmittedPostRequest"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self hideAllViews];
        
        self.viewThanks.alpha = 1.0;
        
        [self.textViewTellus resignFirstResponder];
        
    } failure:^(NSError *error) {
        
        NSLog(@"buRequestSelected . error = %@", error);
        
    }];

}
- (IBAction) buXSelected : (id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
