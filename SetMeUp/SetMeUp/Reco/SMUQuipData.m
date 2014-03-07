//
//  SMUQuipData.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMUQuipData.h"
#import "SMUQuipQuestion.h"

@implementation SMUQuipData
-(void)setQuipDataWithDict:(NSDictionary *)dictionary {
    _categoryId = [dictionary objectForKey:@"category_id"];
    _categoryName = [dictionary objectForKey:@"category_name"];
    _quipId = [dictionary objectForKey:@"id"];
    
    _questions = [NSMutableArray array];
    NSArray *questions = [dictionary objectForKey:@"questions"];
    if([questions isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *questionDic in questions) {
            SMUQuipQuestion *quipQuestion = [[SMUQuipQuestion alloc] init];
            [quipQuestion setDictionary:questionDic];
            [_questions addObject:quipQuestion];
        }
    }
       
//    _question_id_1 = [dictionary objectForKey:@"question_id_1"];
//    _question_id_2 = [dictionary objectForKey:@"question_id_2"];
//    _question_text_1 = [dictionary objectForKey:@"question_text_1"];
//    _question_text_2 = [dictionary objectForKey:@"question_text_2"];
}
@end
