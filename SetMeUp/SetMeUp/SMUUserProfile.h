//
//  SMUUserProfile.h
//  SetMeUp
//
//  Created by Go on 17/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUUserProfile : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *dateOfBirth;
@property (nonatomic, strong) NSString *education;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *workplace;
@property (nonatomic, strong) NSArray *approveUserFriends;
@property (nonatomic, readwrite) NSInteger firstConnectStatus;  // currently refered as lets meet funcitonality
@property (nonatomic, readwrite) NSInteger internStatus;        // flag used to determine Who referred you status 
@property (nonatomic, readonly) NSString *fullName;
- (NSString*)getFullName;

- (void)setUserProfileWithDict:(NSDictionary*)dictionary;
- (void)saveCustomObject:(SMUUserProfile *)object key:(NSString *)key;
- (SMUUserProfile *)loadCustomObjectWithKey:(NSString *)key;
@end
