//
//  UIView+Blur.m
//  SMUReco
//
//  Created by In on 17/01/14.
//  Copyright (c) 2014 Indi. All rights reserved.
//

#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"

@interface UIView (SymbolNotPublicInSeed1)
// This method was implemented in seed 1 but the symbol was not made public. It will be public in seed 2.
- (BOOL)drawViewHierarchyInRect:(CGRect)rect;
@end

@implementation UIView(Blur)
#pragma mark - Blur Effect

- (UIImage *)blurredBackgroundImageWithBackgroundView:(UIView *)backgroundView
{
    CGRect buttonRectInBGViewCoords = [self convertRect:self.bounds toView:backgroundView];
    //NSLog(@"buttonRectInBGViewCoords :%@",NSStringFromCGRect(buttonRectInBGViewCoords));
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[[self window] screen] scale]);
    /*
     Note that in seed 1, drawViewHierarchyInRect: does not function correctly. This has been fixed in seed 2. Seed 1 users will have empty images returned to them.
     */
    [backgroundView drawViewHierarchyInRect:CGRectMake(-buttonRectInBGViewCoords.origin.x, -buttonRectInBGViewCoords.origin.y, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame))];
    UIImage *newBGImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSData *imageData = UIImageJPEGRepresentation(newBGImage, 0.01);
//    UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:0.5];

    
    self.layer.masksToBounds = YES;
   // NSLog(@"newBGImage :%@",newBGImage);
    return newBGImage;
}

@end
