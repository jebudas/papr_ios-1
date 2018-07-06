//
//  PaprWWW.m
//  papr
//
//  Created by Brian WF Tobin on 9/4/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "PaprWWW.h"

@interface PaprWWW ()

@end

@implementation PaprWWW

- (void)viewDidLoad {

    [super viewDidLoad];
    
    /*
     KILL CACHE
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
     [[NSURLCache sharedURLCache] setDiskCapacity:0];
     [[NSURLCache sharedURLCache] setMemoryCapacity:0];
     OR
     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval: 10.0];
     */
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setupWebView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    // [self.spinner stopAnimating];
    
}

#pragma mark - WKWEBVIEW METHODS

- (void) setupWebView {

    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.viewWK.frame configuration:theConfiguration];
    
    webView.navigationDelegate = self;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:self.thisURL] ];

    [webView loadRequest:urlRequest];
    
    [self.view addSubview:webView];
    
}

#pragma mark - IBACTION METHODS

- (IBAction) buBackSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.removePaprWWW" object:nil];
    
}
- (IBAction) buPlusSelected : (id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RootVC.popToRoot" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
