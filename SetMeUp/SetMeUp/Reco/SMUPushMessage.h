//
//  SMUPushMessage.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUPushMessage : NSObject

@property (nonatomic,strong) NSString *aResponseMsg;
@property (nonatomic,strong) NSString *bResponseMsg;
@property (assign) int totalMsgCount;

-(void)setPushMessageWithDict:(NSDictionary *)dictionary;
@end
