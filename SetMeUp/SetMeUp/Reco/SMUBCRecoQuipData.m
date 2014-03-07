//
//  SMUBCRecoQuipData.m
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import "SMUBCRecoQuipData.h"
#import "SMUBCRecoQuestions.h"
@implementation SMUBCRecoQuipData

-(void)setQuipDataDetailsWithDict:(NSDictionary *)dictionary{
    
    _categoryId=[dictionary objectForKey:@"category_id"];
    _quipId=[dictionary objectForKey:@"id"];
    _categoryName=[dictionary objectForKey:@"Category_name"];
    _answer=[dictionary objectForKey:@"answer"];
    _questionArray = [NSMutableArray array];
    NSArray *questions=[dictionary objectForKey:@"questioons"];
    if(questions.count)
    {
        if([questions isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *dic in questions)
            {
                SMUBCRecoQuestions *quest=[[SMUBCRecoQuestions alloc]init];
                [quest setQuestionWithDict:dic];
                [_questionArray addObject:quest];
            }
        }
    }
    else
    {
        SMUBCRecoQuestions *bcRecoQuestion1 = [[SMUBCRecoQuestions alloc]init];
        bcRecoQuestion1.questionId = [dictionary objectForKey:@"question_id_1"];
        bcRecoQuestion1.questionText = [dictionary objectForKey:@"question_text_1"];
        
        SMUBCRecoQuestions *bcRecoQuestion2 = [[SMUBCRecoQuestions alloc]init];
        bcRecoQuestion2.questionId = [dictionary objectForKey:@"question_id_2"];
        bcRecoQuestion2.questionText = [dictionary objectForKey:@"question_text_2"];
        
        [_questionArray addObject:bcRecoQuestion1];
        [_questionArray addObject:bcRecoQuestion2];
    }
}

@end
