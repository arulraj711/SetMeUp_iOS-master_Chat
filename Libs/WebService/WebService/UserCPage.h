//
//  UserCPage.h
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCPage : NSObject

@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSString *user_c_approve_status;
@property (nonatomic,strong) NSString *college_name;
@property (nonatomic,strong) NSString *education_year;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *home_town;
@property (nonatomic,strong) NSString *work_place;

@property (assign) int user_c_connection_status;
@property (assign) int heart_rate;
@property (assign) int user_c_mutual_friend_cnt;
@property (assign) int user_c_mutual_friend_set;
@property (assign) int mutual_interest_count;

@property (nonatomic,strong) NSArray *user_c_org_pic_album;

@property (nonatomic,strong) NSDictionary *user_c_mutual_friendDic;
@property (nonatomic,strong) NSDictionary *interestDic;

+ (UserCPage *)userCDetailsFromDictionary:(NSDictionary *)dictionary;

@end
