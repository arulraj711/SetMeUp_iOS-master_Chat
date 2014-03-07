//
//  SMUConnectUser.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/8/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUConnectUser.h"

@implementation SMUConnectUser
-(void)setConnectedDetailsWithDict:(NSDictionary *)dictionary{
    _name=[dictionary objectForKey:@"name"];
    _profilePicture=[dictionary objectForKey:@"profile_thumb"];
    _userID=[dictionary objectForKey:@"id"];
}
@end
