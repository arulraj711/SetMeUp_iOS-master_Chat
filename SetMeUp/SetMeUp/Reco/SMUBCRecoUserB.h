//
//  SMUBCRecoUserB.h
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUBCRecoUserB : NSObject


@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *imageUrl;

-(void)setUserBDetailsWithDict:(NSDictionary *)dictionary;



@end
