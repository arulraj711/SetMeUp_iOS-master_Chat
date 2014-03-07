//
//  SMUInterestsThumbCell.h
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUUserCInvite.h"
@class SMUInterest;

@interface SMUInterestsThumbCell : UICollectionViewCell
@property(nonatomic, strong) SMUInterest *aInterest;
@property(nonatomic,strong) SMUUserCInvite *userCObject;
@end
