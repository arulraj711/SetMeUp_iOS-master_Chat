//
//  SMUBCRecoRatings.m
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import "SMUBCRecoRatings.h"

@implementation SMUBCRecoRatings

-(void)setRatingDetailsWithDict:(NSDictionary *)dictionary{
    
    _category_name=[dictionary objectForKey:@"category_name"];
    _question_text=[dictionary objectForKey:@"question_text"];
    _answer=[dictionary objectForKey:@"answer"];
    
}

@end
