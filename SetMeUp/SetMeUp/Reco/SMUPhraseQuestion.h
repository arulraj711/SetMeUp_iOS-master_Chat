//
//  SMUPhraseQuestion.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUPhraseQuestion : NSObject
@property (nonatomic,strong) NSString *questionId;
@property (nonatomic,strong) NSString *questionText;

-(void)setPhraseQuestionWithDict:(NSDictionary *)dictionary;
@end
