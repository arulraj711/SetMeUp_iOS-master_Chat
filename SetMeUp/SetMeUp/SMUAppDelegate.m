//
//  SMUAppDelegate.m
//  SetMeUp
//
//  Created by Go on 12/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUAppDelegate.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUSharedResources.h"
#import "SMULoggedInUserMenuViewController.h"
#import "SMUSharedReco.h"
#import "Reachability.h"

@implementation SMUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window.tintColor=appBaseTintUIColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ITSideMenuContainerViewController *container = (ITSideMenuContainerViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"SMUSetMeUpNavigationController"];
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:appBarTextUIColor, NSForegroundColorAttributeName,nil]];
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:43.0/255.0 green:40.0/255.0 blue:54.0/255.0 alpha:1.0]];
    
    SMULoggedInUserMenuViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMULoggedInUserMenuViewController"];
    leftSideMenuViewController.smuVC=[[navigationController viewControllers] objectAtIndex:0];
    UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SMUChatMenuViewController"];
    
    [container setLeftMenuViewController:leftSideMenuViewController];
    [container setRightMenuViewController:rightSideMenuViewController];
    [container setCenterViewController:navigationController];
    
    
    //set appearance if required
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [self checkNetworkConn];
    
    
//    [SMUSharedReco sharedReco];
    return YES;
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{

// VERIFY THIS COMMENTED CODE RARE SCENARIO
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [[SMUSharedResources sharedResourceManager] sessionStateChanged:session state:state error:error];
    }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notification Methods
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken

{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"token :%@",token);
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:token];
    [def setObject:data1 forKey:@"deviceToken"];
    
   // [[SMUSharedResources sharedResourceManager] setRemoteNotificationDeviceToken:token];
    

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //NSLog(@"Failed to get device token, error: %@", [error localizedDescription]);
}

-(void)checkNetworkConn {
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(reachabilityChanged:)
    //                                                 name:kReachabilityChangedNotification
    //                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    __block bool isAvailable = NO;
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            isAvailable = NO;
            //NSLog(@"come noo");
            [self performSelector:@selector(delayAlert) withObject:nil afterDelay:5.0];
            
            // blockLabel.text = @"Block Says Unreachable";
        });
    };
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSLog(@"come true");
            //blockLabel.text = @"Block Says Reachable";
            // isAvailable = YES;
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Network Connected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //            [alert show];
        });
    };
    
    
    
    [reach startNotifier];
    
    //[[NSUserDefaults standardUserDefaults]setBool:isAvailable forKey:@"ISNETAVAILABLE"];
}
-(void)delayAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet available" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
//-(void)reachabilityChanged:(NSNotification*)note
//{
//    Reachability * reach = [note object];
//    bool isAvailable;
//    if(![reach isReachable])
//    {
//        isAvailable = YES;
//        _globalUsername = @"Yes";
//        NSLog(@"one");
//       // UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Network Not Connected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//       // [alert show];
//        //NSLog(@"oneeeee");
//        //notificationLabel.text = @"Notification Says Reachable";
//    }
//    else
//    {
//        isAvailable = NO;
//        _globalUsername = @"No";
//        NSLog(@"two");
//        //NSLog(@"twoooo");
//       // UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Network  Connected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        //[alert show];
//        // notificationLabel.text = @"Notification Says Unreachable";
//    }
//    [[NSUserDefaults standardUserDefaults]setBool:isAvailable forKey:@"ISNETAVAILABLE"];
//}


@end
