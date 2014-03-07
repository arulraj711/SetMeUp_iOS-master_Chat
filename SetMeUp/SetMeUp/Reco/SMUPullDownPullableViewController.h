//
//  SMUPullDownPullableViewController.h
//  SetMeUp
//
//  Created by In on 01/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMUFriendOfFriend;
@interface SMUPullDownPullableViewController : UIViewController
@property (nonatomic,strong) SMUFriendOfFriend *friendOfFriend;

-(void)hideMatchMakersViewWithPercentage:(CGFloat)percent;
-(void)showMatchMakersViewWithPercentage:(CGFloat)percent;
-(IBAction)addMatchmakersClicked:(id)sender;
@end
