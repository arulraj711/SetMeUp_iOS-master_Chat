//
//  SMUNoUserCViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/11/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUNoUserCViewController.h"
#import "SMUSetMeUpViewController.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "SMULoggedInUserMenuViewController.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUSharedResources.h"
#import "SMUWebServices.h"
#import "SMUAppDelegate.h"
@interface SMUNoUserCViewController ()

@end

@implementation SMUNoUserCViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addMMButtonPressed:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        ITSideMenuContainerViewController *container = (ITSideMenuContainerViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        
        SMULoggedInUserMenuViewController * loggedInUserMenuViewController = ( SMULoggedInUserMenuViewController *)container.leftMenuViewController;
        [loggedInUserMenuViewController showMM];
        [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
        
        //
    }];
    
}

@end
