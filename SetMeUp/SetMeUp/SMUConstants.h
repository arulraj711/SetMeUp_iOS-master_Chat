//
//  SMUConstants.h
//  SetMeUp
//
//  Created by Go on 12/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SMUtils.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define appBaseTintUIColor [UIColor whiteColor]
#define appBarTextUIColor [UIColor whiteColor]
#define appOnlineUserUIColor UIColorFromRGB(0xe4625b)
#define appOfflineUserUIColor [UIColor lightGrayColor]
#define appDefaultUserUIColor [UIColor whiteColor]
#define appCommonItemsUIColor UIColorFromRGB(0x7ce27c)
#define letmeetBorderUIColor UIColorFromRGB(0xcec5aa)
#define appBackGrondUIColor UIColorFromRGB(0x2b2836)
#define selectedQuipUIColor UIColorFromRGB(0x7d7d7d)