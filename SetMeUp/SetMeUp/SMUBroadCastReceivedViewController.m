//
//  SMUBroadCastReceivedViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/10/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUBroadCastReceivedViewController.h"
#import "SMUSharedReco.h"
#import "SMUBroadCastUser.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
#import "SMUUserProfile.h"
#import "ITSideMenuContainerViewController.h"

@interface SMUBroadCastReceivedViewController ()

@end

@implementation SMUBroadCastReceivedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSMutableArray *broadCastArray = [SMUSharedReco sharedReco].broadcastArray;
    
    [self showBroadCastDetails:broadCastArray];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showBroadCastDetails:(NSMutableArray *)array {
 
    SMUBroadCastUser *user = [array objectAtIndex:0];
    _userNameLbl.text = user.name;
    _messageTextView.text = user.message;
    
   // NSString *imgUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",user.a_user_id];
    [_userImageView setImageWithURL:[NSURL URLWithString:user.imgUrl] placeholderImage:nil];
    [SMUtils makeRoundedImageView:_userImageView withBorderColor:nil];
    _userImageView.contentMode=UIViewContentModeScaleAspectFill;
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    //NSLog(@"broadcast id:%@",user.broadCastId);
    
    [SMUWebServices changeBroadcastStatusWithAccessToken:fbAccessToken forUserId:fbUserId withType:@"Broadcast" withStatus:@"Accept" forUserId:user.broadCastId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //
     }];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    NSString *flag = @"LetsMeet";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}

- (IBAction)startChatting:(id)sender {
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    [shRes fetchChatConnUser];
    NSString *flag = @"LetsMeet";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
   // [self dismissViewControllerAnimated:YES completion:^{
        ITSideMenuContainerViewController *container = (ITSideMenuContainerViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        [container toggleRightSideMenuCompletion:nil];
   // }];
}
@end
