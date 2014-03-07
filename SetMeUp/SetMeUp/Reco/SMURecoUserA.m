//
//  SMURecoUserA.m
//  SMUReco
//
//  Created by In on 28/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoUserA.h"
#import "SMURecoUserC.h"

@implementation SMURecoUserA
-(void)setRecoUserADetailsWithDict:(NSDictionary *)dictionary {
    _firstname = [dictionary objectForKey:@"first_name"];
    _lastname = [dictionary objectForKey:@"last_name"];
    _gender = [dictionary objectForKey:@"gender"];
    _auserId = [dictionary objectForKey:@"id"];
    _img_exist = [dictionary objectForKey:@"img_exist"];
    _img_url = [dictionary objectForKey:@"img_url"];
    _name = [dictionary objectForKey:@"name"];
}
@end
