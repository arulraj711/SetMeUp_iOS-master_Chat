//
//  SMURecoUserC.m
//  SMUReco
//
//  Created by In on 28/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoUserC.h"

@implementation SMURecoUserC
- (id)init
{
    self = [super init];
    if (self) {
        self.isSelected = YES;
    }
    return self;
}
-(void)setRecoUserCDetailsWithDict:(NSDictionary *)dictionary {
    _connectionId = [dictionary objectForKey:@"a_c_connection_id"];
    _firstname = [dictionary objectForKey:@"first_name"];
    _cUserId = [dictionary objectForKey:@"id"];
    _img_exist = [dictionary objectForKey:@"img_exist"];
    _img_url = [dictionary objectForKey:@"img_url"];
    _is_smu_user = [dictionary objectForKey:@"is_smu_user"];
    _lastname = [dictionary objectForKey:@"last_name"];
    _name = [dictionary objectForKey:@"name"];
}

@end
