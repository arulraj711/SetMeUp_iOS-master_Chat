//
//  SMUConversationViewController.h
//  SetMeUp
//
//  Created by ArulRaj on 1/10/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMPullToRefreshManager.h"
//#import "HPGrowingTextView.h"
@interface SMUConversationViewController : UIViewController<MNMPullToRefreshManagerClient,UITextFieldDelegate> {
    NSString *jsonString,*selectedUser,*fbUserId,*fbAccessToken,*selectedName;
    NSMutableArray *sphBubbledata;
    UIView *containerView;
    // HPGrowingTextView *textView;
    UITextField *msgTextField;
}
- (IBAction)showLeftMenuPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong,nonatomic) IBOutlet UIButton *sendBtn;
//- (IBAction)sendBtn:(id)sender;
@property (nonatomic,strong) NSMutableArray *bubbleData;
@property (nonatomic,strong) NSString *fromUserId;
@property (nonatomic,strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *overlayUserBView;
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UITableView *sphChatTable;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Uploadedimage;
@property (weak, nonatomic) IBOutlet UIImageView *userCImageView;
@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (weak, nonatomic) IBOutlet UILabel *userBNameLabel;
@property (assign) NSInteger totalPageNo;
@property (assign) NSInteger currentPageNo;
@property (assign) NSInteger msgCount;

@end
