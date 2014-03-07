//
//  SMUFriend.h
//  SetMeUp
//
//  Created by Go on 19/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUFriend : NSObject

@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, readwrite) NSInteger approveCount;
@property (nonatomic, readwrite) NSInteger is_smu_user;

//@property (nonatomic, readonly) NSString *fullname;

- (void)setFriendDetailsWithDict:(NSDictionary*)dictionary;

@end
