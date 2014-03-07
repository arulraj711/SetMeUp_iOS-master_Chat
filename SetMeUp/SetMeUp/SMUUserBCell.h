//
//  SMUUserBCell.h
//  SetMeUp
//
//  Created by In on 24/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMUFriend;
@interface SMUUserBCell : UICollectionViewCell
@property (nonatomic, assign) SMUFriend *smuFriend;
@property(nonatomic, readwrite) BOOL isMutualFriend;

@end
