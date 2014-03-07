//
//  SMURecoUserB.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoUserB.h"

@implementation SMURecoUserB
-(void)setUserBDetailsWithDict:(NSDictionary *)dictionary{
    
    _firstname = [dictionary objectForKey:@"first_name"];
    _userId = [dictionary objectForKey:@"id"];
    _name = [dictionary objectForKey:@"name"];
    _imageUrl=[dictionary objectForKey:@"img_url"];
    _is_smu_user = [dictionary objectForKey:@"is_smu_user"];
}
@end
