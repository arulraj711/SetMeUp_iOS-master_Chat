//
//  SMUPhraseQuestion.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMUPhraseQuestion.h"

@implementation SMUPhraseQuestion

-(void)setPhraseQuestionWithDict:(NSDictionary *)dictionary {
    _questionId = [dictionary objectForKey:@"id"];
    _questionText = [dictionary objectForKey:@"text"];
}

@end
