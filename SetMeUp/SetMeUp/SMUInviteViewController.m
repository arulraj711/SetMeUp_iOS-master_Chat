//
//  SMUInviteViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/5/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUInviteViewController.h"
#import "UIImageView+WebCache.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
@interface SMUInviteViewController ()

@end

@implementation SMUInviteViewController

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
	// Do any additional setup after loading the view.
    
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    [self loadViewWithDetials];
   
}
-(void)loadViewWithDetials{
    
    NSURL *url=[NSURL URLWithString:_inviteDetails.b_user_imgurl];
    
    [_userBImgView setImageWithURL:url placeholderImage:nil];
        _userBImgView.contentMode = UIViewContentModeScaleAspectFill;
    [SMUtils makeRoundedImageView:_userBImgView withBorderColor:appDefaultUserUIColor];
    
    NSURL *url1=[NSURL URLWithString:_inviteDetails.c_user_imgurl];
    
    [_userCImgView setImageWithURL:url1 placeholderImage:nil];
        _userCImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [SMUtils makeRoundedImageView:_userCImgView withBorderColor:appDefaultUserUIColor];
    
    _userBNameLabel.text=_inviteDetails.b_user_name;
    _userCNameLabel.text=_inviteDetails.c_user_name;
    
    NSString *title=[NSString stringWithFormat:@"Invite %@",_inviteDetails.b_user_name];
    [_inviteButton setTitle:title forState:UIControlStateNormal];
    _inviteButton.titleLabel.font=[UIFont systemFontOfSize:16];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonClicked:(id)sender {
       [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)inviteButtonPressed:(id)sender {
    
    [self createJSON];
     [self dismissViewControllerAnimated:YES completion:nil];
    [SMUWebServices inviteNonSmuUserWithAccessToken:fbAccessToken forUserId:userId toUserIds:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)createJSON {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_inviteDetails.messageTemplate forKey:_inviteDetails.b_user_id];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData){
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
}
- (IBAction)keepPlayingButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
