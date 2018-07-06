//
//  UIColor+PAPRColor.m
//  papr
//
//  Created by Brian WF Tobin on 8/16/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import "UIColor+PAPRColor.h"
//#import "UIColor+fromHex.h"

@implementation UIColor (PAPRColor)

// v1.4 COLOURS
+ (UIColor *) paprCharcoal {
    return UICOLOR_RGB(28, 28, 28);
}
+ (UIColor *) paprBlack111 {
    return UICOLOR_RGB(17, 17, 17);
}
+ (UIColor *) paprBlack222 {
    return UICOLOR_RGB(34, 34, 34);
}
+ (UIColor *) paprBlack333 {
    return UICOLOR_RGB(51, 51, 51);
}
+ (UIColor *) paprWhite250 {
    return UICOLOR_RGB(250, 250, 250);
}


// BEFORE
+ (UIColor *) paprBlackHero {
    return UICOLOR_RGB(17, 17, 17);
}
+ (UIColor *) paprBlackNormal {
    return UICOLOR_RGB(51, 51, 51);
}
+ (UIColor *) paprGreyVeryLight {
    return UICOLOR_RGB(226, 226, 226);
}
+ (UIColor *) paprGreyLight {
    return UICOLOR_RGB(211, 211, 211);
}
+ (UIColor *) paprBlue {
    return UICOLOR_RGB(0, 122, 255);
}
+ (UIColor *) paprPink {
    return UICOLOR_RGB(252, 233, 233);
}
+ (UIColor *) paprRed {
    return UICOLOR_RGB(255, 40, 81);
}



@end
