//
//  SMUCloseABRecoUserA.m
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCloseABRecoUserA.h"

@implementation SMUCloseABRecoUserA
-(void)setRecoABUserADictionary:(NSDictionary *)dictionary {
    _first_name = [dictionary objectForKey:@"first_name"];
    _gender = [dictionary objectForKey:@"gender"];
    _userid = [dictionary objectForKey:@"id"];
    _imgUrl = [dictionary objectForKey:@"img_url"];
    _last_name = [dictionary objectForKey:@"last_name"];
    _name = [dictionary objectForKey:@"name"];
}
@end
