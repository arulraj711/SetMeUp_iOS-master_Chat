//
//  SMUInviteViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/5/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUInvite.h"
@interface SMUInviteViewController : UIViewController{
    NSString *jsonString,*fbAccessToken,*userId;
}
@property(nonatomic,strong)SMUInvite *inviteDetails;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButtonClicked;
- (IBAction)closeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userBNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userCNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userBImgView;
@property (weak, nonatomic) IBOutlet UIImageView *userCImgView;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

- (IBAction)inviteButtonPressed:(id)sender;

- (IBAction)keepPlayingButtonPressed:(id)sender;

@end
