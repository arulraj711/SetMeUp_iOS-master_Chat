//
//  SMUInvite.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/5/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUInvite : NSObject
@property (nonatomic, strong) NSString *b_user_id;
@property (nonatomic, strong) NSString *b_user_imgurl;
@property (nonatomic, strong) NSString *b_user_name;
@property (nonatomic, strong) NSString *c_user_id;
@property (nonatomic, strong) NSString *c_user_imgurl;
@property (nonatomic, strong) NSString *c_user_name;
@property (nonatomic, strong) NSString *messageTemplate;

-(void)setNonsmuUserWithDict:(NSDictionary *)dictionary;
@end
