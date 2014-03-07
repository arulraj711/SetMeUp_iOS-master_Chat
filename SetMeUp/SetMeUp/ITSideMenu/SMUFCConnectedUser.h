//
//  SMUFCConnectedUser.h
//  SetMeUp
//
//  Created by ArulRaj on 1/22/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUFCConnectedUser : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *lastname;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSArray *mostCheckins;
@property (nonatomic,strong) NSArray *recentCheckins;

-(void)setFCConnUserWithDict:(NSDictionary *)dictionary;
@end
