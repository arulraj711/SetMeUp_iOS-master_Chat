//
//  SMUHomeMessage.h
//  SetMeUp
//
//  Created by ArulRaj on 1/2/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUHomeMessage : NSObject
@property (nonatomic,strong) NSMutableArray *connectedUser;
@property (nonatomic,strong) NSMutableArray *messageSenderIdCount;
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (assign) int newMessageCount;

-(void)setHomeMessageWithDict:(NSDictionary *)dictionary;
@end
