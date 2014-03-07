//
//  SMUCongrats.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/29/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCongrats.h"

@implementation SMUCongrats
-(void)setConnectedUserFromDict:(NSDictionary *)dictionary{
    
    _access_token=[dictionary objectForKey:@"access_token"];
    _birthday = [dictionary objectForKey:@"birthday"];
    _c_frnd_show_confirm_ignore = [dictionary objectForKey:@"c_frnd_show_confirm_ignore"];
    _created = [dictionary objectForKey:@"created"];
    _domain_email = [dictionary objectForKey:@"domain_email"];
    _email = [dictionary objectForKey:@"email"];
    _first_name= [dictionary objectForKey:@"first_name"];
    _gender = [dictionary objectForKey:@"gender"];
    _userId = [dictionary objectForKey:@"id"];
        _img_exist = [[dictionary objectForKey:@"img_exist"]intValue];
 _is_mm = [[dictionary objectForKey:@"is_mm"]intValue];
     _is_smu_user = [[dictionary objectForKey:@"is_smu_user"]intValue];
      _last_name = [dictionary objectForKey:@"last_name"];
      _modified = [dictionary objectForKey:@"modified"];
      _name = [dictionary objectForKey:@"name"];
     _profile_pic_id = [dictionary objectForKey:@"profile_pic_id"];
      _relationship_status = [dictionary objectForKey:@"relationship_status"];
    
}
@end
