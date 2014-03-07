//
//  SMUCloseABRecoUserC.m
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCloseABRecoUserC.h"

@implementation SMUCloseABRecoUserC
-(void)setRecoABUserCDictionary:(NSDictionary *)dictionary {
    _connectionid = [dictionary objectForKey:@"a_c_connection_id"];
    _first_name = [dictionary objectForKey:@"first_name"];
    _userid = [dictionary objectForKey:@"id"];
    _imgUrl = [dictionary objectForKey:@"img_url"];
    _last_name = [dictionary objectForKey:@"last_name"];
    _name = [dictionary objectForKey:@"name"];
}
@end
