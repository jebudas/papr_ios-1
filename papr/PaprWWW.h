//
//  PaprWWW.h
//  papr
//
//  Created by Brian WF Tobin on 9/4/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface PaprWWW : UIViewController <WKUIDelegate> {
    //
}

@property (nonatomic, strong) NSString *thisURL;
@property (nonatomic, weak) IBOutlet UIView *viewWK;
@property (nonatomic, weak) IBOutlet UIWebView *webViewPost;


@end
