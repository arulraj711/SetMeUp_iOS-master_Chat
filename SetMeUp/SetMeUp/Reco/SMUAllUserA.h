//
//  SMUAllUserA.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUAllUserA : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *lastname;

-(void)setAllUserADetailsWithDict:(NSDictionary *)dictionary;
@end
