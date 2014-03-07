//
//  SMURecentStatus.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMURecentStatus : NSObject

@property (assign) int connMatchId;
@property (assign) int dateSuggId;
@property (assign) int bRecoCount;
@property (assign) int cRecoCount;
@property (assign) int messageCount;
@property (assign) int bOpenRecoCount;
@property (assign)  int broadcastCount;
@property (assign) int googleDateSuggId;
@property (nonatomic,strong) NSMutableArray *messageStatusArray;
@property (nonatomic,strong) NSMutableArray *pushMessagesArray;

-(void)setRectStatusFromDict:(NSDictionary *)dictionary;

@end
