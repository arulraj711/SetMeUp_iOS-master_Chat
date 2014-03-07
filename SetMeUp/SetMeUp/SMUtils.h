//
//  SMUtils.h
//  SetMeUp
//
//  Created by Go on 14/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//
//  Commit check

#import <Foundation/Foundation.h>

@interface SMUtils : NSObject

+(UIColor*)getRandomColor;
+(void)makeRoundedView:(UIView*)view;
+(void)makeRoundedImageView:(UIImageView*)imageView withBorderColor:(UIColor*)color;
+(UIImage *)getColoredImage:(UIImage*)image WithColor:(UIColor *)color;
+(UIImage *)getColoredImageWithName:(NSString*)imageName WithColor:(UIColor *)color;
+(NSString*)getFullNameWithFirstName:(NSString*)firstName withLastName:(NSString*)lastName;
+(NSString*)getFullNameWithFirstName:(NSString*)firstName withMiddleName:(NSString*)middleName withLastName:(NSString*)lastName;
@end
