//
//  SMURatingData.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMURatingData.h"

@implementation SMURatingData
-(void)setRatingDataWithDict:(NSDictionary *)dictionary {
    _ratingId = [dictionary objectForKey:@"id"];
    _ratingText = [dictionary objectForKey:@"text"];
}
@end
