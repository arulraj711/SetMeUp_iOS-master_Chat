//
//  SMURecoUserB.h
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserA;
@interface SMURecoUserB : NSObject

@property (nonatomic, strong) NSMutableArray *userAs;
@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *imageUrl,*is_smu_user;
@property (nonatomic,strong) UIImage *image;
-(void)setUserBDetailsWithDict:(NSDictionary *)dictionary;

@end
