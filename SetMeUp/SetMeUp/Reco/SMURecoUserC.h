//
//  SMURecoUserC.h
//  SMUReco
//
//  Created by In on 28/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMURecoUserC : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readwrite) BOOL isSelected;

@property (nonatomic,strong) NSString *connectionId;
@property (nonatomic,strong) NSString *firstname;
@property (nonatomic,strong) NSString *cUserId;
@property (nonatomic,strong) NSString *img_exist,*img_url;
@property (nonatomic,strong) NSString *is_smu_user;
@property (nonatomic,strong) NSString *lastname;

-(void)setRecoUserCDetailsWithDict:(NSDictionary *)dictionary;

@end
