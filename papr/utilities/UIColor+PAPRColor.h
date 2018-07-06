//
//  UIColor+PAPRColor.h
//  papr
//
//  Created by Brian WF Tobin on 8/16/17.
//  Copyright © 2017 Jebudas Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UICOLOR_RGB(R,G,B) [UIColor colorWithRed:(CGFloat)(R)/255.0f green:(CGFloat)(G)/255.0f blue:(CGFloat)(B)/255.0f alpha:1]

@interface UIColor (PAPRColor)

// v1.4
+ (UIColor *) paprCharcoal;

// v1.0
+ (UIColor *) paprBlack111;
+ (UIColor *) paprBlack222;
+ (UIColor *) paprBlack333;
+ (UIColor *) paprWhite250;

+ (UIColor *) paprBlackHero;
+ (UIColor *) paprBlackNormal;

+ (UIColor *) paprGreyVeryLight;
+ (UIColor *) paprGreyLight;

+ (UIColor *) paprBlue;
+ (UIColor *) paprPink;
+ (UIColor *) paprRed;

@end
