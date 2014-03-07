//
//  SMUCongratsViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/29/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCongratsViewController.h"
#import "SMUCongrats.h"
#import "SMUSharedReco.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "SMULoggedInUserMenuViewController.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUSharedResources.h"
#import "SMUWebServices.h"
@interface SMUCongratsViewController ()

@end

@implementation SMUCongratsViewController
SMUCongrats *userAObj,*userCObj;
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
    [super viewDidLoad];
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    
    
	// Do any additional setup after loading the view.
    [self configureView];
   }
-(void)configureView{
    
    _aUserDetails=[[SMUSharedReco sharedReco] aUserForCongrats];
    _cUserDetails=[[SMUSharedReco sharedReco]cUserForCongrats];
    
    userAObj=(SMUCongrats *)[_aUserDetails objectAtIndex:0];
    //NSLog(@"Congrats name:%@",userAObj.name);
    //NSLog(@"user a Ids:%@",userAObj.userId);
    //NSLog(@"user b Id:%@",userCObj.userId);
   // NSLog(@"user c name:%@",userCObj.name);
    
    _userAName.text=userAObj.name;
    
    //connMatchID
  
    NSString *connId=[[NSUserDefaults standardUserDefaults] objectForKey:@"connMatchID"];
    
    [SMUtils makeRoundedImageView:_userAImageView withBorderColor:appDefaultUserUIColor];
    
    userCObj=(SMUCongrats *)[_cUserDetails objectAtIndex:0];
    
    NSURL *url=[NSURL URLWithString:userAObj.profile_pic_id];
    
   [_userAImageView setImageWithURL:url placeholderImage:nil];
    
       _userAImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    [SMUtils makeRoundedImageView:_userCImageView withBorderColor:appDefaultUserUIColor];
    
        _userCImageView.contentMode=UIViewContentModeScaleAspectFill;
    _userCName.text=userCObj.name;
    

      if((NSNull *)userCObj.profile_pic_id == [NSNull null]) {
           NSURL *url1=[NSURL URLWithString:@""];
             [_userCImageView setImageWithURL:url1 placeholderImage:nil];
          
      }else{
           NSURL *url1=[NSURL URLWithString:userCObj.profile_pic_id];
             [_userCImageView setImageWithURL:url1 placeholderImage:nil];
      }
    
    
    
    [SMUWebServices changeCongratsStatus:fbAccessToken forUserId:fbUserId type:@"firstConnect" userAId:userAObj.userId userCId:userCObj.userId connectionId:connId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonPressed:(id)sender {
    NSString *flag = @"Congrats";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
      //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)enterFC:(id)sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    [shRes fetchChatConnUser];
    NSString *flag = @"Congrats";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
   // [self dismissViewControllerAnimated:YES completion:^{
        ITSideMenuContainerViewController *container = (ITSideMenuContainerViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        
        SMULoggedInUserMenuViewController * loggedInUserMenuViewController = ( SMULoggedInUserMenuViewController *)container.leftMenuViewController;
        [loggedInUserMenuViewController showLetsMeet];
        [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
    //}];
    
}

- (IBAction)startChatting:(id)sender {
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    [shRes fetchChatConnUser];
    NSString *flag = @"Congrats";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
   // [self dismissViewControllerAnimated:YES completion:^{
        ITSideMenuContainerViewController *container = (ITSideMenuContainerViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        [container toggleRightSideMenuCompletion:nil];
   // }];
   
}
@end
