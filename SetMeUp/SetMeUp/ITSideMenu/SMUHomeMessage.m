//
//  SMUHomeMessage.m
//  SetMeUp
//
//  Created by ArulRaj on 1/2/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUHomeMessage.h"
#import "SMUConnectedUser.h"
@implementation SMUHomeMessage
-(void)setHomeMessageWithDict:(NSDictionary *)dictionary {
    //NSLog(@"sethome message dict");
    _newMessageCount = [[dictionary objectForKey:@"newMessageCount"] intValue];
    _connectedUser=[NSMutableArray array];
    NSArray *connectedArray = [dictionary objectForKey:@"ConnectedUsers"];
    if([connectedArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in connectedArray) {
            SMUConnectedUser *connUser = [[SMUConnectedUser alloc]init];
            [connUser setConnectedUserWithDict:dic];
            [_connectedUser addObject:connUser];
        }
    }
    
//    _messageSenderIdCount = [NSMutableArray array];
//    NSArray *messageSenderArray = [dictionary objectForKey:@"message_sender_idCount"];
//    if([messageSenderArray isKindOfClass:[NSArray class]]) {
//        for(NSDictionary *dic in messageSenderArray) {
//            SMUMessageSenderIdCount *msgSender = [[SMUMessageSenderIdCount alloc]init];
//            [msgSender setMessageSenderWithDict:dic];
//            [_messageSenderIdCount addObject:msgSender];
//        }
//    }
    
//    _messageArray = [NSMutableArray array];
//    NSArray *newMsgArray = [dictionary objectForKey:@"newMessages"];
//    if([newMsgArray isKindOfClass:[NSArray class]]) {
//        for(NSDictionary *dic in newMsgArray) {
//            SMUNewMessages *newMsg = [[SMUNewMessages alloc]init];
//            [newMsg setNewMessagesWithDict:dic];
//            [_messageArray addObject:newMsg];
//        }
//    }
}
@end
