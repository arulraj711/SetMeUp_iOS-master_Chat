//
//  SMUFriendOfFriend.h
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUFriendOfFriend : NSObject

@property (nonatomic,readwrite) NSInteger age;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *collegeName;
@property (nonatomic,strong) NSString *educationYear;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,readwrite) NSInteger heartRate;
@property (nonatomic,strong) NSString *home_town;
@property (nonatomic,strong) NSArray *interests;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,readwrite) NSInteger mutualInterestCount;
@property (nonatomic,strong) NSString *profileImage;
@property (nonatomic,readwrite) NSInteger approveStatus;
@property (nonatomic,strong) NSArray *mutualFriends;
@property (nonatomic,readwrite) NSInteger mutualFriendsCount;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSString *workPlace;

@property (nonatomic,readonly) NSString *fullName;

-(void)setUserCDetailsFromDictionary:(NSDictionary *)dictionary;

@end
