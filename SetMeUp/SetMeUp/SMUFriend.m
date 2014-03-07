//
//  SMUFriend.m
//  SetMeUp
//
//  Created by Go on 19/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

//================================================================
//******************** EXPECTED SERVICE MODEL ********************
//================================================================
/*
 
 {
    user_id="";
    first_name="";
    last_name="";
    approve_count=13213
    profile_pic_id= ""
 }
 
 */
//================================================================
//================================================================

#import "SMUFriend.h"

@interface SMUFriend()
{
    NSString *_fullName;
}

@end

@implementation SMUFriend

- (void)setFriendDetailsWithDict:(NSDictionary*)dictionary{
    _userID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
    _name  =   [dictionary objectForKey:@"name"];
    _profilePicture =   [dictionary objectForKey:@"profile_thumb"];
    _approveCount = [[dictionary objectForKey:@"approve_count"] integerValue];
    _is_smu_user=[[dictionary objectForKey:@"is_smu_user"]integerValue];
}

//-(NSString*)getFullName{
//    if (_fullName==nil) {
//        _fullName=[SMUtils getFullNameWithFirstName:_firstName withLastName:_lastName];
//    }
//    return _fullName;
//}

@end
