//
//  SMUConnectedUser.m
//  SetMeUp
//
//  Created by ArulRaj on 1/2/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUConnectedUser.h"

@implementation SMUConnectedUser
-(void)setConnectedUserWithDict:(NSDictionary *)dictionary {
    _user_id = [dictionary objectForKey:@"id"];
    //_img_exist = [[dictionary objectForKey:@"img_exist"] intValue];
    _name = [dictionary objectForKey:@"name"];
    _recentMsg = [dictionary objectForKey:@"message"];
    _b_user_connected_date=[dictionary objectForKey:@"b_user_connected_date"];
       _b_user_id=[dictionary objectForKey:@"b_user_id"];
        _b_user_image_url=[dictionary objectForKey:@"b_user_image_url"];
        _b_user_name=[dictionary objectForKey:@"b_user_name"];
    _msgCount = [[dictionary objectForKey:@"new_msg_count"] intValue];
}
@end
