//
//  SMULoginViewController.m
//  SetMeUp
//
//  Created by Go on 15/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMULoginViewController.h"
#import "SMULoginTutorialViewController.h"
#import "SMUSharedResources.h"
#import "SMUWebServices.h"
#import "SMUUserProfile.h"

@interface SMULoginViewController ()<UIPageViewControllerDataSource, SMULoginTutorialViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

static NSInteger _totalPages=5;
@implementation SMULoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"Login view did load");
    [super viewDidLoad];
    [self modifyBottomPageControl];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedIn) name:@"UserProfileInformationRetrieved" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [[SMUSharedResources sharedResourceManager] showProgressHUDForViewWithTitle:@"Useless Fact" withDetail:@"Researchers at the University of Chicago found that people were twice as likely to find a date through friends and family than through the bar scene."];
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [[SMUSharedResources sharedResourceManager] sessionStateChanged:session state:status error:error];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helpers
-(void)modifyBottomPageControl;
{
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
            [thisControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
            [thisControl setPageIndicatorTintColor:[UIColor darkGrayColor]];
        }
    }
//    Uncomment to hide the bottom page control
//    thisControl.hidden = true;
//    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);
}

-(SMULoginTutorialViewController*)viewControllerAtIndex:(NSInteger)pageIndex;
{
    if ((_totalPages == 0) || (pageIndex >= _totalPages)) {
        return nil;
    }
    SMULoginTutorialViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMULoginTutorialViewController"];
    pageContentViewController.pageIndex = pageIndex;
    pageContentViewController.delegate=self;
    return pageContentViewController;
}

-(void)userLoggedIn{
    //NSLog(@"userloggedin");
    //[self showTutorialView];
    [self dismissViewControllerAnimated:YES completion:NULL];
    [SMUSharedResources sharedResourceManager].isLoginPresented=NO;
    
}

//-(void)showTutorialView {
//    NSLog(@"showTutorialView");
//    NSString *fcTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"userCTutorialStatus"];
//    
//    // if([fcTutorialStatus isEqualToString:@"New"]) {
//    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
//    [_ghView setDataSource:self];
//    // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
//    self.ghView.floatingHeaderView = nil;
//    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
//    [self.view addSubview:self.ghView];
//    [self.ghView showInView:self.navigationController.view animateDuration:0.3];
//    NSString *fcTutorialStatus1 = @"Old";
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:fcTutorialStatus1 forKey:@"userCTutorialStatus"];
//    //}
//}

//#pragma mark - GHDataSource
//
//-(NSInteger) numberOfPages
//{
//    return 5;
//}
//
//- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
//{
//    // cell.title = [NSString stringWithFormat:@"This is page %ld", index+1];
//    //cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", index+1]];
//    // cell.desc = [self.descStrings objectAtIndex:index];
//}
//
//- (UIImage*) bgImageforPage:(NSInteger)index
//{
//    NSString* imageName =[NSString stringWithFormat:@"userc_tutorial%d",index+1];
//    UIImage* image = [UIImage imageNamed:imageName];
//    return image;
//}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
{
    NSUInteger index = ((SMULoginTutorialViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;
{
    NSUInteger index = ((SMULoginTutorialViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == _totalPages) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _totalPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Storyboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pageSeague"]) {
        self.pageViewController=(UIPageViewController *)segue.destinationViewController;
        self.pageViewController.dataSource = self;
        
        SMULoginTutorialViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}
#pragma mark - SMULoginTutorialViewControllerDelegate

-(void)loginButtonClickedInSMULoginTutorialViewController:(SMULoginTutorialViewController *)tutorialVc
{
    //[[SMUSharedResources sharedResourceManager] showProgressHUDForViewWithTitle:@"" withDetail:@"According to the U.S. census, there are 95.9 million unmarried people in the U.S. of which 47% are men and 53% are women."];

}

-(void)startOverButtonClickedInSMULoginTutorialViewController:(SMULoginTutorialViewController *)tutorialVc
{
    [_pageViewController setViewControllers:@[[self viewControllerAtIndex:3]]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:^(BOOL finished) {
                                     
                                 }];
    [_pageViewController setViewControllers:@[[self viewControllerAtIndex:2]]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:^(BOOL finished) {
                                     
                                 }];
    [_pageViewController setViewControllers:@[[self viewControllerAtIndex:1]]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:^(BOOL finished) {
                                     
                                 }];
    [_pageViewController setViewControllers:@[[self viewControllerAtIndex:0]]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:^(BOOL finished) {
                                     
                                 }];
}




- (IBAction)fbButtonPressed:(id)sender {
    
    NSString *fcTutorialStatus = @"New";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:fcTutorialStatus forKey:@"fcTutorialStatus"];
    
    NSString *appTutorialStatus = @"New";
    [def setObject:appTutorialStatus forKey:@"appTutorialStatus"];
    
    NSString *userCTutorialStatus = @"New";
    [def setObject:userCTutorialStatus forKey:@"userCTutorialStatuss"];
    
    NSString *recoAB1TutorialStatus = @"New";
    [def setObject:recoAB1TutorialStatus forKey:@"recoAB1TutorialStatus"];
    
    NSString *recoAB2TutorialStatus = @"New";
    [def setObject:recoAB2TutorialStatus forKey:@"recoAB2TutorialStatus"];
    
    NSString *checkinStatus = @"New";
    [def setObject:checkinStatus forKey:@"checkinTutorialStatus"];
    
    NSString *setmeupTutorialStatus = @"New";
    [def setObject:setmeupTutorialStatus forKey:@"setmeupTutorialStatus"];
    
    NSString *approveTutorialStatus = @"New";
    [def setObject:approveTutorialStatus forKey:@"approveTutorialStatus"];
    
    NSString *matchMatchAlert=@"New";
    [def setObject:matchMatchAlert forKey:@"matchMakerAlert"];
    
    NSString *mutualAlert=@"New";
    [def setObject:mutualAlert forKey:@"mutualAlert"];
    
    [[SMUSharedResources sharedResourceManager]showProgressHUDForView];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [[SMUSharedResources sharedResourceManager] sessionStateChanged:session state:status error:error];
        }];
    }
    else if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [[SMUSharedResources sharedResourceManager] sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil];
    }
    else {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info,xmpp_login"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [[SMUSharedResources sharedResourceManager] sessionStateChanged:session state:state error:error];
        }];
    }
}
@end
