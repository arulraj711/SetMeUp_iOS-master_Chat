//
//  ITSideMenuShadow.m
//  ITSideMenuDemoSearchBar
//
//  Created by Go on 12/11/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "ITSideMenuShadow.h"
#import <QuartzCore/QuartzCore.h>

@implementation ITSideMenuShadow

@synthesize color = _color;
@synthesize opacity = _opacity;
@synthesize radius = _radius;
@synthesize enabled = _enabled;
@synthesize shadowedView;

+ (ITSideMenuShadow *)shadowWithView:(UIView *)shadowedView {
    ITSideMenuShadow *shadow = [ITSideMenuShadow shadowWithColor:[UIColor blackColor] radius:10.0f opacity:0.75f];
    shadow.shadowedView = shadowedView;
    return shadow;
}

+ (ITSideMenuShadow *)shadowWithColor:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity {
    ITSideMenuShadow *shadow = [ITSideMenuShadow new];
    shadow.color = color;
    shadow.radius = radius;
    shadow.opacity = opacity;
    return shadow;
}

- (id)init {
    self = [super init];
    if(self) {
        self.color = [UIColor blackColor];
        self.opacity = 0.75f;
        self.radius = 10.0f;
        self.enabled = YES;
    }
    return self;
}


#pragma mark -
#pragma mark - Property Setters

- (void)setEnabled:(BOOL)shadowEnabled {
    _enabled = shadowEnabled;
    [self draw];
}

- (void)setRadius:(CGFloat)shadowRadius {
    _radius = shadowRadius;
    [self draw];
}

- (void)setColor:(UIColor *)shadowColor {
    _color = shadowColor;
    [self draw];
}

- (void)setOpacity:(CGFloat)shadowOpacity {
    _opacity = shadowOpacity;
    [self draw];
}


#pragma mark -
#pragma mark - Drawing

- (void)draw {
    if(_enabled) {
        [self show];
    } else {
        [self hide];
    }
}

- (void)show {
    CGRect pathRect = self.shadowedView.bounds;
    pathRect.size = self.shadowedView.frame.size;
    self.shadowedView.layer.shadowPath = [UIBezierPath bezierPathWithRect:pathRect].CGPath;
    self.shadowedView.layer.shadowOpacity = self.opacity;
    self.shadowedView.layer.shadowRadius = self.radius;
    self.shadowedView.layer.shadowColor = [self.color CGColor];
    self.shadowedView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)hide {
    self.shadowedView.layer.shadowOpacity = 0.0f;
    self.shadowedView.layer.shadowRadius = 0.0f;
}


#pragma mark -
#pragma mark - ShadowedView Rotation

- (void)shadowedViewWillRotate {
    self.shadowedView.layer.shadowPath = nil;
    self.shadowedView.layer.shouldRasterize = YES;
}

- (void)shadowedViewDidRotate {
    [self draw];
    self.shadowedView.layer.shouldRasterize = NO;
}

@end
