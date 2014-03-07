//
//  SMUConnectedUser.h
//  SetMeUp
//
//  Created by ArulRaj on 1/2/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUConnectedUser : NSObject
@property (nonatomic,strong) NSString *user_id;
//@property (assign) int img_exist;
@property (nonatomic,strong) NSString *recentMsg;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *b_user_connected_date;
@property (nonatomic,strong) NSString *b_user_id;
@property (nonatomic,strong) NSString *b_user_image_url;
@property (nonatomic,strong) NSString *b_user_name;
@property(nonatomic,assign) NSInteger msgCount;

-(void)setConnectedUserWithDict:(NSDictionary *)dictionary;
@end
