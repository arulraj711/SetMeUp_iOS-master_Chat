//
//  SMUFriendOfFriend.m
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUFriendOfFriend.h"
#import "SMUFriend.h"
#import "SMUInterest.h"
#import "SMUPhoto.h"
#import "SDWebImageManager.h"

@interface SMUFriendOfFriend ()
{
    NSString *_fullName;
}
@end

@implementation SMUFriendOfFriend

-(void)setUserCDetailsFromDictionary:(NSDictionary *)dictionary
{
    _userID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"c_user_id"]];
    _age = [[dictionary objectForKey:@"age"] integerValue];
    _collegeName = [dictionary objectForKey:@"college_name"];
    _educationYear = [dictionary objectForKey:@"education_year"];
    _first_name = [dictionary objectForKey:@"first_name"];
    _heartRate=[[dictionary objectForKey:@"heart_rate"] integerValue];
    _home_town = [dictionary objectForKey:@"home_town"];

    //  Interest
    NSArray *interestArray = [dictionary objectForKey:@"interest"];
    NSMutableArray *userInterests=[NSMutableArray array];
    if([interestArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in interestArray) {
            SMUInterest *interest=[[SMUInterest alloc] init];
            [interest setInterestFromDictionary:dic];
            [userInterests addObject:interest];
        }
    }
    _interests=[NSArray arrayWithArray:userInterests];

    _last_name = [dictionary objectForKey:@"last_name"];
    _location = [dictionary objectForKey:@"location"];
    _mutualInterestCount = [[dictionary objectForKey:@"mutual_interest_count"]intValue];
    _profileImage=[dictionary objectForKey:@"profile_image_url"];
    
//#warning DEV NOTE: To save your bandwidth comment the below UserC profile download module, uncomment only in customer release
    // ========= UserC profile download ===========//
    // Triggers userc profile image download in background with low priority and disk cache
    // if already downlaoded cache will discard the service call
    // but beware this eats your network data higher than wat you expect ;)
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:_profileImage] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
    }];
    
    //========= UserC profile download ===========//
    
    _approveStatus=[[dictionary objectForKey:@"user_c_approve_status"] integerValue];

    //  Mutual Friend
    NSMutableArray *mutualUser =[NSMutableArray array];
    NSArray *mutualFriendsArray = [dictionary objectForKey:@"user_c_mutual_friend"];
    if([mutualFriendsArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dic in mutualFriendsArray)
        {
            SMUFriend *friend=[[SMUFriend alloc] init];
            friend.name = [dic valueForKeyPath:@"name"];
            friend.userID = [dic valueForKeyPath:@"friend_id"];
            friend.profilePicture=[dic valueForKeyPath:@"profile_thumb"];
            [mutualUser addObject:friend];
        }
    }
    _mutualFriends=[NSArray arrayWithArray:mutualUser];
    _mutualFriendsCount = [[dictionary objectForKey:@"user_c_mutual_friend_cnt"] intValue];

    //  Photos
    NSArray *photosArray = [dictionary objectForKey:@"user_c_org_pic_album"];
    NSMutableArray *userPhotos=[NSMutableArray array];
    if([photosArray isKindOfClass:[NSArray class]])
    {
        for (NSString *photoUrl in photosArray) {
            SMUPhoto *photo=[[SMUPhoto alloc] init];
            photo.photoURLstring=photoUrl;
            [userPhotos addObject:photo];
        }
    }
    _photos=[NSArray arrayWithArray:userPhotos];
    _workPlace = [dictionary objectForKey:@"work_place"];
    
}

-(NSString*)fullName{
    if (_fullName==nil) {
        _fullName=[SMUtils getFullNameWithFirstName:_first_name withLastName:_last_name];
    }
    return _fullName;
}

@end
