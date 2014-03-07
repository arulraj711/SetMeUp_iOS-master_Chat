//
//  SMUBCRecoUserA.m
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import "SMUBCRecoUserA.h"
#import "SMUBCRecoQuipData.h"
#import "SMUBCRecoRatings.h"

@implementation SMUBCRecoUserA
-(void)setUserADetailWithDict:(NSDictionary *)dictionary{
    
    _firstname = [dictionary objectForKey:@"first_name"];

    _userId = [dictionary objectForKey:@"id"];
    _name = [dictionary objectForKey:@"name"];
    _hometown=[dictionary objectForKey:@"hometown"];
    _location = [dictionary objectForKey:@"location"];
    _education = [dictionary objectForKey:@"education"];
    _birthday= [dictionary objectForKey:@"birthday"];
    _connectionId = [dictionary objectForKey:@"connectionId"];
    _age=[dictionary objectForKey:@"Age"];
    _img_url=[dictionary objectForKey:@"img_url"];
    _is_smu_user = [dictionary objectForKey:@"is_smu_user"];
    _quipArray = [NSMutableArray array];
    _ratingArray = [NSMutableArray array];
    NSArray *quipData=[dictionary objectForKey:@"quip_data"];
    
    if([quipData isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *dic in quipData)
        {
            SMUBCRecoQuipData *quips=[[SMUBCRecoQuipData alloc]init];
            [quips setQuipDataDetailsWithDict:dic];
            [_quipArray addObject:quips];
        }
    }
    
    NSArray *ratingQuestions=[dictionary objectForKey:@"rating_ans"];
    
    if([ratingQuestions isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *dic in ratingQuestions)
        {
            SMUBCRecoRatings *ratings=[[SMUBCRecoRatings alloc]init];
            [ratings setRatingDetailsWithDict:dic];
            [_ratingArray addObject:ratings];
        }
    }
}
@end
