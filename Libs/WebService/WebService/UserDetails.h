//
//  UserDetails.h
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *picID;
@property (nonatomic, strong) NSString *userDob;
@property (nonatomic, strong) NSString *userEducation;
@property (nonatomic, strong) NSString *userLocation;
@property (nonatomic, strong) NSString *userWorkplace;
@property (nonatomic , strong)NSString *fcStatus;
@property (nonatomic , strong)NSDictionary *approveInfo;

+ (UserDetails *)userdetailsFromDictionary:(NSDictionary *)dictionary;

@end
