//
//  RecoDetails.h
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecoDetails : NSObject

@property (assign) int b_reco_count;
@property (assign) int c_reco_count;
@property (assign) int connection_match_id;
@property (assign) int date_sug_id;
@property (assign) int message_count;
@property (nonatomic,strong) NSDictionary *pushMessageDic;

+ (RecoDetails *)recoDetailsFromDictionary:(NSDictionary *)dictionary;

@end
