//
//  SMUPlaceDetails.m
//  SetMeUp
//
//  Created by ArulRaj on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUPlaceDetails.h"

@implementation SMUPlaceDetails
-(void)setPlaceDetailsWithDict:(NSDictionary *)dictionary {
    _a_user_checkin_count = [[dictionary objectForKey:@"a_user_checkin_count"] intValue];
    _a_user_last_checked_in = [dictionary objectForKey:@"a_user_last_checked_in"];
    _c_user_checkin_count = [[dictionary objectForKey:@"c_user_checkin_count"] intValue];
    _c_user_last_checked_in = [dictionary objectForKey:@"c_user_last_checked_in"];
    _checkin_date = [dictionary objectForKey:@"checkin_date"];
    _city = [dictionary objectForKey:@"city"];
    _country = [dictionary objectForKey:@"country"];
    _lattitude = [[dictionary objectForKey:@"lat"] floatValue];
    _longitude = [[dictionary objectForKey:@"lon"] floatValue];
    _place_id =[dictionary objectForKey:@"place_id"];
    _place_name = [dictionary objectForKey:@"place_name"];
    _place_thumb_url = [dictionary objectForKey:@"place_url"];
    _state = [dictionary objectForKey:@"state"];
    _street = [dictionary objectForKey:@"street"];
    _user_last_checked_in_by =[dictionary objectForKey:@"user_last_checked_in_by"];
}
@end
