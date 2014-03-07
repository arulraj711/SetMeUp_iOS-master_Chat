//
//  SMUCloseABReco.h
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMUCloseABRecoUserA;
@interface SMUCloseABReco : NSObject
@property (nonatomic,strong) SMUCloseABRecoUserA *recoABUserA;
@property (nonatomic,strong) NSMutableArray *recoABUserCArray;
-(void) setCloseABRecoDictionary:(NSDictionary *)dictionary;
@end
