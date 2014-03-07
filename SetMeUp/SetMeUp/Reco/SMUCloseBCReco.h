//
//  SMUCloseBCReco.h
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMUCloseBCRecoUserB;
@interface SMUCloseBCReco : NSObject
@property (nonatomic,strong) SMUCloseBCRecoUserB *recoBCUserB;
@property (nonatomic,strong) NSMutableArray *recoBCUserAArray;
-(void) setCloseBCRecoDictionary:(NSDictionary *)dictionary;
@end
