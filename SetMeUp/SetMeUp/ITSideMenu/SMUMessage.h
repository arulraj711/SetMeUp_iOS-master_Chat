//
//  SMUMessage.h
//  SetMeUp
//
//  Created by ArulRaj on 1/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUMessage : NSObject
@property (nonatomic,strong)NSString *from_user_name;
@property (nonatomic,strong)NSString *created;
@property (nonatomic,strong)NSString *from_user_id;
@property (nonatomic,strong)NSString *msgId;
@property (nonatomic,strong)NSString *message;
@property (nonatomic,strong)NSString *modified;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *to_user_id;
//@property (nonatomic,strong)NSString *to_user_img_exist;
@property (nonatomic,strong)NSString *to_user_name;

-(void)setMessageWithDict:(NSDictionary *)dictionary;
@end
