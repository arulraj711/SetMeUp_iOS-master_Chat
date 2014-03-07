//
//  UIImageView+Additions.m
//  SMUReco
//
//  Created by In on 18/01/14.
//  Copyright (c) 2014 Indi. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIView(Additions)
- (void)drawBorderColor:(UIColor *)borderColor borderWidth:(float)borderWidth
{
    [self.layer setBorderColor: [borderColor CGColor]];
    [self.layer setBorderWidth: borderWidth];
}
- (void)drawBorderColor:(UIColor *)borderColor
{
    [self drawBorderColor:borderColor borderWidth:1.0];
}

- (void)drawBorder
{
    [self drawBorderColor:[UIColor whiteColor] borderWidth:1.0];
}
@end
