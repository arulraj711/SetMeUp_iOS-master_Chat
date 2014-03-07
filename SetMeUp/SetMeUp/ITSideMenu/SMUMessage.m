//
//  SMUMessage.m
//  SetMeUp
//
//  Created by ArulRaj on 1/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUMessage.h"

@implementation SMUMessage
-(void)setMessageWithDict:(NSDictionary *)dictionary {
    // NSDictionary *messageDic = [dictionary objectForKey:@"messages"];
    //_from_user_img_exist = [dictionary objectForKey:@"from_user_img_exist"];
    _from_user_name = [dictionary objectForKey:@"from_user_name"];
    _created = [dictionary objectForKey:@"created"];
    _from_user_id = [dictionary objectForKey:@"from_user_id"];
    _msgId = [dictionary objectForKey:@"message_id"];
    _message = [dictionary objectForKey:@"message"];
    _modified = [dictionary objectForKey:@"modified"];
    _status = [dictionary objectForKey:@"status"];
    _to_user_id = [dictionary objectForKey:@"to_user_id"];
    //_to_user_img_exist = [dictionary objectForKey:@"to_user_img_exist"];
    _to_user_name = [dictionary objectForKey:@"to_user_name"];
    
}
@end
