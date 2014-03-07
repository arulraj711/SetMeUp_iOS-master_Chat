//
//  SMURecoGrouping.m
//  SetMeUp
//
//  Created by In on 05/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMURecoGrouping.h"
#import "SMUCloseABReco.h"
#import "SMUCloseBCReco.h"

@implementation SMURecoGrouping

-(void)setDictionary:(NSDictionary *)dictionary
{
    _recoABs = [NSMutableArray array];
    _recoBCs = [NSMutableArray array];
    
    NSArray *recoABResponse = [dictionary objectForKey:@"recoAB"];
    if([recoABResponse isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in recoABResponse) {
            SMUCloseABReco *recoAB = [[SMUCloseABReco alloc] init];
            [recoAB setCloseABRecoDictionary:dic];
            [_recoABs addObject:recoAB];
        }
    }
    
    NSArray *recoBCResponse = [dictionary objectForKey:@"recoBC"];
    if([recoBCResponse isKindOfClass:[NSArray class]]) {
        for(NSDictionary *dic in recoBCResponse) {
            SMUCloseBCReco *recoBC = [[SMUCloseBCReco alloc]init];
            [recoBC setCloseBCRecoDictionary:dic];
            [_recoBCs addObject:recoBC];
        }
    }

}
@end
