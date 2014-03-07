//
//  SMUNewMessageStatus.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUNewMessageStatus : NSObject

@property (nonatomic,strong) NSString *fromUserId;
@property (nonatomic,strong) NSString *toUserId;
@property (nonatomic,strong) NSString *msgId;

-(void)setNewMessageStatusWithDict:(NSDictionary *)dictionary;
@end
