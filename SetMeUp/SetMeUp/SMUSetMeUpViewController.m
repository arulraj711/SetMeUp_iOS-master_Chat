//
//  SMUSetMeUpViewController.h
//  SetMeUp
//
//  Created by Indi on 12/19/13.
//  Copyright (c) 2013 Indi Technologies. All rights reserved.
//

#import "SMUSetMeUpViewController.h"
#import "SMUSharedResources.h"
#import "ITSideMenu.h"
#import "SMUFriendOfFriend.h"
#import "SMUPullDownViewController.h"
#import "SMUWebServices.h"
#import "SMUFriend.h"
#import "UIImageView+WebCache.h"
#import "SMUUserProfile.h"
#import "UIImage+ImageEffects.h"
#import "SMUGalleryViewController.h"
#import "UIImage+BoxBlur.h"
#import "SMUSharedReco.h"
#import "SMUInvite.h"
#import "SMUInviteViewController.h"
#import "SMURecentStatus.h"
#import "SMUGalleryViewController.h"
#import "SMUConfirmApproveViewController.h"
#import "SMUBannerView.h"
#import "SMUHomeMessage.h"
//#import "SMUUpdateUserLocation.h"
@interface UIView (SymbolNotPublicInSeed1)
// This method was implemented in seed 1 but the symbol was not made public. It will be public in seed 2.
- (BOOL)drawViewHierarchyInRect:(CGRect)rect;
@end
@interface SMUSetMeUpViewController () <UIScrollViewDelegate>

@property(nonatomic,strong) IBOutlet UIScrollView *friendOfFriendScroller;
@property(nonatomic,strong) IBOutlet UIButton *approveButton;
@property(nonatomic,strong) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet UIImageView *toolsBlurImageView;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *toolbarBottomContraint;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIView *rightView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIView *setMeUpIndicatorView;
@property(nonatomic,strong) UIView *ignoreIndicatorView;
@property(nonatomic,strong) UIView *approveIndicatorView;
@property(nonatomic,strong) UIView *backIndicatorView;
@property(nonatomic,strong) UIView *nextIndicatorView;
@property(nonatomic) CGPoint centerOffset;
@property(nonatomic,strong) SMUPullDownViewController *smuPullDownVC;
@property (nonatomic,strong) SMUBannerView *bannerView;
   @property (nonatomic,strong) NSMutableArray *chatListArray;
@property (nonatomic, strong) NSMutableArray *friendsRef,*friendOfFriendsRef,*matchMakersRef;
@property (nonatomic, readwrite) BOOL isViewSetUp;
@property (nonatomic, readwrite) NSInteger currentFofIndex;
@property (nonatomic, readwrite) NSInteger swipeCounter;


- (IBAction)showLeftMenuPressed:(id)sender;
- (IBAction)showRightMenuPressed:(id)sender;
- (IBAction)setMeUpButtonClicked:(id)sender;
- (IBAction)ignoreButtonClicked:(id)sender;
- (IBAction)approveButtonClicked:(id)sender;

- (void)setMeUpWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)ignoreWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)approveWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)disApproveWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)changeApproveButtonSelectedState:(BOOL)selected;
-(void)hideToolsView;
-(void)showToolsView;
@end

@implementation SMUSetMeUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self showAppTutorialView];

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        NSLog(@"coming into createtokenloaded");
        [[SMUSharedResources sharedResourceManager] showProgressHUDForViewWithTitle:@"" withDetail:@"Researchers at the University of Chicago found that people were twice as likely to find a date through friends and family than through the bar scene."];
        
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            NSLog(@"coming inside");
            [[SMUSharedResources sharedResourceManager] sessionStateChanged:session state:status error:error];
        }];
    }
    else if (!([FBSession activeSession].state==FBSessionStateOpen || [FBSession activeSession].state==FBSessionStateOpenTokenExtended)) {
         NSLog(@"coming into notloaded and opened");
        [[SMUSharedResources sharedResourceManager] presentLogin];
    }
    
    _approveTutorialView.hidden = YES;
    [_friendOfFriendScroller addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useLessView:) name:@"showColoredBackgroud" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithFOFData) name:@"UserFOFListRetrieved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithUpdatedFOFData) name:@"UserFOFListUpdated" object:nil];
    _isViewSetUp=NO;
    _swipeCounter=0;
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecenStatusUpdated:) name:@"RecentStatusUpdated" object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noUserCFound:) name:@"noUserCFound" object:nil];
    _setmeupTutorialView.hidden = YES;
    
    //_toolsView.hidden = YES;

    

    
}

-(void)noUserCFound:(id)sender{
    
    [self hideUseLessView];
    
}
//-(void)useLessViewTwo:(id)sender{
//    
//    [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
//    [[SMUSharedResources sharedResourceManager] showProgressHUDForViewWithTitle:@"Useless Fact" withDetail:@"Researchers at the University of Chicago found that people were twice as likely to find a date through friends and family than through the bar scene."];
//    [self useLessFactView];
//}
-(void)useLessView:(id)sender{
    
      [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
    [[SMUSharedResources sharedResourceManager] showProgressHUDForViewWithTitle:@"Useless Fact" withDetail:@"Researchers at the University of Chicago found that people were twice as likely to find a date through friends and family than through the bar scene."];
    [self useLessFactView];
}
- (void)didRecenStatusUpdated:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    SMURecentStatus *recentStatus = [userInfo objectForKey:@"RecentStatus"];
   // NSLog(@"after updating recent status:%d",recentStatus.bRecoCount);
    
    int notificationCnt = recentStatus.bRecoCount+recentStatus.cRecoCount;
    if(notificationCnt > 0) {
    NSString *notificationStr = [NSString stringWithFormat:@"%d",notificationCnt];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"left_menu_navicon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLeftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 20, 30)];
        UIImageView *notificationImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, -5, 20, 20)];
        
        UIImage *notificationImage = [UIImage squareImageWithColor:[UIColor redColor] dimension:CGSizeMake(30.0, 30.0)];
        notificationImg.image = notificationImage;
        [SMUtils makeRoundedImageView:notificationImg withBorderColor:[UIColor clearColor]];
        
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    [label setText:notificationStr];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
        [notificationImg addSubview:label];
    [button addSubview:notificationImg];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    } else {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"left_menu_navicon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showLeftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, 20, 30)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    //[userProfileObj saveCustomObject:userProfile key:@"UserInfo"];
    
    // [self updateViewWithUserProfile:userProfile];
}


-(void)viewDidAppear:(BOOL)animated
{
   
    [self.menuContainerViewController setPanMode:ITSideMenuPanModeDefault];
    if (!_isViewSetUp) {
        CGRect frame=CGRectMake(0, 0, 187, 258);
        _setMeUpIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_setMeUpIndicatorView setBackgroundColor:[UIColor clearColor]];
        _setMeUpIndicatorView.center=self.view.center;
        _setMeUpIndicatorView.alpha=0.0;
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:frame];
        [imgView setImage:[UIImage imageNamed:@"approve_action"]];
        [_setMeUpIndicatorView addSubview:imgView];
        [self.view addSubview:_setMeUpIndicatorView];

        
        
        _approveIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_approveIndicatorView setBackgroundColor:[UIColor clearColor]];
        _approveIndicatorView.center=self.view.center;
        _approveIndicatorView.alpha=0.0;
        UIImageView *imgView1=[[UIImageView alloc] initWithFrame:frame];
        [imgView1 setImage:[UIImage imageNamed:@"setmeup_act"]];
        [_approveIndicatorView addSubview:imgView1];
        [self.view addSubview:_approveIndicatorView];
        
        _ignoreIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_ignoreIndicatorView setBackgroundColor:[UIColor clearColor]];
        _ignoreIndicatorView.center=self.view.center;
        _ignoreIndicatorView.alpha=0.0;
        imgView=[[UIImageView alloc] initWithFrame:frame];
        [imgView setImage:[UIImage imageNamed:@"indicator_ignore"]];
        [_ignoreIndicatorView addSubview:imgView];
        [self.view addSubview:_ignoreIndicatorView];
        
        _backIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_backIndicatorView setBackgroundColor:[UIColor clearColor]];
        _backIndicatorView.center=self.view.center;
        _backIndicatorView.alpha=0.0;
        UIImageView *backImgView=[[UIImageView alloc] initWithFrame:frame];
        [backImgView setImage:[UIImage imageNamed:@"back"]];
        [_backIndicatorView addSubview:backImgView];
        [self.view addSubview:_backIndicatorView];
        
        _nextIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_nextIndicatorView setBackgroundColor:[UIColor clearColor]];
        _nextIndicatorView.center=self.view.center;
        _nextIndicatorView.alpha=0.0;
        UIImageView *nextImgView=[[UIImageView alloc] initWithFrame:frame];
        [nextImgView setImage:[UIImage imageNamed:@"next_act"]];
        [_nextIndicatorView addSubview:nextImgView];
        [self.view addSubview:_nextIndicatorView];
        
        [self setUpScrollerWithViews];
        [self addPullDownView];
        _isViewSetUp=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)showAppTutorialView {
    _pageName = @"AppPage";
   // [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
    NSString *appTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"appTutorialStatus"];
    
    //NSLog(@"App tutorial status:%@",appTutorialStatus);
    
    if([appTutorialStatus isEqualToString:@"New"]) {
        NSString *fcTutorialStatus1 = @"Old";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:fcTutorialStatus1 forKey:@"appTutorialStatus"];
        _ghView = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
        _ghView.pageName = @"AppTutorial";
        [_ghView setDataSource:self];
        [_ghView setDelegate:self];
        // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        self.ghView.floatingHeaderView = nil;
        [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        [self.view addSubview:self.ghView];
        [self.ghView showInView:self.navigationController.view animateDuration:0.3];
//        
    } else {
       // [self showUserCTutorial];
    }
}

- (void)walkthroughDidDismissView:(GHWalkThroughView *)walkthroughView {
   // NSLog(@"after dismiss tutorial view");
    [self showUserCTutorial];
}

-(void)showUserCTutorial {
    _pageName = @"UserC";
    //NSLog(@"showUserCTutorial");
    NSString *userCTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"userCTutorialStatuss"];
    //NSLog(@"userCTutorial Status:%@",userCTutorialStatus);
    if([userCTutorialStatus isEqualToString:@"New"]) {
        NSString *fcTutorialStatus1 = @"Old";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:fcTutorialStatus1 forKey:@"userCTutorialStatuss"];
    _ghView1 = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
    _ghView1.pageName = @"UserCTutorial";
    [_ghView1 setDataSource:self];
    // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    self.ghView1.floatingHeaderView = nil;
    [self.ghView1 setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    [self.view addSubview:self.ghView1];
    [self.ghView1 showInView:self.navigationController.view animateDuration:0.3];
    }
}

-(void)showApproveTutorial {
    _pageName = @"ApproveStatus";
    NSString *userCTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"approveTutorialStatus"];
    if([userCTutorialStatus isEqualToString:@"New"]) {
        NSString *fcTutorialStatus1 = @"Old";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:fcTutorialStatus1 forKey:@"approveTutorialStatus"];
        _ghView1 = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
        [_ghView1 setDataSource:self];
        // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        self.ghView1.floatingHeaderView = nil;
        [self.ghView1 setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        [self.view addSubview:self.ghView1];
        [self.ghView1 showInView:self.navigationController.view animateDuration:0.3];
    }
}

#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    int count;
    if([_pageName isEqualToString:@"AppPage"]) {
        count = 3;
    } else if([_pageName isEqualToString:@"UserC"]) {
        count = 2;
    } else  {
        count = 1;
    }
    return count;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    // cell.title = [NSString stringWithFormat:@"This is page %ld", index+1];
    //cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", index+1]];
    // cell.desc = [self.descStrings objectAtIndex:index];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName;
    if([_pageName isEqualToString:@"AppPage"]) {
      //  NSLog(@"page index:%d",index);
//        if(index == 2) {
//            _ghView.sampleView.hidden = NO;
//        } else {
//             _ghView.sampleView.hidden = YES;
//        }
        imageName =[NSString stringWithFormat:@"app_tutorial%d",index+1];
    } else if([_pageName isEqualToString:@"UserC"]) {
        imageName =[NSString stringWithFormat:@"userc_tutorial%d",index+1];
    } else if([_pageName isEqualToString:@"ApproveStatus"]) {
        imageName =[NSString stringWithFormat:@"userc_tutorial3"];
    }
    
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (void)prepareViewsWithFOFData;
{
    [self showAppTutorialView];
    [SMUSharedReco sharedReco];
   // [SMUUpdateUserLocation updateLocation];
    _friendsRef=[SMUSharedResources sharedResourceManager].friends;
    _friendOfFriendsRef=[SMUSharedResources sharedResourceManager].friendOfFriendsList;
    _matchMakersRef=[SMUSharedResources sharedResourceManager].matchMakers;
    _currentFofIndex=0;
    [self setupViewsWithFOF];
}

- (void)prepareViewsWithUpdatedFOFData;
{
    [SMUSharedReco sharedReco];
    _friendsRef=[SMUSharedResources sharedResourceManager].friends;
    _friendOfFriendsRef=[SMUSharedResources sharedResourceManager].friendOfFriendsList;
    _matchMakersRef=[SMUSharedResources sharedResourceManager].matchMakers;
    [self setupViewsWithFOF];
}

-(void)showUserC{
    //NSLog(@"setting button clicked");
    
    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUSearchToolViewController"];
    
    [self presentViewController:navigationController animated:YES completion:^{
        
        
        
    }];

}
-(void)showMyMatchMakers
{
    [_smuPullDownVC addMatchmakersClicked:nil];
}

#pragma mark- FOF Setters

-(void)setupViewsWithFOF
{
    //NSLog(@"coming here");
    //[self showUserCTutorial];
    [self hideUseLessView];
    [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
    if([_friendOfFriendsRef count]<=_currentFofIndex){
    //fof array is being accesed beyond the total FOF
        [[SMUSharedResources sharedResourceManager] endOflistingReachedInUserC];
        return;
    }
    SMUFriendOfFriend *aFOF=_friendOfFriendsRef[_currentFofIndex];
    [_smuPullDownVC setFriendOfFriend:aFOF];
    if (aFOF.age) {
        self.title=[NSString stringWithFormat:@"%@, %ld",aFOF.first_name,(long)aFOF.age];
    }
    else
    {
        self.title=aFOF.first_name;
    }
    [self changeApproveButtonSelectedState:aFOF.approveStatus];
    [self setImagesWithIndex:_currentFofIndex];
}

-(void)loadNextFOF
{
    if([_friendOfFriendsRef count]<=_currentFofIndex){
        //fof array is being accesed beyond the total FOF
        [[SMUSharedResources sharedResourceManager] endOflistingReachedInUserC];
        return;
    }
    SMUFriendOfFriend *aFOF=_friendOfFriendsRef[_currentFofIndex];
    [_smuPullDownVC setFriendOfFriend:aFOF];
    if (aFOF.age) {
        self.title=[NSString stringWithFormat:@"%@, %ld",aFOF.first_name,(long)aFOF.age];
    }
    else
    {
        self.title=aFOF.first_name;
    }
    [self changeApproveButtonSelectedState:aFOF.approveStatus];
    [self setImagesWithIndex:_currentFofIndex];
}

-(void)loadPrevFOF
{
    if([_friendOfFriendsRef count]<=_currentFofIndex){
        //fof array is being accesed beyond the total FOF
        [[SMUSharedResources sharedResourceManager] endOflistingReachedInUserC];
        return;
    }
    SMUFriendOfFriend *aFOF=_friendOfFriendsRef[_currentFofIndex];
    [_smuPullDownVC setFriendOfFriend:aFOF];
    if (aFOF.age) {
        self.title=[NSString stringWithFormat:@"%@, %ld",aFOF.first_name,(long)aFOF.age];
    }
    else
    {
        self.title=aFOF.first_name;
    }
    [self changeApproveButtonSelectedState:aFOF.approveStatus];
    [self setImagesWithIndex:_currentFofIndex];
}

-(void)setImagesWithIndex:(NSInteger)imgIndex
{
    UIImageView *leftImgView=(UIImageView*)[_leftView viewWithTag:101];
    UIImageView *rightImgView=(UIImageView*)[_rightView viewWithTag:101];
    UIImageView *topImgView=(UIImageView*)[_topView viewWithTag:101];
    UIImageView *bottomImgView=(UIImageView*)[_bottomView viewWithTag:101];
    UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
    
    SMUFriendOfFriend *currFOF=_friendOfFriendsRef[_currentFofIndex];
    SMUFriendOfFriend *prevFOF;
    SMUFriendOfFriend *nextFOF;
    if (_currentFofIndex-1 >=0)
        prevFOF=_friendOfFriendsRef[_currentFofIndex-1];
    if ([_friendOfFriendsRef count]>_currentFofIndex+1)
        nextFOF=_friendOfFriendsRef[_currentFofIndex+1];
    
//    UIImage *prevImg=[UIImage imageNamed:@"car2"];
//    UIImage *currImg=[UIImage imageNamed:@"car1"];
//    UIImage *nextImg=[UIImage imageNamed:@"car2"];
    
    [centerImgView setImageWithURL:[NSURL URLWithString:currFOF.profileImage]];
    [_friendOfFriendScroller setContentOffset:_centerOffset animated:NO];
    [leftImgView setImageWithURL:[NSURL URLWithString:prevFOF.profileImage]];
    [rightImgView setImageWithURL:[NSURL URLWithString:nextFOF.profileImage]];
    [topImgView  setImageWithURL:[NSURL URLWithString:nextFOF.profileImage]];
    [bottomImgView setImageWithURL:[NSURL URLWithString:nextFOF.profileImage]];

    [self.toolsBlurImageView setBackgroundColor:[UIColor blackColor]];
    [self.toolsBlurImageView setAlpha:.5];
//    [self.toolsBlurImageView setImage:[self blurBackgroundImageToview:self.toolsView sourceBlurFromView:[self.toolsView superview]]];
}

#pragma mark- Pull Down Handlers

-(void)addPullDownView
{
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullDownTapGestureDetected:)];
    tapGestureRecognizer.numberOfTapsRequired=2;
    [_centerView addGestureRecognizer:tapGestureRecognizer];
    UIPanGestureRecognizer *panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pullDownPanGestureDetected:)];
    _smuPullDownVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUPullDownViewController"];
    [_smuPullDownVC.view addGestureRecognizer:panGestureRecognizer];
    [_smuPullDownVC.view setFrame:CGRectMake(0, -_smuPullDownVC.view.frame.size.height+kTopBarHeight+kMatchMakerBarVisibleHeight , _smuPullDownVC.view.frame.size.width, _smuPullDownVC.view.frame.size.height)];
    [self addChildViewController:_smuPullDownVC];
    [self.view addSubview:_smuPullDownVC.view];
}

-(void)pullDownTapGestureDetected:(UITapGestureRecognizer*)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        SMUFriendOfFriend *friendOF =_friendOfFriendsRef[_currentFofIndex];
        if ([friendOF.photos count]) {
            SMUGalleryViewController *galleryVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUGalleryVC"];
            galleryVC.aFOF=friendOF;
            galleryVC.activeIndex=0;
            [self.navigationController pushViewController:galleryVC animated:YES];
        }else
        {
            [self hideToolsView];
            UIView *fofDetailsView = _smuPullDownVC.view;
            [UIView animateWithDuration:0.3 animations:^{
                [fofDetailsView setFrame:CGRectMake(0, kTopBarHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
            } completion:^(BOOL finished) {
                [_smuPullDownVC hideMatchMakersViewWithPercentage:0];
                UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
                [centerImgView setImage:[self blurBackgroundImageToview:centerImgView sourceBlurFromView:[centerImgView superview]]];
            }];
        }
    }
}

-(void)pullDownPanGestureDetected:(UIPanGestureRecognizer*)gesture
{
    CGFloat velocityY=[gesture velocityInView:self.view].y;
    UIView *fofDetailsView = [gesture view];
    CGPoint translation = [gesture translationInView:[fofDetailsView superview]];
    if([gesture state] == UIGestureRecognizerStateBegan){
        if (translation.y>0 && (fofDetailsView.frame.origin.y+translation.y)<kTopBarHeight) {
            //pull down started
            [self hideToolsView];
        }
        else{
            //pull up started
            UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
            SMUFriendOfFriend *currFOF=_friendOfFriendsRef[_currentFofIndex];
            [centerImgView setImageWithURL:[NSURL URLWithString:currFOF.profileImage]];
        }
    }
    else if ([gesture state] == UIGestureRecognizerStateChanged){
        if (translation.y>0 && (fofDetailsView.frame.origin.y+translation.y)<kTopBarHeight) {
            //Pull down in progress
            [fofDetailsView setCenter:CGPointMake(fofDetailsView.center.x, fofDetailsView.center.y+translation.y)];
            
            float scrollDifference = fofDetailsView.frame.origin.y;
            float percentageTracked;
            percentageTracked = fabs(scrollDifference) * 100 / [[UIScreen mainScreen] bounds].size.height;
            [_smuPullDownVC hideMatchMakersViewWithPercentage:percentageTracked];
        }
        else if (translation.y<0 && (fofDetailsView.frame.origin.y+translation.y)>-fofDetailsView.frame.size.height+kTopBarHeight+kMatchMakerBarVisibleHeight){
            //pull up in progress
            [fofDetailsView setCenter:CGPointMake(fofDetailsView.center.x, fofDetailsView.center.y+translation.y)];
            float scrollDifference = - fofDetailsView.frame.origin.y;
            float percentageTracked;
            percentageTracked = fabs(scrollDifference) * 100 / [[UIScreen mainScreen] bounds].size.height;
            [_smuPullDownVC showMatchMakersViewWithPercentage:percentageTracked];
        }
        [gesture setTranslation:CGPointZero inView:[fofDetailsView superview]];
    }
    else if (gesture.state==UIGestureRecognizerStateEnded) {
        if (velocityY>0) {
            //pull down
            [UIView animateWithDuration:0.3 animations:^{
            [fofDetailsView setFrame:CGRectMake(0, kTopBarHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
            } completion:^(BOOL finished) {
                [_smuPullDownVC hideMatchMakersViewWithPercentage:0];
                UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
                [centerImgView setImage:[self blurBackgroundImageToview:centerImgView sourceBlurFromView:[centerImgView superview]]];
            }];
        }
        else if(velocityY<=0)
        {
            //pull up
            [UIView animateWithDuration:0.3 animations:^{
                [fofDetailsView setFrame:CGRectMake(0, -fofDetailsView.frame.size.height+kTopBarHeight+kMatchMakerBarVisibleHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
            } completion:^(BOOL finished) {
                [_smuPullDownVC showMatchMakersViewWithPercentage:100];
//                UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
//                SMUFriendOfFriend *currFOF=_friendOfFriendsRef[_currentFofIndex];
//                [centerImgView setImageWithURL:[NSURL URLWithString:currFOF.profileImage]];
            }];
            [self showToolsView];
        }
    }
    else if(gesture.state==UIGestureRecognizerStateCancelled||gesture.state==UIGestureRecognizerStateFailed)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [fofDetailsView setFrame:CGRectMake(0, -fofDetailsView.frame.size.height+kTopBarHeight+kMatchMakerBarVisibleHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
        } completion:^(BOOL finished) {
            [_smuPullDownVC showMatchMakersViewWithPercentage:100];
        }];
        [self showToolsView];
    }
}

#pragma mark - IBAction methods

- (IBAction)showLeftMenuPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)showRightMenuPressed:(id)sender {
    
    _chatListArray = [SMUSharedResources sharedResourceManager].chatConnUsersList;
    
    SMUHomeMessage *homeObj = (SMUHomeMessage *)[_chatListArray objectAtIndex:0];

    if([homeObj.connectedUser count]==0){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"SetMeUp" message:@"No Messages available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=101;
        [alert show];

        
    }else{
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
    }
}

- (IBAction)setMeUpButtonClicked:(id)sender{
    
    [_bannerView removeFromSuperview];
    _buttonFlag = @"setmeup";
//    [self.view addSubview:_setmeupTutorialView];
    NSString *setmeupTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"setmeupTutorialStatus"];
 
    if([setmeupTutorialStatus isEqualToString:@"New"]) {
        NSString *fcTutorialStatus1 = @"Old";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:fcTutorialStatus1 forKey:@"setmeupTutorialStatus"];
    [self.view bringSubviewToFront:_setmeupTutorialView];
        //_friendOfFriendScroller.hidden = YES;
        _toolsView.hidden = YES;
        _setmeupTutorialView.hidden = NO;
//          UIViewController *smuVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUConfirmApproveViewController"];
//        [self.view addSubview:smuVC.view];
    
        
    } else {
       // _friendOfFriendScroller.hidden = NO;
        _toolsView.hidden = NO;
        _setmeupTutorialView.hidden = YES;
        [UIView animateWithDuration:0.7 animations:^{
            [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:NO];
        } completion:^(BOOL finished) {
            [self scrollViewDidEndDecelerating:_friendOfFriendScroller];
            
        }];
    }
    
   
    
    
   
//    [self setMeUpWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
//    [self loadNextFOF];
//    [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:YES];
//    [UIView animateWithDuration:0.3 animations:^{
//        [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:NO];
//    } completion:^(BOOL finished) {
//        [self scrollViewDidEndDecelerating:_friendOfFriendScroller];
//    }];
    
}

- (IBAction)ignoreButtonClicked:(id)sender{
}

- (IBAction)approveButtonClicked:(id)sender{
//    UIButton *senderButton=(UIButton*)sender;
//    SMUFriendOfFriend *aFOF=[_friendOfFriendsRef objectAtIndex:_currentFofIndex];
//    if (senderButton.selected) {
//        [self disApproveWithFriendOfFriend:aFOF];
//        [aFOF setApproveStatus:0];
//        [self changeApproveButtonSelectedState:aFOF.approveStatus];
//    }
//    else{
//        [self approveWithFriendOfFriend:aFOF];
//        [aFOF setApproveStatus:1];
//        [self changeApproveButtonSelectedState:aFOF.approveStatus];
//    }
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:NO];
//    } completion:^(BOOL finished) {
//        [self scrollViewDidEndDecelerating:_friendOfFriendScroller];
//        
//    }];
    _buttonFlag = @"approve";
    [UIView animateWithDuration:0.7 animations:^{
        [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:NO];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:_friendOfFriendScroller];
    }];
}

#pragma mark - Helper methods

-(void)resetIndicators
{
    if (!(_friendOfFriendScroller.isDragging||_friendOfFriendScroller.isDecelerating||_friendOfFriendScroller.isTracking)) {
        _setMeUpIndicatorView.alpha=0.0;
        _ignoreIndicatorView.alpha=0.0;
        _approveIndicatorView.alpha=0.0;
        _backIndicatorView.alpha=0.0;
        _nextIndicatorView.alpha=0.0;
        return ;
    }
    [self performSelector:@selector(resetIndicators) withObject:nil afterDelay:.3];
}

- (void)setMeUpWithFriendOfFriend:(SMUFriendOfFriend*)fof{
   // NSLog(@"coming into setMeUpWithFriendOfFriend ");
    
    
    _bannerView = [[SMUBannerView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _bannerView.backgroundColor = appCommonItemsUIColor;
    _bannerView.msgLabel.text = @"SetMeUp request sent your MatchMakers";
    _bannerView.iconImage.image = [UIImage imageNamed:@"setme"];
    [self.view addSubview:_bannerView];
    
    [self performSelector:@selector(changeStatus:) withObject:nil afterDelay:2];
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"mmflag"];
    NSString *flag = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    NSData *data2 = [defaults objectForKey:@"selectedMMArray"];
    NSMutableArray *selectedMMArray = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    
    NSString *matchMakersIdsStr;
    
    if([flag isEqualToString:@"YES"]&&[selectedMMArray count]!=0) {
         matchMakersIdsStr=[selectedMMArray componentsJoinedByString:@","];
    } else {
        NSArray *matchmakers=[shRes matchMakers];
        NSMutableArray *matchMakersIds=[NSMutableArray array];
        for (int i=0; i<[matchmakers count]; i++) {
            SMUFriend *aMatchMkr=[matchmakers objectAtIndex:i];
            [matchMakersIds addObject:aMatchMkr.userID];
        }
        matchMakersIdsStr=[matchMakersIds componentsJoinedByString:@","];
    }
    
    
   
    NSString *userCIdStr=fof.userID;
    [SMUWebServices setmeUpWithAccessToken:fbAccessToken forUserId:fbUserId forSelectedFriendsID:matchMakersIdsStr type:@"Normal" userCId:userCIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [responseObject objectForKey:@"non_smu_users"];
        
        if([dic count]!=0){
            
            SMUInvite *invite=[[SMUInvite alloc]init];
            [invite setNonsmuUserWithDict:dic];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InviteNVC"];
            SMUInviteViewController *recoABViewController = (SMUInviteViewController *)navigationController.viewControllers[0];
            recoABViewController.inviteDetails = invite;
        [self presentViewController:navigationController animated:YES completion:^{
            
           // NSLog(@"completed");
        }];
        }
        //NSLog(@"SETME UP SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"SETME UP FAILED");
    }];
    [_friendOfFriendsRef removeObject:fof];
}

- (void)ignoreWithFriendOfFriend:(SMUFriendOfFriend*)fof{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    NSString *userCIdStr=fof.userID;
    [SMUWebServices ignoreWithAccessToken:fbAccessToken forUserId:fbUserId userCId:userCIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"IGNORE SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"IGNORE FAIL");
    }];
    [_friendOfFriendsRef removeObject:fof];
}

- (void)approveWithFriendOfFriend:(SMUFriendOfFriend*)fof{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    NSString *userCIdStr=fof.userID;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"mmflag"];
    NSString *flag = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    NSData *data2 = [defaults objectForKey:@"selectedMMArray"];
    NSMutableArray *selectedMMArray = [NSKeyedUnarchiver unarchiveObjectWithData:data2];

    
    NSString *matchMakersIdsStr;
    
    if([flag isEqualToString:@"YES"]&&[selectedMMArray count]!=0) {
        matchMakersIdsStr=[selectedMMArray componentsJoinedByString:@","];
    } else {
        NSArray *matchmakers=[shRes matchMakers];
        NSMutableArray *matchMakersIds=[NSMutableArray array];
        for (int i=0; i<[matchmakers count]; i++) {
            SMUFriend *aMatchMkr=[matchmakers objectAtIndex:i];
            [matchMakersIds addObject:aMatchMkr.userID];
        }
        matchMakersIdsStr=[matchMakersIds componentsJoinedByString:@","];
    }
    [SMUWebServices approveWithAccessToken:fbAccessToken forUserId:fbUserId userCId:userCIdStr selectedMatchMakersIds:matchMakersIdsStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int responseCode = [[responseObject objectForKey:@"code"] intValue];
        if(responseCode == 301) {
            NSArray *array = (NSArray *)[responseObject objectForKey:@"Connectiondetails"];
            for(int i=0;i<[array count];i++) {
                NSString *connID = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:connID forKey:@"connMatchID"];
                SMUSharedReco * shRes = [SMUSharedReco sharedReco];
                [shRes setDetailsIntoCongratsModel];
            }
        }
        //NSLog(@"APPROVE SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"APPROVE FAILED");
    }];
    [_friendOfFriendsRef removeObject:fof];
}

- (void)disApproveWithFriendOfFriend:(SMUFriendOfFriend*)fof{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    NSString *userCIdStr=fof.userID;
    [SMUWebServices disApproveWithAccessToken:fbAccessToken forUserId:fbUserId userCId:userCIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"DISAPPROVE SUCCESS");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"DISAPPROVE FAILED");
    }];
}

-(void)changeStatus:(id)sender {
    [_bannerView removeFromSuperview];
}



- (void)changeApproveButtonSelectedState:(BOOL)selected;
{
    [_approveButton setSelected:selected];
    if (selected) {
        [_approveButton setImage:[UIImage imageNamed:@"smu_approve_btn_default"] forState:UIControlStateHighlighted];
    }
    else {
        [_approveButton setImage:[UIImage imageNamed:@"smu_approve_btn_selected"] forState:UIControlStateHighlighted];
    }
}

-(void)hideToolsView;
{
    //NSLog(@"coming inside into hidetoolview");
    _toolbarBottomContraint.constant = -44.0f;
    [_toolsView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.30f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)showToolsView;
{
    _toolbarBottomContraint.constant = 0.0f;
    [_toolsView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.30f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Circular UIScrollView methods

-(void)setUpScrollerWithViews
{
    _leftView=[[UIView alloc] init];
    _rightView=[[UIView alloc] init];
    _topView=[[UIView alloc] init];
    _bottomView=[[UIView alloc] init];
    _centerView=[[UIView alloc] init];
    _leftView.backgroundColor=[UIColor clearColor];
    _rightView.backgroundColor=[UIColor clearColor];
    _centerView.backgroundColor=[UIColor clearColor];
    _topView.backgroundColor=[UIColor clearColor];
    _bottomView.backgroundColor=[UIColor clearColor];
    CGRect leftFrame=CGRectMake(0,_friendOfFriendScroller.bounds.size.height, _friendOfFriendScroller.bounds.size.width, _friendOfFriendScroller.bounds.size.height);
    CGRect rightFrame=CGRectMake(_friendOfFriendScroller.bounds.size.width*2,_friendOfFriendScroller.bounds.size.height, _friendOfFriendScroller.bounds.size.width, _friendOfFriendScroller.bounds.size.height);
    CGRect topFrame=CGRectMake(_friendOfFriendScroller.bounds.size.width,0, _friendOfFriendScroller.bounds.size.width, _friendOfFriendScroller.bounds.size.height);
    CGRect bottomFrame=CGRectMake(_friendOfFriendScroller.bounds.size.width,_friendOfFriendScroller.bounds.size.height*2, _friendOfFriendScroller.bounds.size.width, _friendOfFriendScroller.bounds.size.height);
    CGRect centerFrame=CGRectMake(_friendOfFriendScroller.bounds.size.width,_friendOfFriendScroller.bounds.size.height, _friendOfFriendScroller.bounds.size.width, _friendOfFriendScroller.bounds.size.height);
    [_leftView setFrame:leftFrame];
    [_rightView setFrame:rightFrame];
    [_centerView setFrame:centerFrame];
    [_topView setFrame:topFrame];
    [_bottomView setFrame:bottomFrame];
    [_leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_rightView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_centerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_topView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_friendOfFriendScroller addSubview:_leftView];
    [_friendOfFriendScroller addSubview:_rightView];
    [_friendOfFriendScroller addSubview:_centerView];
    [_friendOfFriendScroller addSubview:_topView];
    [_friendOfFriendScroller addSubview:_bottomView];
    [_friendOfFriendScroller setContentSize:CGSizeMake(_friendOfFriendScroller.bounds.size.width*3, _friendOfFriendScroller.bounds.size.height*3)];
    _centerOffset=centerFrame.origin;
    [_friendOfFriendScroller setContentOffset:_centerOffset animated:NO];
    _friendOfFriendScroller.delegate=self;
    _friendOfFriendScroller.directionalLockEnabled=YES;
    _friendOfFriendScroller.pagingEnabled=YES;
    _friendOfFriendScroller.showsHorizontalScrollIndicator=NO;
    _friendOfFriendScroller.showsVerticalScrollIndicator=NO;
    [self updateScrollersWithImages];
}

- (void)updateScrollersWithImages
{
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _leftView.frame.size.width, _leftView.frame.size.height)];
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _rightView.frame.size.width, _rightView.frame.size.height)];
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _topView.frame.size.width, _topView.frame.size.height)];
    UIImageView *downImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _bottomView.frame.size.width, _bottomView.frame.size.height)];
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _centerView.frame.size.width, _centerView.frame.size.height)];
    leftImgView.tag=101;
    rightImgView.tag=101;
    topImgView.tag=101;
    downImgView.tag=101;
    centerImgView.tag=101;
    [_leftView addSubview:leftImgView];
    [_rightView addSubview:rightImgView];
    [_topView addSubview:topImgView];
    [_bottomView addSubview:downImgView];
    [_centerView addSubview:centerImgView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint newPoint=[[change objectForKey:@"new"] CGPointValue];
    CGPoint oldPoint=[[change objectForKey:@"old"] CGPointValue];
    if (newPoint.y==_friendOfFriendScroller.frame.size.height) {
        //allow modification as its strictly horizantal
        //allow x changes
        if (_currentFofIndex==0 && (newPoint.x<_friendOfFriendScroller.frame.size.width)) {
            //Limit left scroll when current index is 0
            [_friendOfFriendScroller removeObserver:self forKeyPath:@"contentOffset"];
            [_friendOfFriendScroller setContentOffset:oldPoint animated:NO];
            [_friendOfFriendScroller addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
    else if (newPoint.x==_friendOfFriendScroller.frame.size.width) {
        //allow modificaiton as its strictly vertical
        //allow y changes
    }
    else{
        [_friendOfFriendScroller removeObserver:self forKeyPath:@"contentOffset"];
        [_friendOfFriendScroller setContentOffset:oldPoint animated:NO];
        [_friendOfFriendScroller addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

-(ScrollDirection)getScrollDirection
{
    CGPoint currentOffset=_friendOfFriendScroller.contentOffset;
    CGFloat _y=_friendOfFriendScroller.frame.size.height;
    CGFloat _x=_friendOfFriendScroller.frame.size.width;
    if (currentOffset.x>_x & currentOffset.y==_y) {
        return ScrollDirectionRight;
    }
    else if (currentOffset.x<_x & currentOffset.y==_y) {
        return ScrollDirectionLeft;
    }
    else if (currentOffset.x==_x & currentOffset.y<_y) {
        return ScrollDirectionDown;
    }
    else if (currentOffset.x==_x & currentOffset.y>_y) {
        return ScrollDirectionUp;
    }
    return ScrollDirectionNull;
}

-(CGFloat)getVerticalScrollPercentage
{
    CGFloat percentage=0.0;
    float scrollDifference = _friendOfFriendScroller.contentOffset.y-_friendOfFriendScroller.frame.size.height;;
    percentage = fabs(scrollDifference) / [[UIScreen mainScreen] bounds].size.height;
    percentage+=.6; //rounding fix
    return percentage;
}


-(CGFloat)getHorizontalScrollPercentage
{
    CGFloat percentage=0.0;
    float scrollDifference = _friendOfFriendScroller.contentOffset.x-_friendOfFriendScroller.frame.size.width;
    percentage = fabs(scrollDifference) / [[UIScreen mainScreen] bounds].size.width;
    percentage+=.6; //rounding fix
    return percentage;
}


-(void)remapScrollLayouts
{
    ScrollDirection direction=[self getScrollDirection];
    switch (direction) {
        case ScrollDirectionUp:
        {
//            setme current user c
            
            //NSLog(@"button click:%@",_buttonFlag);
            if([_friendOfFriendsRef count] > 0) {
            if([_buttonFlag isEqualToString:@"setmeup"]) {
                [self setMeUpWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
            } else {
                [self approveWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
            }
            }
            [self loadNextFOF];
            _swipeCounter++;
            if (_swipeCounter>=10) {
                BOOL isFetching=[[SMUSharedResources sharedResourceManager] iterateFOFListFetching];
                if (isFetching) {
                    _swipeCounter=0;
                }
            }
        }
            break;
        case ScrollDirectionDown:
        {
//        ignore current user c
             if([_friendOfFriendsRef count] > 0) {
                 [self ignoreWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
             }
            [self loadNextFOF];
            _swipeCounter++;
            if (_swipeCounter>=10) {
                BOOL isFetching=[[SMUSharedResources sharedResourceManager] iterateFOFListFetching];
                if (isFetching) {
                    _swipeCounter=0;
                }
            }
        }
            break;
        case ScrollDirectionLeft:
        {
            leftCnt++;
//            move to prev user c
            if (_currentFofIndex!=0) {
                _currentFofIndex--;
            }
            [self loadPrevFOF];
            if (_swipeCounter>0) {
                _swipeCounter--;
            }
        }
            break;
        case ScrollDirectionRight:
        {
            rightCnt++;
//            move to next user c
            _currentFofIndex++;
           // NSLog(@"currect index:%d",_currentFofIndex);
            
            if(_currentFofIndex == 2) {
                [self showApproveTutorial];
            }
            [self loadNextFOF];
            _swipeCounter++;
            if (_swipeCounter>=10) {
                BOOL isFetching=[[SMUSharedResources sharedResourceManager] iterateFOFListFetching];
                if (isFetching) {
                    _swipeCounter=0;
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   // NSLog(@"will begin dragging");
    _buttonFlag = @"";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection direction=[self getScrollDirection];
    CGFloat percent =[self getVerticalScrollPercentage];
    CGFloat horPercent = [self getHorizontalScrollPercentage];
    if (direction==ScrollDirectionUp) {
       // NSLog(@"scroll up");
        //[self resetIndicators];
        //NSLog(@"button flag:%f",percent);
        _ignoreIndicatorView.alpha = 0.0;
        if (percent>.2) {
            if([_buttonFlag isEqualToString:@"setmeup"]) {
                _approveIndicatorView.alpha=percent;
                
            } else if([_buttonFlag isEqualToString:@"approve"]) {
                _setMeUpIndicatorView.alpha=percent;
            } else {
                _setMeUpIndicatorView.alpha=percent;
            }
            
            [self resetIndicators]; //at some time we need to reset the indicator so timer task incuded, as sometimes did end delegate is not trigged
            [self hideToolsView];
        }
        else{
            _ignoreIndicatorView.alpha=0.0;
            _setMeUpIndicatorView.alpha=0.0;
            _approveIndicatorView.alpha=0.0;
            _backIndicatorView.alpha=0.0;
            _nextIndicatorView.alpha=0.0;
        }
    }
    else if (direction==ScrollDirectionDown)
    {
        _setMeUpIndicatorView.alpha=0.0;
      //  NSLog(@"scroll down");
       // [self resetIndicators];
        if (percent>.2) {
            _ignoreIndicatorView.alpha=percent;
            [self resetIndicators]; //at some time we need to reset the indicator so timer task incuded, as sometimes did end delegate is not trigged
            [self hideToolsView];
        }
        else{
            _ignoreIndicatorView.alpha=0.0;
            _setMeUpIndicatorView.alpha=0.0;
            _approveIndicatorView.alpha=0.0;
            _backIndicatorView.alpha=0.0;
            _nextIndicatorView.alpha=0.0;
        }
    } else if(direction==ScrollDirectionRight) {
       // NSLog(@"hor percentage:%f",horPercent);
        if(horPercent>1.0 && rightCnt<2) {
            _nextIndicatorView.alpha = horPercent;
        }
    } else if(direction==ScrollDirectionLeft) {
        //NSLog(@"left percentage:%f",horPercent);
        if(horPercent>1.0 && leftCnt<2) {
            _backIndicatorView.alpha = horPercent;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self remapScrollLayouts];
    _setMeUpIndicatorView.alpha=0.0;
    _ignoreIndicatorView.alpha=0.0;
    _approveIndicatorView.alpha=0.0;
    _backIndicatorView.alpha=0.0;
    _nextIndicatorView.alpha=0.0;
    [self showToolsView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        _setMeUpIndicatorView.alpha=0.0;
        _ignoreIndicatorView.alpha=0.0;
        _approveIndicatorView.alpha=0.0;
        _backIndicatorView.alpha=0.0;
        _nextIndicatorView.alpha=0.0;
        [self remapScrollLayouts];
        [self showToolsView];
    }

}

#pragma mark - Blur Effect

- (UIImage *)blurBackgroundImageToview:(UIView *)blurview sourceBlurFromView:(UIView *)backgroundView {
    CGRect buttonRectInBGViewCoords = [blurview convertRect:blurview.bounds toView:backgroundView];
//    NSLog(@"buttonRectInBGViewCoords :%@",NSStringFromCGRect(buttonRectInBGViewCoords));
    UIGraphicsBeginImageContextWithOptions(blurview.frame.size, NO, [[[[self view] window] screen] scale]);
    [backgroundView drawViewHierarchyInRect:CGRectMake(-buttonRectInBGViewCoords.origin.x, -buttonRectInBGViewCoords.origin.y, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame))];
    UIImage *newBGImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    blurview.layer.masksToBounds = YES;
    NSData *imageData = UIImageJPEGRepresentation(newBGImage, 0);
    UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:1.0];
    return blurredSnapshot;
}

-(void)showPictureGalleryFromIndex:(NSInteger)index
{
    UIView *fofDetailsView=_smuPullDownVC.view;
    //pull up
    [UIView animateWithDuration:0.3 animations:^{
        [fofDetailsView setFrame:CGRectMake(0, -fofDetailsView.frame.size.height+kTopBarHeight+kMatchMakerBarVisibleHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
    } completion:^(BOOL finished) {
        [_smuPullDownVC showMatchMakersViewWithPercentage:100];
        UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
        SMUFriendOfFriend *currFOF=_friendOfFriendsRef[_currentFofIndex];
        [centerImgView setImageWithURL:[NSURL URLWithString:currFOF.profileImage]];
        SMUGalleryViewController *galleryVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUGalleryVC"];
        SMUFriendOfFriend *friendOF =_friendOfFriendsRef[_currentFofIndex];
        galleryVC.aFOF=friendOF;
        galleryVC.activeIndex=index;
        [self.navigationController pushViewController:galleryVC animated:YES];
    }];
    [self showToolsView];
}

- (IBAction)noButtonClick:(id)sender {
   // _toolsView.userInteractionEnabled = NO;
    _setmeupTutorialView.hidden = YES;
    //_friendOfFriendScroller.userInteractionEnabled = NO;
    _friendOfFriendScroller.hidden = NO;
    _toolsView.hidden = NO;
}

- (IBAction)yesButtonClick:(id)sender {
    _setmeupTutorialView.hidden = YES;
    _friendOfFriendScroller.hidden = NO;
    _toolsView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:NO];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:_friendOfFriendScroller];
        
    }];
}
-(void)useLessFactView{
    useLessView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height)];
    
    useLessView.backgroundColor=appBackGrondUIColor;
    self.view.userInteractionEnabled=NO;
 
    [self.view addSubview:useLessView];
    
    
}
-(void)hideUseLessView{
    self.view.userInteractionEnabled=YES;
    [useLessView removeFromSuperview];
}
@end
