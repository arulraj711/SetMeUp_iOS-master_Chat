//
//  SMUtils.m
//  SetMeUp
//
//  Created by Go on 14/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUtils.h"

@implementation SMUtils

+(UIColor*)getRandomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 )+ 0.2;  // 0.2 to 1.0, near to black
    CGFloat brightness = ( arc4random() % 128 / 256.0 )+ 0.5;  // 0.5 to 1.0, near to white
    if (saturation > .6)
        saturation = .6;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

+(void)makeRoundedImageView:(UIImageView*)imageView withBorderColor:(UIColor*)color
{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 2.0;
    if (color)
        imageView.layer.borderColor = [color CGColor];
    else
        imageView.layer.borderColor = [appDefaultUserUIColor CGColor];
}

+(void)makeRoundedView:(UIView*)view
{
    view.layer.cornerRadius = view.frame.size.width /2;
    view.layer.masksToBounds = YES;
 }

+(UIImage *)getColoredImage:(UIImage*)image WithColor:(UIColor *)color;
{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(image.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredimage;
}

+(UIImage *)getColoredImageWithName:(NSString*)imageName WithColor:(UIColor *)color;
{
    UIImage *image=[UIImage imageNamed:imageName];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(image.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredimage;
}
+(NSString*)getFullNameWithFirstName:(NSString*)firstName withLastName:(NSString*)lastName;
{
    return [self getFullNameWithFirstName:firstName withMiddleName:nil withLastName:lastName];
}

+(NSString*)getFullNameWithFirstName:(NSString*)firstName withMiddleName:(NSString*)middleName withLastName:(NSString*)lastName;
{
    NSMutableString *fullName=[NSMutableString stringWithString:firstName];
    if ([fullName length]) {
        [fullName appendString:@" "];
    }
    if ([middleName length]) {
        [fullName appendString:middleName];
    }
    if ([fullName length]) {
        [fullName appendString:@" "];
    }
    if ([lastName length]) {
        [fullName appendString:lastName];
    }
    [fullName replaceOccurrencesOfString:@"  " withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, fullName.length)];
    return fullName;
}

@end
