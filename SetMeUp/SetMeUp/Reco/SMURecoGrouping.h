//
//  SMURecoGrouping.h
//  SetMeUp
//
//  Created by In on 05/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoAB;
@interface SMURecoGrouping : NSObject
@property (nonatomic, strong) NSMutableArray *recoABs;
@property (nonatomic,strong) NSMutableArray *recoBCs;
-(void)setDictionary:(NSDictionary *)dictionary;
@end
