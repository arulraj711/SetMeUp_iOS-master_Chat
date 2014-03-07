//
//  SMUCheckin.h
//  SetMeUp
//
//  Created by ArulRaj on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUCheckin : NSObject
@property (assign) NSInteger a_user_checkin_count;
@property (assign) NSInteger c_user_checkin_count;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;
@property (nonatomic) float lattitude;
@property (nonatomic) float longitude;
@property (nonatomic,strong) NSString *placeId;
@property (nonatomic,strong) NSString *placeName;
@property (nonatomic,strong) NSString *placeUrl;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *street;
@property (nonatomic,strong) NSString *user_last_checkedin;
@property (nonatomic,strong) NSString *user_last_checkedin_by;
@property (nonatomic,strong) NSString *zip;
@property (nonatomic,strong) NSString *checkinType;

-(void)setCheckinsWithDict:(NSDictionary *)dictionary;
@end
