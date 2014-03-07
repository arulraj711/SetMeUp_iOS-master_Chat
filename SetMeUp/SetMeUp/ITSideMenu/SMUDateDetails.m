//
//  SMUDateDetails.m
//  SetMeUp
//
//  Created by ArulRaj on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUDateDetails.h"

@implementation SMUDateDetails
-(void)setDateDetailsWithDict:(NSDictionary *)dictionary {
    _date_time = [dictionary objectForKey:@"date_time"];
    _from_first_name = [dictionary objectForKey:@"from_first_name"];
    _from_message = [dictionary objectForKey:@"from_message"];
    _from_msg_id = [dictionary objectForKey:@"from_msg_id"];
    _location_id = [dictionary objectForKey:@"location_id"];
    _status = [dictionary objectForKey:@"status"];
    _type = [dictionary objectForKey:@"type"];
    _dateId = [dictionary objectForKey:@"id"];
    _checkinType = [dictionary objectForKey:@"checkin_type"];
}
@end
