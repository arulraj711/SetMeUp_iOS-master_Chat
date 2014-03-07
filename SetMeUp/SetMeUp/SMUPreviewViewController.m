//
//  SMUPreviewViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUPreviewViewController.h"
#import "SMUSharedResources.h"

@interface SMUPreviewViewController ()

@end

@implementation SMUPreviewViewController

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"pictureUrl"];
    NSString *picUrl = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
   // NSLog(@"url :%@",picUrl);
      _userProfile=[[SMUSharedResources sharedResourceManager] userProfile];
    NSURL *url=[NSURL URLWithString:picUrl];
    [_previewImgView setImageWithURL:url placeholderImage:nil];
    
    _navBar.title=[NSString stringWithFormat:@"%@",_userProfile.fullName];
    
    
    
    //NSLog(@"name of the User :%@",self.title);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
