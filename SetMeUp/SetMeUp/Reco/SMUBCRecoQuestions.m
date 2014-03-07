//
//  SMUBCRecoQuestions.m
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import "SMUBCRecoQuestions.h"

@implementation SMUBCRecoQuestions

-(void)setQuestionWithDict:(NSDictionary *)dictionary
{
    
    _questionId=[dictionary objectForKey:@"question_id"];
    _questionText=[dictionary objectForKey:@"question_text"];
    
}
@end
