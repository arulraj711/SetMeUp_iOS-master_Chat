//
//  SMUInvite.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/5/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUInvite.h"

@implementation SMUInvite

-(void)setNonsmuUserWithDict:(NSDictionary *)dictionary{
    
    _b_user_id=[dictionary objectForKey:@"b_user_id"];
    _b_user_imgurl=[dictionary objectForKey:@"b_user_imgurl"];
    _b_user_name=[dictionary objectForKey:@"b_user_name"];
    _c_user_id=[dictionary objectForKey:@"c_user_id"];
    _c_user_imgurl=[dictionary objectForKey:@"c_user_imgurl"];
    _c_user_name=[dictionary objectForKey:@"c_user_name"];
        _messageTemplate=[dictionary objectForKey:@"messageTemplate"];
    
}

@end
