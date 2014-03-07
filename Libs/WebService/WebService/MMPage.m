//
//  MMPage.m
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "MMPage.h"

@implementation MMPage

+ (MMPage *)matchmakerDetailsFromDictionary:(NSDictionary *)dictionary {
    MMPage *mmObject    =   [[MMPage alloc]init];
    mmObject.matchmakerId = [dictionary objectForKey:@"id"];
    mmObject.name = [dictionary objectForKey:@"name"];
    mmObject.profile_thumb = [dictionary objectForKey:@"profile_thumb"];
    mmObject.is_approved = [dictionary objectForKey:@"is_approved"];
    mmObject.is_smu_user = [dictionary objectForKey:@"is_smu_user"];
    return mmObject;
}

@end
