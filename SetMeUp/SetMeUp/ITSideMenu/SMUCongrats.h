//
//  SMUCongrats.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/29/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUCongrats : NSObject
@property (nonatomic,strong) NSString *access_token;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *c_frnd_show_confirm_ignore;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *domain_email;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *modified;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *gender;
@property (assign) int img_exist;
@property (assign) int is_mm;
@property (assign) int is_smu_user;
@property (nonatomic,strong) NSString *profile_pic_id;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *relationship_status;

-(void)setConnectedUserFromDict:(NSDictionary *)dictionary;

@end
