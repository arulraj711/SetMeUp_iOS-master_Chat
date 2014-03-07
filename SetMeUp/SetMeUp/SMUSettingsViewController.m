//
//  SMUSettingsViewController.m
//  SetMeUp
//
//  Created by ArulRaj on 1/20/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUSettingsViewController.h"
#import "SMUFeedBackViewController.h"
#import "StaticTableViewControllerProtocol.h"
#import "StaticTableParentProtocol.h"
@interface SMUSettingsViewController ()<UITableViewDelegate>
@property (nonatomic, strong) UITableView *menuListTableView;
@property (nonatomic, weak) UITableViewController <StaticTableViewControllerProtocol> *firstTableViewController;
@property (nonatomic, strong) NSString *feedBackMessage;
@end

@implementation SMUSettingsViewController

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
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLeftMenuPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fbButtonClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/SetMeUpapp"];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (IBAction)twButtonClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/SetMeUpApp"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)linkButtonClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.linkedin.com/company/2919858?trk=prof-exp-company-name"];
    [[UIApplication sharedApplication] openURL:url];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"settingembedSegue"]) {
        
        self.firstTableViewController = segue.destinationViewController;
       // self.firstTableViewController.delegate =self;
    }
    
}


@end
