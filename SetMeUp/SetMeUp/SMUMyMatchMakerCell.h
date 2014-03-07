//
//  SMUMyMatchMakerCell.h
//  SetMeUp
//
//  Created by In on 22/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMUFriend;
@interface SMUMyMatchMakerCell : UICollectionViewCell
@property (nonatomic, assign) SMUFriend *smuFriend;
@property(nonatomic, readwrite) BOOL isActiveMatchmaker;
@end
