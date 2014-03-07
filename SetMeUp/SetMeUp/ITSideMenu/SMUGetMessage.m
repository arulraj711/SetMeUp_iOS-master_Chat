//
//  SMUGetMessage.m
//  SetMeUp
//
//  Created by ArulRaj on 1/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUGetMessage.h"
#import "SMUMessage.h"

@implementation SMUGetMessage

-(void)setTotalMessageWithDict:(NSDictionary *)dictionary {
    _pageNo = [[dictionary objectForKey:@"page"] intValue];
    _total_page = [[dictionary objectForKey:@"total_page"] intValue];
    //NSLog(@"total page in model:%d",_total_page);
    //  Interest
    _messageArray=[NSMutableArray array];
    NSArray *msgArray = [dictionary objectForKey:@"MessageResults"];
    if([msgArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in msgArray) {
            SMUMessage *message = [[SMUMessage alloc]init];
            [message setMessageWithDict:dic];
            [_messageArray addObject:message];
            //            SMUInterest *interest=[[SMUInterest alloc] init];
            //            [interest setInterestFromDictionary:dic];
            //            [_interests addObject:interest];
            //
        }
       // NSLog(@"after processing msg array:%@",_messageArray);
    }
}

@end
