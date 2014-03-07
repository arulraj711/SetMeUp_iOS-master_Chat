//
//  SMUBCRecoUserA.h
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUBCRecoUserA : NSObject
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *hometown;
@property (nonatomic,strong) NSString *education;
@property (nonatomic,strong) NSString *connectionId;
@property (nonatomic,strong) NSString *img_url;
@property(nonatomic,strong)NSString *age;
@property(nonatomic,strong)NSString *is_smu_user;
@property(nonatomic,strong)NSMutableArray *quipArray;
@property(nonatomic,strong)NSMutableArray *ratingArray;

-(void)setUserADetailWithDict:(NSDictionary *)dictionary;

@end
