//
//  SMULetsMeet.h
//  SetMeUp
//
//  Created by ArulRaj on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMULetsMeet : NSObject
@property (nonatomic,strong) NSArray *calendarDateArray;
@property (nonatomic,strong) NSArray *placeDetailsArray;
-(void)setLetsMeetWithDict:(NSDictionary *)dictionary;
@end
