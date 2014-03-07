//
//  UserCPage.m
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "UserCPage.h"

@implementation UserCPage

+ (UserCPage *)userCDetailsFromDictionary:(NSDictionary *)dictionary {
    UserCPage *userCObj = [[UserCPage alloc]init];
    userCObj.user_id = [dictionary objectForKey:@"c_user_id"];
    userCObj.first_name = [dictionary objectForKey:@"first_name"];
    userCObj.last_name = [dictionary objectForKey:@"last_name"];
    userCObj.age = [dictionary objectForKey:@"age"];
    userCObj.college_name = [dictionary objectForKey:@"college_name"];
    userCObj.education_year = [dictionary objectForKey:@"education_year"];
    userCObj.location = [dictionary objectForKey:@"location"];
    userCObj.home_town = [dictionary objectForKey:@"home_town"];
    userCObj.work_place = [dictionary objectForKey:@"work_place"];
    userCObj.user_c_org_pic_album = [dictionary objectForKey:@"user_c_org_pic_album"];
    userCObj.user_c_approve_status = [dictionary objectForKey:@"user_c_approve_status"];
    userCObj.user_c_connection_status = [[dictionary objectForKey:@"user_c_connection_status"] intValue];
    userCObj.heart_rate = [[dictionary objectForKey:@"heart_rate"] intValue];
    userCObj.user_c_mutual_friend_cnt = [[dictionary objectForKey:@"user_c_mutual_friend_cnt"] intValue];
    userCObj.user_c_mutual_friend_set = [[dictionary objectForKey:@"user_c_mutual_friend_set"] intValue];
    userCObj.mutual_interest_count = [[dictionary objectForKey:@"mutual_interest_count"]intValue];
    userCObj.user_c_mutual_friendDic = [dictionary objectForKey:@"user_c_mutual_friend"];
    userCObj.interestDic = [dictionary objectForKey:@"interest"];
    return userCObj;
}

@end
