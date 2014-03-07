//
//  MMPage.h
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMPage : NSObject

@property (nonatomic,strong) NSString *matchmakerId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *profile_thumb;
@property (nonatomic,strong) NSString *is_approved;
@property (nonatomic,strong) NSString *is_smu_user;

+ (MMPage *)matchmakerDetailsFromDictionary:(NSDictionary *)dictionary;

@end
