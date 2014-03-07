//
//  SMUBCRecoQuestions.h
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUBCRecoQuestions : NSObject

@property (nonatomic,strong) NSString *questionId;
@property (nonatomic,strong) NSString *questionText;


-(void)setQuestionWithDict:(NSDictionary *)dictionary;

@end
