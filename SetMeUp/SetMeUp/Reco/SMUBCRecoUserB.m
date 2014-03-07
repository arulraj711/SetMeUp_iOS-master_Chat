//
//  SMUBCRecoUserB.m
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import "SMUBCRecoUserB.h"

@implementation SMUBCRecoUserB

-(void)setUserBDetailsWithDict:(NSDictionary *)dictionary{
   
    _firstname = [dictionary objectForKey:@"first_name"];
    _userId = [dictionary objectForKey:@"id"];
    _name = [dictionary objectForKey:@"name"];
    _imageUrl=[dictionary objectForKey:@"img_url"];
    
}

@end
