//
//  SMUCloseABReco.m
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCloseABReco.h"
#import "SMUCloseABRecoUserA.h"
#import "SMUCloseABRecoUserC.h"

@implementation SMUCloseABReco
-(void) setCloseABRecoDictionary:(NSDictionary *)dictionary {
    self.recoABUserA = [[SMUCloseABRecoUserA alloc]init];
    [self.recoABUserA setRecoABUserADictionary:[dictionary objectForKey:@"a_user"]];
    self.recoABUserCArray = [NSMutableArray array];
    NSArray *recoCs = [dictionary objectForKey:@"c_user"];
    for (NSDictionary *recoC in recoCs) {
        SMUCloseABRecoUserC *user_c = [[SMUCloseABRecoUserC alloc]init];
        [user_c setRecoABUserCDictionary:recoC];
        [self.recoABUserCArray addObject:user_c];
    }
    
}
@end
