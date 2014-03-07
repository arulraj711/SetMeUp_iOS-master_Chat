//
//  SMUResponseHandler.m
//  SetMeUp
//
//  Created by In on 21/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUResponseHandler.h"
#import "SMUFriend.h"

@implementation SMUResponseHandler

+ (void)parseMatchMakersResponse:(id)responseObject
                      onSuccess:(void (^)( id object))success
{
    NSMutableArray *friends = [NSMutableArray array];
    NSArray *objs = [responseObject valueForKeyPath:@"rest_response.matchmakers"];
    for (NSDictionary *dic in objs) {
        SMUFriend *friend = [[SMUFriend alloc]init];
        friend.userID = [dic objectForKey:@"id"];
        friend.profilePicture = [dic objectForKey:@"profile_thumb"];
        [friends addObject:friend];
    }
    success(friends);
}

@end
