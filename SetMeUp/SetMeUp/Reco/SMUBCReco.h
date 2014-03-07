//
//  SMUBCReco.h
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserB;
@interface SMUBCReco : NSObject
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *lastname;
@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *connectionId;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) SMURecoUserB *userB;

-(void)setBCRecoDetailsWithDict:(NSDictionary *)dictionary;
+(NSMutableArray *)mock;
@end
