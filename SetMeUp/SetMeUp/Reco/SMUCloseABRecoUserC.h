//
//  SMUCloseABRecoUserC.h
//  SetMeUp
//
//  Created by ArulRaj on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUCloseABRecoUserC : NSObject

@property (nonatomic,strong) NSString *connectionid;
@property (nonatomic,strong) NSString *first_name;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *last_name;
@property (nonatomic,strong) NSString *name;

-(void)setRecoABUserCDictionary:(NSDictionary *)dictionary;
@end
