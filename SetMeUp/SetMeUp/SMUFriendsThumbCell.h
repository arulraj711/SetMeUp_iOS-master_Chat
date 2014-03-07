//
//  SMUFriendsThumbCell.h
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMUFriend;

@interface SMUFriendsThumbCell : UICollectionViewCell
@property(nonatomic,strong) SMUFriend *friendObject;
@property(nonatomic, readwrite) BOOL isMutualFriend;
@property(nonatomic, readwrite) BOOL displayOnlyPhoto;
@end
