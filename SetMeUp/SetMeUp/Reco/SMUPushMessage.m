//
//  SMUPushMessage.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMUPushMessage.h"

@implementation SMUPushMessage

-(void)setPushMessageWithDict:(NSDictionary *)dictionary {
    _aResponseMsg = [dictionary objectForKey:@"a_response_msg"];
    _bResponseMsg = [dictionary objectForKey:@"b_response_msg"];
    _totalMsgCount = [[dictionary objectForKey:@"total_msg_count"]intValue];
}
@end
