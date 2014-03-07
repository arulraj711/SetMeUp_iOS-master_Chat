//
//  RecoDetails.m
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "RecoDetails.h"

@implementation RecoDetails

+ (RecoDetails *)recoDetailsFromDictionary:(NSDictionary *)dictionary {
    RecoDetails *recoObj    =   [[RecoDetails alloc]init];
    recoObj.b_reco_count = [[dictionary objectForKey:@"b_reco_count"] intValue];
    recoObj.c_reco_count = [[dictionary objectForKey:@"c_reco_count"] intValue];
    recoObj.connection_match_id = [[dictionary objectForKey:@"connection_match_id"] intValue];
    recoObj.date_sug_id = [[dictionary objectForKey:@"date_sug_id"] intValue];
    recoObj.message_count = [[dictionary objectForKey:@"message_count"]intValue];
    recoObj.pushMessageDic = [dictionary objectForKey:@"pushMessages"];
    return recoObj;
}

@end
