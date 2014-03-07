//
//  SMUInterns.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUInterns : NSObject

@property (assign) NSInteger referenceCount;
@property(nonatomic,strong) NSString *InternName;
@property(nonatomic,strong) NSString *InternId;
-(void)setInternDetailsFromDict:(NSDictionary *)dictionary;

@end
