//
//  UserDetails.m
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "UserDetails.h"

@implementation UserDetails


+ (UserDetails *)userdetailsFromDictionary:(NSDictionary *)dictionary
{
    UserDetails *user    =   [[UserDetails alloc]init];
    NSDictionary *profileInfo=[dictionary objectForKey:@"profile_info"];
    user.fcStatus=[dictionary objectForKey:@"FC_Status"];
    user.name   =   [profileInfo objectForKey:@"name"];
    user.userID =   [profileInfo objectForKey:@"user_id"];
    user.picID  =   [profileInfo objectForKey:@"profile_pic_id"];
    user.userDob  =   [profileInfo objectForKey:@"udob"];
    user.userEducation  =   [profileInfo objectForKey:@"ueducation"];
    user.userLocation   =   [profileInfo objectForKey:@"ulocation"];
    user.userWorkplace  =   [profileInfo objectForKey:@"uworkplace"];
    user.approveInfo=[dictionary objectForKey:@"approveInfo"];
    return user;
}


@end