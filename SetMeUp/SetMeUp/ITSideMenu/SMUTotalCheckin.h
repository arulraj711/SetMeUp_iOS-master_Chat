//
//  SMUTotalCheckin.h
//  SetMeUp
//
//  Created by ArulRaj on 2/25/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUTotalCheckin : NSObject
@property (nonatomic,strong) NSArray *mostCheckins;
@property (nonatomic,strong) NSArray *recentCheckins;
-(void)setFCConnUserWithDict:(NSDictionary *)dictionary;

@end
