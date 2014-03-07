//
//  SMUUserAPicture.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/21/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUUserAPicture.h"

@implementation SMUUserAPicture


-(void)setProfilePictureWithDict:(NSDictionary *)dictionary{
    
    _picId=[dictionary objectForKey:@"fb_pic_id"];
    _album_id =[dictionary objectForKey:@"album_id"];
    _album_name=[dictionary objectForKey:@"album_name"];
    _picUrl=[dictionary objectForKey:@"pic_src"];
    _defaultUrl=[[dictionary objectForKey:@"default_url"] integerValue];
}
@end
