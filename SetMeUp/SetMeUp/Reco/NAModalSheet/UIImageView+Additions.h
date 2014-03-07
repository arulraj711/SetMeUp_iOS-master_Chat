//
//  UIImageView+Additions.h
//  SMUReco
//
//  Created by In on 18/01/14.
//  Copyright (c) 2014 Indi. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface UIImageView(Additions)
//- (void)drawBorderColor:(UIColor *)borderColor borderWidth:(float)borderWidth;
//- (void)drawBorder;
//@end
@interface UIView(Additions)
- (void)drawBorderColor:(UIColor *)borderColor borderWidth:(float)borderWidth;
- (void)drawBorderColor:(UIColor *)borderColor;
- (void)drawBorder;
@end
