//
//  UIImage+BoxBlur.h
//
//  Created by Ken Worley on 11/22/13.
//


#import <UIKit/UIKit.h>

@interface UIImage (BoxBlur)

// Return a blurred copy of this image
// blurAmount - 0.0 min to 1.0 max
- (UIImage*)blurredImage:(CGFloat)blurAmount;
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

/* blur the current image with a box blur algoritm and tint with a color */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;
@end
