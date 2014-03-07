//
//  SMUBroadCastUser.h
//  SetMeUp
//
//  Created by ArulRaj on 2/10/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUBroadCastUser : NSObject
@property (nonatomic,strong) NSString *a_user_id;
@property (nonatomic,strong) NSString *created;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *broadCastId;
@property (nonatomic,strong) NSString *imgUrl;

-(void)setBroadCastDetails:(NSDictionary *)dictionary;

@end
