//
//  SMULoggedInUserMenuViewController.m
//  SetMeUp
//
//  Created by Go on 14/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMULoggedInUserMenuViewController.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUSetMeUpViewController.h"
#import "SMUSharedResources.h"
#import "SMUMyMatchMakersViewController.h"
#import "SMUUserProfile.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"
#import "SMUUserAEditViewController.h"
#import "SMUSettingsViewController.h"
#import "SMUFirstConnectViewController.h"
#import "StaticTableViewControllerProtocol.h"
#import "StaticTableParentProtocol.h"
#import "SMUInternViewController.h"
#import "SMUSharedResources.h"
#import "SMURecoListViewController.h"
#import "SMURecentStatus.h"
@interface SMULoggedInUserMenuViewController () <UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) UITableViewController <StaticTableViewControllerProtocol> *firstTableViewController;
@property (nonatomic, weak) UITableViewController <StaticTableViewControllerProtocol> *secondTableViewController;
@property (nonatomic, strong) IBOutlet UIImageView *userProfileImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *userDetailsLabel1;
@property (nonatomic, strong) IBOutlet UILabel *userDetailsLabel2;
@property (nonatomic, strong) IBOutlet UILabel *userDetailsLabel3;
@property (nonatomic, strong) UITableView *signoutTableView;
@property (nonatomic, strong) UITableView *menuListTableView;
@property (nonatomic, strong) IBOutlet UIView *userDetailsView;
@end

@implementation SMULoggedInUserMenuViewController
SMUUserProfile *userProfileObj;
SMUSharedResources *shRes;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
      userProfileObj=[[SMUUserProfile alloc]init];
        shRes=[SMUSharedResources sharedResourceManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserProfileInformationRetrieved:) name:@"UserProfileInformationRetrieved" object:nil];
    [SMUtils makeRoundedImageView:_userProfileImageView withBorderColor:appOnlineUserUIColor];
    
    UITapGestureRecognizer *edittap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editButtonClick:)];
    
    edittap.numberOfTapsRequired = 1;
    
    [_userDetailsView addGestureRecognizer:edittap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecenStatusUpdated:) name:@"RecentStatusUpdated" object:nil];
    
}

- (void)didUserProfileInformationRetrieved:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    SMUUserProfile *userProfile = [userInfo objectForKey:@"UserProfile"];
    [userProfileObj saveCustomObject:userProfile key:@"UserInfo"];

    [self updateViewWithUserProfile:userProfile];
}

- (void)updateViewWithUserProfile:(SMUUserProfile *)userProfile
{
    if([userProfile isEqual:[NSNull null]])
    {
        return;
    }
    //NSLog(@"coming here");
    _userNameLabel.text = [userProfile getFullName];
    _userDetailsLabel1.text = userProfile.education;
    _userDetailsLabel2.text = userProfile.location;
    _userDetailsLabel3.text = userProfile.workplace;
    [SMUtils makeRoundedImageView:_userProfileImageView withBorderColor:nil];
    [_userProfileImageView setImageWithURL:[NSURL URLWithString:userProfile.profilePicture]];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:userProfile.profilePicture];
    [def setObject:data1 forKey:@"selectedProfilePicture"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didRecenStatusUpdated:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    SMURecentStatus *recentStatus = [userInfo objectForKey:@"RecentStatus"];
    //NSLog(@"after updating recent status:%d",recentStatus.bRecoCount);
    
    _notificationCnt = recentStatus.bRecoCount+recentStatus.cRecoCount;
    
    //[userProfileObj saveCustomObject:userProfile key:@"UserInfo"];
    
    // [self updateViewWithUserProfile:userProfile];
}


#pragma mark - Table view delegate
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row=indexPath.row;
    if ([tableView isEqual:_signoutTableView]) {
        UIAlertView *signOut=[[UIAlertView alloc] initWithTitle:@"Logout" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        signOut.tag=1661;
        [signOut show];
        [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
    }
    else if ([tableView isEqual:_menuListTableView])
    {
        UINavigationController *navigationController = (UINavigationController *)self.menuContainerViewController.centerViewController;
        switch (row) {
            case 0:
            {
                //Set me up
                if(![navigationController.viewControllers[0] isKindOfClass:[SMUSetMeUpViewController class]])
                {
                    if (_smuVC==nil) {
                        _smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
                    }
                    NSArray *controllers = [NSArray arrayWithObject:_smuVC];
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    navigationController.viewControllers = controllers;
                }
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 1:
            {
                //My Match Makers
                if(![navigationController.viewControllers[0] isKindOfClass:[SMUSetMeUpViewController class]])
                {
                    if (_smuVC==nil) {
                        _smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
                    }
                    NSArray *controllers = [NSArray arrayWithObject:_smuVC];
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    navigationController.viewControllers = controllers;
                }
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
                [_smuVC showMyMatchMakers];
            }
                break;
            case 2:
            {
                if(![navigationController.viewControllers[0] isKindOfClass:[SMUFirstConnectViewController class]])
                {
                     [self showLetsMeet];
//                    UIViewController *smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUFirstConnectViewController"];
//                    NSArray *controllers = [NSArray arrayWithObject:smuVC];
//                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//                    navigationController.viewControllers = controllers;
                }
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 3:
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Picture Me" message:@"Implementation in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 4:
            {
                UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUSettingsViewController"];
                [self presentViewController:navigationController animated:YES completion:nil];
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Settings" message:@"Implementation in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alert show];
//                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 5:
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Invite" message:@"Implementation in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 6:
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Who Referred You" message:@"Implementation in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            default:
                break;
        }
    }
}
*/

- (void) tableView: (UITableView *) tableView
         didSelect: (BOOL) select
   cellAtIndexPath: (NSIndexPath *)indexPath
 inViewController : (UIViewController <StaticTableViewControllerProtocol> *) viewController;
{
    UINavigationController *navigationController = (UINavigationController *)self.menuContainerViewController.centerViewController;

    NSInteger row=indexPath.row;
    if (viewController == self.secondTableViewController) {
        
        if(![navigationController.viewControllers[0] isKindOfClass:[SMUSetMeUpViewController class]])
        {
            if (_smuVC==nil) {
                _smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
            }
            NSArray *controllers = [NSArray arrayWithObject:_smuVC];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            navigationController.viewControllers = controllers;
        }
        [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
        UIAlertView *signOut=[[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Are you sure you want to log out from SetMeUp" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        signOut.tag=1661;
     [signOut show];
    
        
    }
    else if (viewController == self.firstTableViewController)
    {
        UINavigationController *navigationController = (UINavigationController *)self.menuContainerViewController.centerViewController;
        switch (row) {
            case 0:
            {
                //Set me up
                if(![navigationController.viewControllers[0] isKindOfClass:[SMUSetMeUpViewController class]])
                {
                    if (_smuVC==nil) {
                        _smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
                    }
                    NSArray *controllers = [NSArray arrayWithObject:_smuVC];
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    navigationController.viewControllers = controllers;
                }
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 1:
            {
                //My Match Makers
                if(![navigationController.viewControllers[0] isKindOfClass:[SMUSetMeUpViewController class]])
                {
                    if (_smuVC==nil) {
                        _smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
                    }
                    NSArray *controllers = [NSArray arrayWithObject:_smuVC];
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    navigationController.viewControllers = controllers;
                }
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
                [_smuVC showMyMatchMakers];
            }
                break;
            case 2:
            {
                if(![navigationController.viewControllers[0] isKindOfClass:[SMUFirstConnectViewController class]])
                {
                    UIViewController *smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUFirstConnectViewController"];
                    NSArray *controllers = [NSArray arrayWithObject:smuVC];
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    navigationController.viewControllers = controllers;
                }
                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 3:
            {
                if(_notificationCnt == 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Intro requests available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                } else {
                    if(![navigationController.viewControllers[0] isKindOfClass:[SMURecoListViewController class]])
                    {
                        UIViewController *smuVC1=[self.storyboard instantiateViewControllerWithIdentifier:@"SMURecoListViewController"];
                        NSArray *controllers = [NSArray arrayWithObject:smuVC1];
                        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                        navigationController.viewControllers = controllers;
                    }
                    [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
                }
            }
                break;
            case 4:
            {
                UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUSettingsViewController"];
                [self presentViewController:navigationController animated:YES completion:nil];
                //                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Settings" message:@"Implementation in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                //                [alert show];
                //                [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
            }
                break;
            case 5:
            {
                NSArray *Items   = [NSArray arrayWithObjects:
                                    @"Hey Check out our App at www.setmeupapp.com",nil];
                
                UIActivityViewController *ActivityView =
                [[UIActivityViewController alloc]
                 initWithActivityItems:Items applicationActivities:nil];
                [self presentViewController:ActivityView animated:YES completion:nil];
            }
                break;
            
            default:
                break;
        }
    }

}

- (void) tableView: (UITableView *) tableView
     clickedButton: (UIButton *) button
       atIndexPath: (NSIndexPath *) buttonIndexPath
  inViewController: (UITableViewController <StaticTableViewControllerProtocol>*) viewController;
{
            UINavigationController *navigationController = (UINavigationController *)self.menuContainerViewController.centerViewController;
    if(![navigationController.viewControllers[0] isKindOfClass:[SMUSetMeUpViewController class]])
    {
        if (_smuVC==nil) {
            _smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
        }
        NSArray *controllers = [NSArray arrayWithObject:_smuVC];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
    }
    [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
    [_smuVC showUserC];

   
    
    
}
#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag=[alertView tag];
    if (tag==1661&&buttonIndex==1) {
        [[SMUSharedResources sharedResourceManager] logoutFbUser];
        
        
        }
}
#pragma mark - StoryBoard delegate

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"embedContentStack1"]) {
//        UITableViewController *list1TableVC=(UITableViewController *)segue.destinationViewController;
//        _menuListTableView=(UITableView*)list1TableVC.view;
//        _menuListTableView.delegate=self;
//    }
//    else if ([segue.identifier isEqualToString:@"embedContentStack2"]) {
//        UITableViewController *list2TableVC=(UITableViewController *)segue.destinationViewController;
//        _signoutTableView=(UITableView*)list2TableVC.view;
//        _signoutTableView.delegate=self;
//    }
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedContentStack1"]) {
        
        self.firstTableViewController = segue.destinationViewController;
        self.firstTableViewController.delegate =self;
    }
    else if ([segue.identifier isEqualToString:@"embedContentStack2"]){
        self.secondTableViewController = segue.destinationViewController;
        self.secondTableViewController.delegate =self;
    }
    
}

- (void)showLetsMeet
{
    UIViewController *smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUFirstConnectViewController"];
    NSArray *controllers = [NSArray arrayWithObject:smuVC];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    navigationController.viewControllers = controllers;
 
   
}
-(void)showMM{
   // NSLog(@"after showing mm page");
    [_smuVC showMyMatchMakers];
}
-(void)showUserCPage{
    UIViewController *smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpViewController"];
    NSArray *controllers = [NSArray arrayWithObject:smuVC];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    navigationController.viewControllers = controllers;
//    [self.menuContainerViewController setMenuState:ITSideMenuStateClosed];
//    [shRes fetchInitialFOFList];
}

//-(void)showChatPage {
//    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUUserAEditViewController"];
//    [self presentViewController:navigationController animated:YES completion:nil];
//}


- (IBAction)editButtonClick:(id)sender {
    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUUserAEditViewController"];
    [self presentViewController:navigationController animated:YES completion:nil];
}
@end
