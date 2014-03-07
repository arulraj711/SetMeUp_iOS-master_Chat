//
//  SMUInviteUserCViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMUInviteUserCViewController : UIViewController
{
       NSString *jsonString,*fbAccessToken,*userId;
}
@property(nonatomic,strong) UICollectionViewController *inviteUserCCollectionView;
@property(nonatomic,strong)NSMutableArray *inviteCUserDetails;

@property (weak, nonatomic) IBOutlet UILabel *userAName;

@property (weak, nonatomic) IBOutlet UIImageView *userAImageView;

- (IBAction)inviteButtonPressed:(id)sender;
- (IBAction)keepPlayingPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end
