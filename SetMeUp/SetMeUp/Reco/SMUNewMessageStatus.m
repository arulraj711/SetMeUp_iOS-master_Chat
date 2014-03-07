//
//  SMUNewMessageStatus.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMUNewMessageStatus.h"

@implementation SMUNewMessageStatus

-(void)setNewMessageStatusWithDict:(NSDictionary *)dictionary {
    _fromUserId =[dictionary objectForKey:@"from_user_id"];
    _toUserId = [dictionary objectForKey:@"to_user_id"];
    _msgId = [dictionary objectForKey:@"id"];
}

@end
