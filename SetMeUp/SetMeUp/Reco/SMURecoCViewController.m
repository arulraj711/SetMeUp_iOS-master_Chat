//
//  SMURecoCViewController.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoCViewController.h"
#import "SMURecoUserC.h"
#import "SMURecoUserB.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"
#import "SMURecoCUserBCollectionHandler.h"
#import "SMURecoCUserBCollectionViewLayout.h"
#import "SMURecoCUserACollectionHandler.h"
#import "SMURecoUserA.h"
#import "SMURecoCUserACollectionViewLayout.h"
#import "SMUBCReco.h"
#import "SMURecoUserB.h"
#import "SMURecoQuipsViewController.h"
#import "SMURecoPullDownViewController.h"
#import "SMURecoBottomView.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
#import "SMUBCRecoUserA.h"
#import "SMUSharedReco.h"

@interface SMURecoCViewController ()<SMUHorizontalCollectionViewLayoutDelegate,SMURecoCUserBCollectionHandlerDelegate,SMURecoBottomViewDelegate>
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *userBCollectionView;
@property (nonatomic, strong) NSMutableArray *userBs;
@property (nonatomic, strong) SMURecoCUserBCollectionHandler *recoCUserBCollectionHandler;
@property (weak, nonatomic) IBOutlet UICollectionView *userACollectionView;
@property (nonatomic, strong) SMURecoCUserACollectionHandler *recoCUserACollectionHandler;
@property (nonatomic, strong) SMURecoCUserBCollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) SMURecoCUserACollectionViewLayout *collectionViewLayoutA;
@property (weak, nonatomic) IBOutlet SMURecoBottomView *bottomView;
@property (readwrite,nonatomic) NSUInteger currentIndex,currentIndexA;
@end

@implementation SMURecoCViewController

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
    
    self.userBs = self.recos;
    
    SMUBCReco *reco = [ self.userBs firstObject];

    
    NSString *pageNo = [NSString stringWithFormat:@"%d",0];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:pageNo forKey:@"selectedPageNo"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        UIImage *snapshot =  reco.userB.image;
        NSData *imageData = UIImageJPEGRepresentation(snapshot, 0.01);
        UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:0.5];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            self.bgImageView.image = blurredSnapshot;
        });
    });
    
    //  User B Collection View
    _recoCUserBCollectionHandler = [[SMURecoCUserBCollectionHandler alloc] init];
    _recoCUserBCollectionHandler.delegate = self;
    _recoCUserBCollectionHandler.userBs = self.userBs;
    _userBCollectionView.delegate = _recoCUserBCollectionHandler;
    _userBCollectionView.dataSource = _recoCUserBCollectionHandler;
    _collectionViewLayout = [[SMURecoCUserBCollectionViewLayout alloc] init];
    _collectionViewLayout.delegate = self;
    
    
    SMUHorizontalCollectionViewLayout *collectionViewLayout = [[SMUHorizontalCollectionViewLayout alloc] init];
    collectionViewLayout.delegate = self;
    
    // Do any additional setup after loading the view.
    [_userBCollectionView setCollectionViewLayout:_collectionViewLayout];
    [_bottomView applyBlurEffect:self.view];
    [_bottomView setDelegate:self];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_collectionViewLayoutA == nil)
    {
        //  User A Collection View
        _recoCUserACollectionHandler = [[SMURecoCUserACollectionHandler alloc] init];
        _userACollectionView.delegate = _recoCUserACollectionHandler;
        _userACollectionView.dataSource = _recoCUserACollectionHandler;
        [self loadUserCsForUserBForIndex:0];
        _collectionViewLayoutA = [[SMURecoCUserACollectionViewLayout alloc] initWIthCollectionViewFrame:_userACollectionView.frame];
        _collectionViewLayoutA.delegate = self;
        [_userACollectionView setCollectionViewLayout:_collectionViewLayoutA];
        [_userACollectionView reloadData];
    }
}
- (void)didIgnoreButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    
    NSString *flag = @"recoC";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
//    NSString *connId = [(SMUBCReco *)self.userBs[self.currentIndex] connectionId];
//    NSLog(@"selected connId:%@",connId);
    
    SMUBCReco *reco = self.userBs[self.currentIndex];
    SMURecoUserB *userB = reco.userB;
    SMUBCRecoUserA *recoCObj = [userB.userAs objectAtIndex:self.currentIndex];
  //  NSLog(@"connection id:%@",recoCObj.connectionId);
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    [SMUWebServices ignoreBCRecoWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"bcreco" forConnIds:recoCObj.connectionId status:@"If Ignore" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadNext];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
//    [SMUWebServices ignoreRecoWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"bcreco" forConnIds:recoCObj.connectionId success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self loadNext];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
   // [self loadNext];
}
- (void)didIntroduceButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    NSString *flag = @"recoC";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
    SMUBCReco *reco = self.userBs[self.currentIndex];
    SMURecoUserB *userB = reco.userB;
    SMUBCRecoUserA *recoCObj = [userB.userAs objectAtIndex:self.currentIndex];
   // NSLog(@"connection id:%@",recoCObj.connectionId);
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    [SMUWebServices acceptRecoWithAccessToken:fbAccessToken forUserId:fbUserId forConnId:recoCObj.connectionId success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // [self loadNext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
        NSString *connID = [NSString stringWithFormat:@"%@",recoCObj.connectionId];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:connID forKey:@"connMatchID"];
        SMUSharedReco *sharedReco = [SMUSharedReco sharedReco];
        [sharedReco checkRecoStatus];
        //[sharedReco setDetailsIntoCongratsModel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    //[self loadNext];
}
- (void)loadNext
{
    SMUSharedReco * shRes = [SMUSharedReco sharedReco];
    [shRes checkRecoStatus];
    SMUBCReco *reco = self.userBs[_currentIndex];
    SMURecoUserB *userB = reco.userB;
    _recoCUserACollectionHandler.userAs = userB.userAs;
    if(_recoCUserACollectionHandler.userAs.count == 1)
    {
        //  Simply Load Next Reco B
        if(self.recos.count == 1)
        {
            //  Simplay Dismiss View
            [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
        }
        else if((self.currentIndex + 1) == self.recos.count)
        {
            //NSLog(@"self.currentIndex :%d",self.currentIndex);
            //  Can Load Next Reco
            [self.recos removeObjectAtIndex:self.currentIndex];
            [_userBCollectionView reloadData];
            [self loadUserCsForUserBForIndex:self.currentIndex - 1];
        }
        else if((self.currentIndex + 1) < self.recos.count)
        {
            //  Can Load Next Reco
            [self.recos removeObjectAtIndex:self.currentIndex];
            [_userBCollectionView reloadData];
            [self loadUserCsForUserBForIndex:self.currentIndex];
        }
    }
    else if((self.currentIndexA) < _recoCUserACollectionHandler.userAs.count)
    {
        //  Can Load Next Reco A
        [userB.userAs removeObjectAtIndex:self.currentIndexA];
        [_userACollectionView reloadData];
    }
}

- (void)mockData
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender
{
    NSString *flag = @"recoC";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
    
//    SMUBCReco *reco = self.userBs[self.currentIndex];
//    SMURecoUserB *userB = reco.userB;
//    SMUBCRecoUserA *recoCObj = [userB.userAs objectAtIndex:self.currentIndex];
//    
//    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
//    fbAccessToken=[shRes getFbAccessToken];
//    fbUserId=[shRes getFbLoggedInUserId];
//    //NSString *connIdStr =  [seletcedConnIds componentsJoinedByString:@","];
//    
//    
//    [SMUWebServices closeRecoWithAccessToken:fbAccessToken forUserId:fbUserId forConnId:recoCObj.connectionId type:@"BC" success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
//        
//    }];
    
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
}
#pragma mark - SMUHorizontalCollectionViewLayoutDelegate

- (void)SMUHorizontalCollectionViewLayout:(SMUHorizontalCollectionViewLayout *)horizontalCollectionViewLayout didLoadedPage:(NSUInteger )page
{
    //NSLog(@"smuhorizontal collection view layout");
    if([horizontalCollectionViewLayout isKindOfClass:[SMURecoCUserBCollectionViewLayout class]])
    {
        [self loadUserCsForUserBForIndex:page];
    }
    else if([horizontalCollectionViewLayout isKindOfClass:[SMURecoCUserACollectionViewLayout class]])
    {
        NSString *pageNo = [NSString stringWithFormat:@"%d",page];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:pageNo forKey:@"selectedPageNo"];
        
        self.currentIndexA = page;
    }
}
- (void)loadUserCsForUserBForIndex:(NSUInteger)index
{
    self.currentIndex = index;
    self.currentIndexA = 0;
    SMUBCReco *reco = self.userBs[index];
    SMURecoUserB *userB = reco.userB;
    _recoCUserACollectionHandler.userAs = userB.userAs;
    [_userACollectionView reloadData];
    [_userACollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    [_userACollectionView performBatchUpdates:^{
//        [_userACollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//    } completion:^(BOOL finished) {
//        [_userACollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//        [_userACollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
//        SMURecoCUserACollectionViewLayout *layout = ( SMURecoCUserACollectionViewLayout *)_userACollectionView.collectionViewLayout;
//        layout.currentContentOffsetX = 0.0;
//        NSLog(@"layout :%@",layout);
//    }];

}
- (void)SMURecoCUserBCollectionHandler:(SMURecoCUserBCollectionHandler *)recoCUserBCollectionHandler didLoadUserBForIndexPath:(NSIndexPath *)indexPath
{
    [self loadUserCsForUserBForIndex:indexPath.row];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"RecoCPullDown"])
    {
        SMURecoPullDownViewController *recoPullDownViewController = segue.destinationViewController;
        recoPullDownViewController.bgImage = _bgImageView.image;
//        NSIndexPath *indexPath = [_userACollectionView indexPathsForSelectedItems][0];
        recoPullDownViewController.recoBC = self.recos[self.currentIndex];
        recoPullDownViewController.currentIndexA = self.currentIndexA;
    }
}

@end
