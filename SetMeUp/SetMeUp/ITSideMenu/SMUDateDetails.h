//
//  SMUDateDetails.h
//  SetMeUp
//
//  Created by ArulRaj on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUDateDetails : NSObject
@property(nonatomic,strong) NSString *date_time;
@property(nonatomic,strong) NSString *from_first_name;
@property(nonatomic,strong) NSString *from_message;
@property(nonatomic,strong) NSString *from_msg_id;
@property(nonatomic,strong) NSString *location_id;
@property(nonatomic,strong) NSString *dateId;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *checkinType;
-(void)setDateDetailsWithDict:(NSDictionary *)dictionary;
@end
