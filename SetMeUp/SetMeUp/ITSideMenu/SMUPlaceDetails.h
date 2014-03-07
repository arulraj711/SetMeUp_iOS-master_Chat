//
//  SMUPlaceDetails.h
//  SetMeUp
//
//  Created by ArulRaj on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUPlaceDetails : NSObject
@property (assign) NSInteger a_user_checkin_count;
@property (nonatomic,strong) NSString *a_user_last_checked_in;
@property (assign) NSInteger c_user_checkin_count;
@property (nonatomic,strong) NSString *c_user_last_checked_in;
@property (nonatomic,strong) NSString *checkin_date;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;
@property (nonatomic) float lattitude;
@property (nonatomic) float longitude;
@property (nonatomic,strong) NSString *place_id;
@property (nonatomic,strong) NSString *place_name;
@property (nonatomic,strong) NSString *place_thumb_url;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *street;
@property (nonatomic,strong) NSString *user_last_checked_in_by;

-(void)setPlaceDetailsWithDict:(NSDictionary *)dictionary;
@end
