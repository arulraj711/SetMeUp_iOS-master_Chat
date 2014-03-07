//
//  SMURecentStatus.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMURecentStatus.h"
#import "SMUNewMessageStatus.h"
#import "SMUPushMessage.h"
@implementation SMURecentStatus

-(void)setRectStatusFromDict:(NSDictionary *)dictionary {
    _connMatchId = [[dictionary objectForKey:@"connection_match_id"] intValue];
    _dateSuggId = [[dictionary objectForKey:@"date_sug_id"] intValue];
    _googleDateSuggId = [[dictionary objectForKey:@"google_date_sug_id"]intValue];
    _bRecoCount = [[dictionary objectForKey:@"b_reco_count"]intValue];
    _cRecoCount = [[dictionary objectForKey:@"c_reco_count"]intValue];
    _messageCount = [[dictionary objectForKey:@"message_count"]intValue];
    _bOpenRecoCount = [[dictionary objectForKey:@"b_open_reco_count"]intValue];
    _broadcastCount = [[dictionary objectForKey:@"broadcast"] intValue];
    _messageStatusArray=[NSMutableArray array];
    NSArray *msgStatusArray = [dictionary objectForKey:@"new_message"];
    if([msgStatusArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in msgStatusArray) {
            SMUNewMessageStatus *message = [[SMUNewMessageStatus alloc]init];
            [message setNewMessageStatusWithDict:dic];
            [_messageStatusArray addObject:message];
        }
    }
    
    _pushMessagesArray = [NSMutableArray array];
    NSArray *pushMsgArray = [dictionary objectForKey:@"pushMessages"];
    if([pushMsgArray isKindOfClass:[NSArray class]]) {
        for(NSDictionary *dic in pushMsgArray) {
            SMUPushMessage *pushMsg = [[SMUPushMessage alloc]init];
            [pushMsg setPushMessageWithDict:dic];
            [_pushMessagesArray addObject:pushMsg];
        }
    }
}

@end
