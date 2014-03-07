//
//  SMUCheckin.m
//  SetMeUp
//
//  Created by ArulRaj on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCheckin.h"

@implementation SMUCheckin
-(void)setCheckinsWithDict:(NSDictionary *)dictionary {
    _a_user_checkin_count = [[dictionary objectForKey:@"a_user_checkin_count"] integerValue];
    _c_user_checkin_count = [[dictionary objectForKey:@"c_user_checkin_count"] integerValue];
    _city = [dictionary objectForKey:@"city"];
    _country = [dictionary objectForKey:@"country"];
    _lattitude = [[dictionary objectForKey:@"latitude"] floatValue];
    _longitude = [[dictionary objectForKey:@"longitude"] floatValue];
    _placeId = [dictionary objectForKey:@"place_id"];
    _placeName =[dictionary objectForKey:@"place_name"];
    _placeUrl =[dictionary objectForKey:@"place_thumb_url"];
    _state = [dictionary objectForKey:@"state"];
    _street = [dictionary objectForKey:@"street"];
    _user_last_checkedin = [dictionary objectForKey:@"user_last_checked_in"];
    _user_last_checkedin_by =[dictionary objectForKey:@"user_last_checked_in_by"];
    _zip = [dictionary objectForKey:@"zip"];
    _checkinType = [dictionary objectForKey:@"checkin_type"];
}
@end
