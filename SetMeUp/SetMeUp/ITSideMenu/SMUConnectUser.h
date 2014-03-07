//
//  SMUConnectUser.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/8/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUConnectUser : NSObject
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *profilePicture;
-(void)setConnectedDetailsWithDict:(NSDictionary *)dictionary;

@end
