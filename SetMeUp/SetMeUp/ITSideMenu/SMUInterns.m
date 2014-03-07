//
//  SMUInterns.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUInterns.h"

@implementation SMUInterns

-(void)setInternDetailsFromDict:(NSDictionary *)dictionary{
   
    _InternId = [dictionary objectForKey:@"user_id"];
    _referenceCount = [[dictionary objectForKey:@"ref_count"] integerValue];
    NSString *name=[dictionary objectForKey:@"name"];
      if((NSNull *)name == [NSNull null]) {
          _InternName=@"Unknown";
      }else{
            _InternName = [dictionary objectForKey:@"name"];
      }
}
@end
