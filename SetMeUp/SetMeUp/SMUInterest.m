//
//  SMUInterest.m
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUInterest.h"

@implementation SMUInterest

- (void)setInterestFromDictionary:(NSDictionary *)dictionary
{
    _interestId = [dictionary objectForKey:@"interest_id"];
    _photoUrlString = [dictionary objectForKey:@"interest_thumb"];
    _name = [dictionary objectForKey:@"interest_name"];
    _isCommon=[[dictionary objectForKey:@"is_mutual_interest"] boolValue];
}
@end
