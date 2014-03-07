//
//  SMUAllUserA.m
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "SMUAllUserA.h"

@implementation SMUAllUserA
-(void)setAllUserADetailsWithDict:(NSDictionary *)dictionary
{
    _userId = [dictionary objectForKey:@"id"];
    _firstname = [dictionary objectForKey:@"first_name"];
    _lastname = [dictionary objectForKey:@"last_name"];
}
@end
