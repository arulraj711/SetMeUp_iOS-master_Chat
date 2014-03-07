//
//  SMUInterest.h
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUInterest : NSObject

@property(nonatomic,strong) NSString *interestId;
@property(nonatomic,strong) NSString *photoUrlString;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,readwrite) BOOL isCommon;

- (void)setInterestFromDictionary:(NSDictionary *)dictionary;
@end
