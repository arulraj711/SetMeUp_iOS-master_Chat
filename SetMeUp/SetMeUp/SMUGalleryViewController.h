//
//  SMUGalleryViewController.h
//  SetMeUp
//
//  Created by Fx on 09/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SMUFriendOfFriend;

@interface SMUGalleryViewController : UIViewController
@property (nonatomic,strong)SMUFriendOfFriend *aFOF;
@property (nonatomic,readwrite) NSInteger activeIndex;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end
