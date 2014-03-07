//
//  SMUBCRecoRatings.h
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUBCRecoRatings : NSObject


@property (nonatomic,strong) NSString *category_name;
@property (nonatomic,strong) NSString *question_text;

@property (nonatomic,strong) NSString *answer;


-(void)setRatingDetailsWithDict:(NSDictionary *)dictionary;

@end
