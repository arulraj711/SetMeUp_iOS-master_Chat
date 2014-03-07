//
//  SMUPreviewViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUUserProfile.h"
#import  "UIImageView+WebCache.h"
@interface SMUPreviewViewController : UIViewController
- (IBAction)backButtonClick:(id)sender;
@property(nonatomic,strong)SMUUserProfile *userProfile;
@property (weak, nonatomic) IBOutlet UIImageView *previewImgView;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
