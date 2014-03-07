//
//  SMUGetMessage.h
//  SetMeUp
//
//  Created by ArulRaj on 1/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUGetMessage : NSObject
@property (assign) int pageNo;
@property (assign) int total_page;
@property (nonatomic,strong) NSMutableArray *messageArray;
-(void)setTotalMessageWithDict:(NSDictionary *)dictionary;
@end
