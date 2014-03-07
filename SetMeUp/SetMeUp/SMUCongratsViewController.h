//
//  SMUCongratsViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/29/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "SMUSetMeUpViewController.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUSharedResources.h"
@interface SMUCongratsViewController : UIViewController{
    NSString *fbAccessToken,*fbUserId;
}
@property (nonatomic, strong) NSMutableArray *aUserDetails;
@property (nonatomic, strong) NSMutableArray *cUserDetails;

@property (weak, nonatomic) IBOutlet UIImageView *userAImageView;
@property (weak, nonatomic) IBOutlet UILabel *userAName;
@property (nonatomic,strong) NSString *connectionId;

@property (weak, nonatomic) IBOutlet UIImageView *userCImageView;
@property (weak, nonatomic) IBOutlet UILabel *userCName;
@property (nonatomic,strong)SMUSetMeUpViewController *smuVC;

- (IBAction)backButtonPressed:(id)sender;


- (IBAction)enterFC:(id)sender;


- (IBAction)startChatting:(id)sender;

@end
