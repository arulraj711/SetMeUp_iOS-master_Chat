//
//  SMURecoPullDownViewController.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoPullDownViewController.h"
#import "SMUSetMeUpViewController.h"
#import "SMURecoQuipsViewController.h"
#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"
#import "SMURecoQuipsViewController.h"
#import "SMUBCReco.h"
#import "SMUBCRecoUserA.h"
#import "SMURecoUserB.h"
#import "SMUSharedResources.h"
#import "SMUUserProfile.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
#import "ITSideMenu.h"
#import "SMUFriendOfFriend.h"
#import "SMUPullDownPullableViewController.h"
#import "SMUWebServices.h"
#import "SMUFriend.h"
#import "UIImageView+WebCache.h"
#import "SMUUserProfile.h"
#import "UIImage+ImageEffects.h"
#import "SMUGalleryViewController.h"
#import "UIImage+BoxBlur.h"
#import "SMUSharedReco.h"
#import "SMURecoBottomView.h"

#define kRecoTopBarHeight 64
#define kRecoMatchMakerBarVisibleHeight 30
@interface UIView (SymbolNotPublicInSeed1)
// This method was implemented in seed 1 but the symbol was not made public. It will be public in seed 2.
- (BOOL)drawViewHierarchyInRect:(CGRect)rect;
@end


@interface SMURecoPullDownViewController ()<SMURecoBottomViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;

@property(nonatomic,strong) IBOutlet UIScrollView *friendOfFriendScroller;
@property(nonatomic,strong) IBOutlet UIButton *approveButton;
@property(nonatomic,strong) IBOutlet SMURecoBottomView *toolsView;
@property (weak, nonatomic) IBOutlet UIImageView *toolsBlurImageView;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *toolbarBottomContraint;
@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIView *rightView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIView *setMeUpIndicatorView;
@property(nonatomic,strong) UIView *ignoreIndicatorView;
@property(nonatomic) CGPoint centerOffset;
@property(nonatomic,strong) SMUPullDownPullableViewController *smuPullDownVC;

@property (nonatomic, strong) NSMutableArray *friendsRef,*friendOfFriendsRef,*matchMakersRef;
@property (nonatomic, readwrite) BOOL isViewSetUp;
@property (nonatomic, readwrite) NSInteger currentFofIndex;
@property (nonatomic, readwrite) NSInteger swipeCounter;


- (IBAction)showLeftMenuPressed:(id)sender;
- (IBAction)showRightMenuPressed:(id)sender;
- (IBAction)setMeUpButtonClicked:(id)sender;
//- (IBAction)ignoreButtonClicked:(id)sender;
//- (IBAction)approveButtonClicked:(id)sender;

- (void)setMeUpWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)ignoreWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)approveWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)disApproveWithFriendOfFriend:(SMUFriendOfFriend*)fof;
- (void)changeApproveButtonSelectedState:(BOOL)selected;
- (void)hideToolsView;
- (void)showToolsView;

@end

@implementation SMURecoPullDownViewController
SMUBCRecoUserA *userA;
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
    
//    self.bgImageView.image = _bgImage;
    
    SMURecoUserB *userB = self.recoBC.userB;
    userA = [userB.userAs objectAtIndex:_currentIndexA];
    [self.bgImageView setImageWithURL:[NSURL URLWithString:userA.img_url] placeholderImage:nil];
 
    if([userA.age isKindOfClass:[NSString class]])
       self.title = [NSString stringWithFormat:@"%@, %@",userA.firstname,userA.age] ;
    else
        self.title = userA.firstname ;
    
    
    _isViewSetUp=NO;
    _swipeCounter=0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"UserAQuips"])
    {
        SMURecoQuipsViewController *recoQuipsViewController = segue.destinationViewController;
        recoQuipsViewController.recoQuipsViewType = SMURecoQuipsViewTypeRecoC;
        recoQuipsViewController.bgImage = _bgImage;
        recoQuipsViewController.recoBC = _recoBC;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.menuContainerViewController setPanMode:ITSideMenuPanModeDefault];
    if (!_isViewSetUp) {
        CGRect frame=CGRectMake(0, 0, 112, 111);
        _setMeUpIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_setMeUpIndicatorView setBackgroundColor:[UIColor clearColor]];
        _setMeUpIndicatorView.center=self.view.center;
        _setMeUpIndicatorView.alpha=0.0;
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:frame];
        [imgView setImage:[UIImage imageNamed:@"indicator_setmeup"]];
        [_setMeUpIndicatorView addSubview:imgView];
        [self.view addSubview:_setMeUpIndicatorView];
        
        _ignoreIndicatorView=[[UIView alloc] initWithFrame:frame];
        [_ignoreIndicatorView setBackgroundColor:[UIColor clearColor]];
        _ignoreIndicatorView.center=self.view.center;
        _ignoreIndicatorView.alpha=0.0;
        imgView=[[UIImageView alloc] initWithFrame:frame];
        [imgView setImage:[UIImage imageNamed:@"indicator_ignore"]];
        [_ignoreIndicatorView addSubview:imgView];
        [self.view addSubview:_ignoreIndicatorView];
        [self setUpScrollerWithViews];
        [self addPullDownView];
        _isViewSetUp=YES;
        [_toolsView applyBlurEffect:self.view];
        _toolsView.delegate = self;

        SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
        NSString *fbAccessToken=[shRes getFbAccessToken];
        NSString *fbUserId=shRes.userProfile.userID;
        
        [SMUWebServices getUserADetailsWithAccessToken:fbAccessToken forUserId:fbUserId selectedUserID:userA.userId success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            // NSLog(@"responseObject in pagee :%@",responseObject);
             [self setupViewsWithFOF:responseObject];
            // NSLog(@"after thataaaa");
             //        [_friendOfFriendScroller addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
             //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithFOFData) name:@"UserFOFListRetrieved" object:nil];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"error :%@",error);
         }];
    }
}
- (void)prepareViewsWithFOFData;
{
    [SMUSharedReco sharedReco];
    _friendsRef=[SMUSharedResources sharedResourceManager].friends;
    _friendOfFriendsRef=[SMUSharedResources sharedResourceManager].friendOfFriendsList;
    _matchMakersRef=[SMUSharedResources sharedResourceManager].matchMakers;
    _currentFofIndex=0;
//    [self setupViewsWithFOF];
}
-(void)showMyMatchMakers
{
    [_smuPullDownVC addMatchmakersClicked:nil];
}

#pragma mark- FOF Setters

-(void)setupViewsWithFOF:(SMUFriendOfFriend *)aFOF
{
    [_smuPullDownVC setFriendOfFriend:aFOF];
   // NSLog(@"one");
//    if (aFOF.age) {
//        self.title=[NSString stringWithFormat:@"%@, %ld",aFOF.fullName,(long)aFOF.age];
//    }
//    else
//    {
//        self.title=aFOF.fullName;
//    }
    [self changeApproveButtonSelectedState:aFOF.approveStatus];
    //NSLog(@"two");
    [self setImagesWithIndex:_currentFofIndex];
}

-(void)loadNextFOF
{
    SMUFriendOfFriend *aFOF=_friendOfFriendsRef[_currentFofIndex];
    [_smuPullDownVC setFriendOfFriend:aFOF];
//    if (aFOF.age) {
//        self.title=[NSString stringWithFormat:@"%@, %ld",aFOF.fullName,(long)aFOF.age];
//    }
//    else
//    {
//        self.title=aFOF.fullName;
//    }
    [self changeApproveButtonSelectedState:aFOF.approveStatus];
    [self setImagesWithIndex:_currentFofIndex];
}

-(void)loadPrevFOF
{
    SMUFriendOfFriend *aFOF=_friendOfFriendsRef[_currentFofIndex];
    [_smuPullDownVC setFriendOfFriend:aFOF];
//    if (aFOF.age) {
//        self.title=[NSString stringWithFormat:@"%@, %ld",aFOF.fullName,(long)aFOF.age];
//    }
//    else
//    {
//        self.title=aFOF.fullName;
//    }
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
    _smuPullDownVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUPullDownPullableViewController"];
    //NSLog(@"_smuPullDownVC.view.frame.size.height :%f",_smuPullDownVC.view.frame.size.height);
    [_smuPullDownVC.view addGestureRecognizer:panGestureRecognizer];
    [_smuPullDownVC.view setFrame:CGRectMake(0, -_smuPullDownVC.view.frame.size.height+kRecoTopBarHeight+kRecoMatchMakerBarVisibleHeight , _smuPullDownVC.view.frame.size.width, _smuPullDownVC.view.frame.size.height)];
    [self addChildViewController:_smuPullDownVC];
    [self.view addSubview:_smuPullDownVC.view];
}

-(void)pullDownTapGestureDetected:(UITapGestureRecognizer*)gesture
{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        [self hideToolsView];
        UIView *fofDetailsView = _smuPullDownVC.view;
        [UIView animateWithDuration:0.3 animations:^{
            [fofDetailsView setFrame:CGRectMake(0, kRecoTopBarHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
        } completion:^(BOOL finished) {
            [_smuPullDownVC hideMatchMakersViewWithPercentage:0];
            UIImageView *centerImgView=(UIImageView*)[_centerView viewWithTag:101];
            [centerImgView setImage:[self blurBackgroundImageToview:centerImgView sourceBlurFromView:[centerImgView superview]]];
        }];
    }
}

-(void)pullDownPanGestureDetected:(UIPanGestureRecognizer*)gesture
{
    CGFloat velocityY=[gesture velocityInView:self.view].y;
    UIView *fofDetailsView = [gesture view];
    CGPoint translation = [gesture translationInView:[fofDetailsView superview]];
    if([gesture state] == UIGestureRecognizerStateBegan){
        if (translation.y>0 && (fofDetailsView.frame.origin.y+translation.y)<kRecoTopBarHeight) {
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
        if (translation.y>0 && (fofDetailsView.frame.origin.y+translation.y)<kRecoTopBarHeight) {
            //Pull down in progress
            [fofDetailsView setCenter:CGPointMake(fofDetailsView.center.x, fofDetailsView.center.y+translation.y)];
            
            float scrollDifference = fofDetailsView.frame.origin.y;
            float percentageTracked;
            percentageTracked = fabs(scrollDifference) * 100 / [[UIScreen mainScreen] bounds].size.height;
            [_smuPullDownVC hideMatchMakersViewWithPercentage:percentageTracked];
        }
        else if (translation.y<0 && (fofDetailsView.frame.origin.y+translation.y)>-fofDetailsView.frame.size.height+kRecoTopBarHeight+kRecoMatchMakerBarVisibleHeight){
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
                [fofDetailsView setFrame:CGRectMake(0, kRecoTopBarHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
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
                [fofDetailsView setFrame:CGRectMake(0, -fofDetailsView.frame.size.height+kRecoTopBarHeight+kRecoMatchMakerBarVisibleHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
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
            [fofDetailsView setFrame:CGRectMake(0, -fofDetailsView.frame.size.height+kRecoTopBarHeight+kRecoMatchMakerBarVisibleHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
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
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (IBAction)setMeUpButtonClicked:(id)sender{
    //    [self setMeUpWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
    //    [self loadNextFOF];
    //    [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [_friendOfFriendScroller scrollRectToVisible:_bottomView.frame animated:NO];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:_friendOfFriendScroller];
    }];
}

#pragma mark - SMURecoBottomView
- (void)didIgnoreButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *controller = self.navigationController.viewControllers[0];
    [(id < SMURecoBottomViewDelegate > )controller didIgnoreButtonClickedSMURecoBottomView:recoBottomView];
}
- (void)didIntroduceButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *controller = self.navigationController.viewControllers[0];
    [(id < SMURecoBottomViewDelegate > )controller didIntroduceButtonClickedSMURecoBottomView:recoBottomView];
}
#pragma mark - Helper methods

-(void)resetIndicators
{
    if (!(_friendOfFriendScroller.isDragging||_friendOfFriendScroller.isDecelerating||_friendOfFriendScroller.isTracking)) {
        _setMeUpIndicatorView.alpha=0.0;
        _ignoreIndicatorView.alpha=0.0;
        return ;
    }
    [self performSelector:@selector(resetIndicators) withObject:nil afterDelay:.3];
}

- (void)setMeUpWithFriendOfFriend:(SMUFriendOfFriend*)fof{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    NSArray *matchmakers=[shRes matchMakers];
    NSMutableArray *matchMakersIds=[NSMutableArray array];
    for (int i=0; i<[matchmakers count]; i++) {
        SMUFriend *aMatchMkr=[matchmakers objectAtIndex:i];
        [matchMakersIds addObject:aMatchMkr.userID];
    }
    NSString *matchMakersIdsStr=[matchMakersIds componentsJoinedByString:@","];
    NSString *userCIdStr=fof.userID;
    [SMUWebServices setmeUpWithAccessToken:fbAccessToken forUserId:fbUserId forSelectedFriendsID:matchMakersIdsStr type:@"Normal" userCId:userCIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"SETME UP SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"SETME UP FAILED");
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
       // NSLog(@"IGNORE FAIL");
    }];
    [_friendOfFriendsRef removeObject:fof];
}

- (void)approveWithFriendOfFriend:(SMUFriendOfFriend*)fof{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    NSString *userCIdStr=fof.userID;
    NSArray *matchmakers=[shRes matchMakers];
    NSMutableArray *matchMakersIds=[NSMutableArray array];
    for (int i=0; i<[matchmakers count]; i++) {
        SMUFriend *aMatchMkr=[matchmakers objectAtIndex:i];
        [matchMakersIds addObject:aMatchMkr.userID];
    }
    NSString *matchMakersIdsStr=[matchMakersIds componentsJoinedByString:@","];
    [SMUWebServices approveWithAccessToken:fbAccessToken forUserId:fbUserId userCId:userCIdStr selectedMatchMakersIds:matchMakersIdsStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"APPROVE SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"APPROVE FAILED");
    }];
}

- (void)disApproveWithFriendOfFriend:(SMUFriendOfFriend*)fof{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    NSString *userCIdStr=fof.userID;
    [SMUWebServices disApproveWithAccessToken:fbAccessToken forUserId:fbUserId userCId:userCIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"DISAPPROVE SUCCESS");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"DISAPPROVE FAILED");
    }];
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
    percentage+=.1; //rounding fix
    return percentage;
}

-(void)remapScrollLayouts
{
    ScrollDirection direction=[self getScrollDirection];
    switch (direction) {
        case ScrollDirectionUp:
        {
            //            setme current user c
            [self setMeUpWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
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
            [self ignoreWithFriendOfFriend:[_friendOfFriendsRef objectAtIndex:_currentFofIndex]];
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
            //            move to next user c
            _currentFofIndex++;
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
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection direction=[self getScrollDirection];
    CGFloat percent =[self getVerticalScrollPercentage];
    if (direction==ScrollDirectionUp) {
        if (percent>.2) {
            _setMeUpIndicatorView.alpha=percent;
            [self resetIndicators]; //at some time we need to reset the indicator so timer task incuded, as sometimes did end delegate is not trigged
            [self hideToolsView];
        }
        else{
            _ignoreIndicatorView.alpha=0.0;
            _setMeUpIndicatorView.alpha=0.0;
        }
    }
    else if (direction==ScrollDirectionDown)
    {
        if (percent>.2) {
            _ignoreIndicatorView.alpha=percent;
            [self resetIndicators]; //at some time we need to reset the indicator so timer task incuded, as sometimes did end delegate is not trigged
            [self hideToolsView];
        }
        else{
            _ignoreIndicatorView.alpha=0.0;
            _setMeUpIndicatorView.alpha=0.0;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self remapScrollLayouts];
    _setMeUpIndicatorView.alpha=0.0;
    _ignoreIndicatorView.alpha=0.0;
    [self showToolsView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        _setMeUpIndicatorView.alpha=0.0;
        _ignoreIndicatorView.alpha=0.0;
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
        [fofDetailsView setFrame:CGRectMake(0, -fofDetailsView.frame.size.height+kRecoTopBarHeight+kRecoMatchMakerBarVisibleHeight, fofDetailsView.frame.size.width, fofDetailsView.frame.size.height)];
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

@end
