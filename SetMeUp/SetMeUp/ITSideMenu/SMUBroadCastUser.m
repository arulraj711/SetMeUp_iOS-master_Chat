//
//  SMUBroadCastUser.m
//  SetMeUp
//
//  Created by ArulRaj on 2/10/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUBroadCastUser.h"

@implementation SMUBroadCastUser

-(void)setBroadCastDetails:(NSDictionary *)dictionary {
    _a_user_id = [dictionary objectForKey:@"a_user_id"];
    _created = [dictionary objectForKey:@"created"];
    _broadCastId = [dictionary objectForKey:@"id"];
    _message = [dictionary objectForKey:@"message"];
    _name = [dictionary objectForKey:@"name"];
    _imgUrl = [dictionary objectForKey:@"image_url"];
}

@end
