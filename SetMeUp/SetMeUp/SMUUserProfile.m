//
//  SMUUserProfile.m
//  SetMeUp
//
//  Created by Go on 17/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//


//================================================================
//******************** EXPECTED SERVICE MODEL ********************
//================================================================
/*

{
    "FC_Status" = 0;
    approveInfo =  ( {user_id=""; first_name=""; last_name=""; approve_count=13213; profile_pic_id:""} );
    code = 100;
    message = "User Informations";
    "profile_info" =         {
        internStatus = 0;
        first_name = "Arul";
        last_name = "Raj"
        "profile_pic_id" = "https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-ash3/s720x720/600335_572522169434280_2067164546_n.jpg";
        udob = "10-22-2013";
        ueducation = "St.Xaviers College";
        ulocation = "Chennai, Tamil Nadu";
        "user_id" = 100000295066984;
        uworkplace = "Compvue Incfdhgfh";
    };
    "user_status" = "User Already exists";
};

*/
//================================================================
//================================================================


#import "SMUUserProfile.h"
#import "SMUFriend.h"

@interface SMUUserProfile ()
{
    NSString *_fullName;
}
@end

@implementation SMUUserProfile

- (void)setUserProfileWithDict:(NSDictionary*)dictionary
{
    NSDictionary *profileInfo=[dictionary objectForKey:@"profile_info"];
    NSArray *approveFriendArr=[dictionary objectForKey:@"approveInfo"];
    
    _firstConnectStatus =   [[dictionary objectForKey:@"FC_Status"] integerValue];
    _internStatus   = [[profileInfo objectForKey:@"internStatus"] integerValue];
    _firstName  =   [profileInfo objectForKey:@"first_name"];
    _lastName   =   [profileInfo objectForKey:@"last_name"];
    _profilePicture =   [profileInfo objectForKey:@"profile_pic_id"];
    _dateOfBirth=   [profileInfo objectForKey:@"udob"];
    _education  =   [profileInfo objectForKey:@"ueducation"];
    _location   =   [profileInfo objectForKey:@"ulocation"];
    _userID     =   [profileInfo objectForKey:@"user_id"];
    
    
    _workplace  =   [profileInfo objectForKey:@"uworkplace"];
    NSMutableArray *collectionArr=[NSMutableArray array];
    if([approveFriendArr isKindOfClass:[NSArray class]])
    {
        for (int i=0; i< [approveFriendArr count]; i++) {
            SMUFriend *aUserFriend=[[SMUFriend alloc] init];
            [aUserFriend setFriendDetailsWithDict:[approveFriendArr objectAtIndex:i]];
            [collectionArr addObject:aUserFriend];
        }
    }

    _approveUserFriends=[NSArray arrayWithArray:collectionArr];
}

-(NSString*)getFullName{
    if (_fullName==nil) {
        _fullName=[SMUtils getFullNameWithFirstName:_firstName withLastName:_lastName];
    }
    return _fullName;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //NSLog(@"coming into encodewithcoder");
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.firstName forKey:@"first_name"];
    [encoder encodeObject:self.lastName forKey:@"last_name"];
    [encoder encodeObject:self.education forKey:@"ueducation"];
    [encoder encodeObject:self.workplace forKey:@"uworkplace"];
    [encoder encodeObject:self.dateOfBirth forKey:@"udob"];
    [encoder encodeObject:self.location forKey:@"ulocation"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    //NSLog(@"coming into initwithcoder");
    if((self = [super init])) {
        //decode properties, other class vars
        self.firstName = [decoder decodeObjectForKey:@"first_name"];
        self.lastName=[decoder decodeObjectForKey:@"last_name"];
        self.education = [decoder decodeObjectForKey:@"ueducation"];
        self.workplace = [decoder decodeObjectForKey:@"uworkplace"];
        self.location = [decoder decodeObjectForKey:@"ulocation"];
        self.dateOfBirth = [decoder decodeObjectForKey:@"udob"];
    }
    return self;
}

- (void)saveCustomObject:(SMUUserProfile *)object key:(NSString *)key {
    
    //NSLog(@"triggering saveCustomObject");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    [defaults setObject:encodedObject forKey:key];
   
}

- (SMUUserProfile *)loadCustomObjectWithKey:(NSString *)key {
    //NSLog(@"coming into loadCustomObject");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    SMUUserProfile *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}


@end
