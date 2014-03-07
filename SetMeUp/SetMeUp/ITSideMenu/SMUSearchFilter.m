//
//  SMUSearchFilter.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/4/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUSearchFilter.h"

@implementation SMUSearchFilter
-(void)setvalueforAutofilldataWithDict:(NSDictionary *)dictionary{
    if ((NSNull *)dictionary != [NSNull null]) {
    _value=[dictionary objectForKey:@"value"];
    _label=[dictionary objectForKey:@"label"];
    
    }else{
        _value=@"";
        _label=@"";
    }
}
@end
