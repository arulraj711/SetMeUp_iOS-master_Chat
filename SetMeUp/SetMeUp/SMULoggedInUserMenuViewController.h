//
//  SMULoggedInUserMenuViewController.h
//  SetMeUp
//
//  Created by Go on 14/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticTableViewControllerProtocol.h"
#import "StaticTableParentProtocol.h"

@class SMUSetMeUpViewController;
@interface SMULoggedInUserMenuViewController : UIViewController<StaticTableParentProtocol>
- (IBAction)editButtonClick:(id)sender;
@property (nonatomic,strong)SMUSetMeUpViewController *smuVC;
@property(nonatomic,assign)NSInteger notificationCnt;
- (void)showLetsMeet;
-(void)showUserCPage;
-(void)showMM;
@end
