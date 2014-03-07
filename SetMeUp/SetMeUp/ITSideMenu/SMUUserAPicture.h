//
//  SMUUserAPicture.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/21/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUUserAPicture : NSObject


@property (nonatomic, strong) NSString *picId;
@property (nonatomic, strong) NSString *album_id;
@property (nonatomic, strong) NSString *album_name;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, readwrite) NSInteger defaultUrl;
-(void)setProfilePictureWithDict:(NSDictionary *)dictionary;
@end
