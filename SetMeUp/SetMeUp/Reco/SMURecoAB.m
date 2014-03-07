//
//  SMUSingleReco.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMURecoAB.h"
#import "SMURecoUserA.h"
#import "SMURecoUserC.h"
#import "SMUPhraseQuestion.h"
#import "SMUQuipData.h"
#import "SMURatingData.h"
#import "SMUAllUserA.h"
@implementation SMURecoAB

-(void)setSingleRecoDetailsWithDict:(NSDictionary *)dictionary {
    _userA = [[SMURecoUserA alloc]init];
    [_userA setRecoUserADetailsWithDict:[dictionary objectForKey:@"a_user"]];
    
    _cUserArray=[NSMutableArray array];
    NSArray *userCArray = [dictionary objectForKey:@"c_user"];
    if([userCArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in userCArray) {
            SMURecoUserC *userC = [[SMURecoUserC alloc]init];
            [userC setRecoUserCDetailsWithDict:dic];
            [_cUserArray addObject:userC];
        }
    }
    
    _phraseQuestion = [[SMUPhraseQuestion alloc]init];
    [_phraseQuestion setPhraseQuestionWithDict:[dictionary objectForKey:@"phrase_questions"]];
    
    _quipDataArray =[NSMutableArray array];
    NSArray *quipArray = [dictionary objectForKey:@"quips_questions"];
    if([quipArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in quipArray) {
            SMUQuipData *quipData = [[SMUQuipData alloc]init];
            [quipData setQuipDataWithDict:dic];
            [_quipDataArray addObject:quipData];
        }
    }
    
    _ratingDataArray =[NSMutableArray array];
    NSArray *ratingArray = [dictionary objectForKey:@"rating_questions"];
    if([ratingArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in ratingArray) {
            SMURatingData *ratingData = [[SMURatingData alloc]init];
            [ratingData setRatingDataWithDict:dic];
            [_ratingDataArray addObject:ratingData];
        }
    }
    
    _allAUserArray =[NSMutableArray array];
    NSArray *allUserAArray = [dictionary objectForKey:@"all_a_user"];
    if([allUserAArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in allUserAArray) {
            SMUAllUserA *allUserA = [[SMUAllUserA alloc]init];
            [allUserA setAllUserADetailsWithDict:dic];
            [_allAUserArray addObject:allUserA];
        }
    }
    
}

@end
