//
//  SMUCloseBCRecoUserB.m
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCloseBCRecoUserB.h"

@implementation SMUCloseBCRecoUserB
-(void)setRecoBCUserBDictionary:(NSDictionary *)dictionary {
    _first_name =[dictionary objectForKey:@"first_name"];
    _userid = [dictionary objectForKey:@"id"];
    _imgUrl = [dictionary objectForKey:@"img_url"];
    _last_name = [dictionary objectForKey:@"last_name"];
    _name = [dictionary objectForKey:@"name"];
}
@end
