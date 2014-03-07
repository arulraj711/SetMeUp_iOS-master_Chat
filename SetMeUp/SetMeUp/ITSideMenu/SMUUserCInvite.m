//
//  SMUUserCInvite.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUUserCInvite.h"

@implementation SMUUserCInvite
-(void)setNonsmuUserWithDict:(NSDictionary *)dictionary{
    
    _a_user_id=[dictionary objectForKey:@"user_a_id"];
    _a_user_imgurl=[dictionary objectForKey:@"user_a_imgurl"];
    _a_user_name=[dictionary objectForKey:@"user_a_name"];
    _c_user_id=[dictionary objectForKey:@"user_c_id"];
    _c_user_imgurl=[dictionary objectForKey:@"user_c_imgurl"];
    _c_user_name=[dictionary objectForKey:@"c_user_name"];
    _messageTemplate=[dictionary objectForKey:@"messageTemplate"];
    
}
@end
