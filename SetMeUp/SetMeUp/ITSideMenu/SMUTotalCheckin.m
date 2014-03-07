//
//  SMUTotalCheckin.m
//  SetMeUp
//
//  Created by ArulRaj on 2/25/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUTotalCheckin.h"
#import "SMUCheckin.h"

@implementation SMUTotalCheckin
-(void)setFCConnUserWithDict:(NSDictionary *)dictionary {
   // _userId = [dictionary objectForKey:@"id"];
//    _firstname = [dictionary objectForKey:@"first_name"];
//    //_lastname = [dictionary objectForKey:@"last_name"];
//    _name = [dictionary objectForKey:@"name"];
//    _imageUrl = [dictionary objectForKey:@"profile_image_url"];
    //NSLog(@"one:%@",dictionary);
        NSArray *mostCheckinArray = [[dictionary objectForKey:@"checkins"] objectForKey:@"most_checkins"];
    //NSLog(@"two");
        NSMutableArray *userMostCheckin=[NSMutableArray array];
        if([mostCheckinArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dic in mostCheckinArray) {
                SMUCheckin *mostCheck=[[SMUCheckin alloc] init];
                [mostCheck setCheckinsWithDict:dic];
                [userMostCheckin addObject:mostCheck];
            }
        }
        _mostCheckins=[NSArray arrayWithArray:userMostCheckin];
    //NSLog(@"most checkins array:%@",_mostCheckins);
        NSArray *recentCheckinArray = [[dictionary objectForKey:@"checkins"]objectForKey:@"recent_checkins"];
        NSMutableArray *userrecentCheckin=[NSMutableArray array];
        if([recentCheckinArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dic in recentCheckinArray) {
                SMUCheckin *recentCheck=[[SMUCheckin alloc] init];
                [recentCheck setCheckinsWithDict:dic];
                [userrecentCheckin addObject:recentCheck];
            }
        }
        _recentCheckins=[NSArray arrayWithArray:userrecentCheckin];
}
@end
