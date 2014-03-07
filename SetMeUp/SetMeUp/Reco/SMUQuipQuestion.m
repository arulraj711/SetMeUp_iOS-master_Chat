//
//  SMUQuipQuestion.m
//  SetMeUp
//
//  Created by In on 26/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUQuipQuestion.h"

@implementation SMUQuipQuestion

- (void)setDictionary:(NSDictionary *)dictionary
{
    _question_id = [dictionary objectForKey:@"question_id"];
    _question_text = [dictionary objectForKey:@"question_text"];
}
@end
