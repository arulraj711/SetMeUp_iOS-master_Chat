//
//  ITSideMenuShadow.h
//  ITSideMenuDemoSearchBar
//
//  Created by Go on 12/11/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITSideMenuShadow : NSObject

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat opacity;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) UIView *shadowedView;

+ (ITSideMenuShadow *)shadowWithView:(UIView *)shadowedView;
+ (ITSideMenuShadow *)shadowWithColor:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity;

- (void)draw;
- (void)shadowedViewWillRotate;
- (void)shadowedViewDidRotate;

@end
