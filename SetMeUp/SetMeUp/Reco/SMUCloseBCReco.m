//
//  SMUCloseBCReco.m
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCloseBCReco.h"
#import "SMUCloseBCRecoUserA.h"
#import "SMUCloseBCRecoUserB.h"

@implementation SMUCloseBCReco
-(void) setCloseBCRecoDictionary:(NSDictionary *)dictionary {
    
    self.recoBCUserB = [[SMUCloseBCRecoUserB alloc]init];
    [self.recoBCUserB setRecoBCUserBDictionary:[dictionary objectForKey:@"b_user"]];
    self.recoBCUserAArray = [NSMutableArray array];
    NSArray *recoAs = [dictionary objectForKey:@"a_user"];
    for (NSDictionary *recoA in recoAs) {
        SMUCloseBCRecoUserA *user_a = [[SMUCloseBCRecoUserA alloc]init];
        [user_a setRecoBCUserADictionary:recoA];
        [self.recoBCUserAArray addObject:user_a];
    }
}
@end
