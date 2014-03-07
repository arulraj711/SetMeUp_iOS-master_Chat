//
//  SMUPullDownViewController.h
//  SetMeUp
//
//  Created by Fx on 21/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMUFriendOfFriend;
@interface SMUPullDownViewController : UIViewController
{
    int indexPathVar;
}
@property (nonatomic,strong) SMUFriendOfFriend *friendOfFriend;
@property(nonatomic,readwrite) BOOL isCommon;

-(void)hideMatchMakersViewWithPercentage:(CGFloat)percent;
-(void)showMatchMakersViewWithPercentage:(CGFloat)percent;
-(IBAction)addMatchmakersClicked:(id)sender;
@end
