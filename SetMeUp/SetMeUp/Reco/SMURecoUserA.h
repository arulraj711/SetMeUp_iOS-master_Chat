//
//  SMURecoUserA.h
//  SMUReco
//
//  Created by In on 28/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserC;
@interface SMURecoUserA : NSObject
@property (nonatomic, strong) NSMutableArray *userCs;
@property (nonatomic, strong) NSString *name;

@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *auserId;
@property (nonatomic,strong) NSString *img_exist,*img_url;
@property (nonatomic,strong) NSString *lastname;
@property (nonatomic,strong) UIImage *image;
-(void)setRecoUserADetailsWithDict:(NSDictionary *)dictionary;
@end
