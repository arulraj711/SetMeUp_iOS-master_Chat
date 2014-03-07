//
//  SMUFCConnectedUser.m
//  SetMeUp
//
//  Created by ArulRaj on 1/22/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUFCConnectedUser.h"
#import "SMUCheckin.h"

@implementation SMUFCConnectedUser

-(void)setFCConnUserWithDict:(NSDictionary *)dictionary {
    _userId = [dictionary objectForKey:@"id"];
    _firstname = [dictionary objectForKey:@"first_name"];
    //_lastname = [dictionary objectForKey:@"last_name"];
    _name = [dictionary objectForKey:@"name"];
    _imageUrl = [dictionary objectForKey:@"profile_image_url"];
    
//    NSArray *mostCheckinArray = [dictionary objectForKey:@"most_checkins"];
//    NSMutableArray *userMostCheckin=[NSMutableArray array];
//    if([mostCheckinArray isKindOfClass:[NSArray class]])
//    {
//        for (NSDictionary *dic in mostCheckinArray) {
//            SMUCheckin *mostCheck=[[SMUCheckin alloc] init];
//            [mostCheck setCheckinsWithDict:dic];
//            [userMostCheckin addObject:mostCheck];
//        }
//    }
//    _mostCheckins=[NSArray arrayWithArray:userMostCheckin];
//    
//    NSArray *recentCheckinArray = [dictionary objectForKey:@"recent_checkins"];
//    NSMutableArray *userrecentCheckin=[NSMutableArray array];
//    if([recentCheckinArray isKindOfClass:[NSArray class]])
//    {
//        for (NSDictionary *dic in recentCheckinArray) {
//            SMUCheckin *recentCheck=[[SMUCheckin alloc] init];
//            [recentCheck setCheckinsWithDict:dic];
//            [userrecentCheckin addObject:recentCheck];
//        }
//    }
//    _recentCheckins=[NSArray arrayWithArray:userrecentCheckin];
}

@end
