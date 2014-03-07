//
//  SMURecoIntroduceViewController.m
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoABViewController.h"
#import "SMURecoABUserACollectionHandler.h"
#import "SMURecoABUserCCollectionHandler.h"
#import "SMUHorizontalCollectionViewLayout.h"
#import "SMURecoQuipsViewController.h"
#import "SMURecoUserA.h"
#import "SMURecoUserC.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"
#import "SMURecoAB.h"
#import "SMUSharedReco.h"
#import "SMUBCReco.h"
#import "SMURecoBottomView.h"
#import "UIImageView+WebCache.h"
#import "SMUSharedReco.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
#import "SMUQuipData.h"
#import "SMUQuipQuestion.h"
#import "SMURatingData.h"
#import "SMUPhraseQuestion.h"
#import "SMURecoListViewController.h"
#import "SMUConnectUser.h"
#import "SMUInviteUserCViewController.h"
#import "SMUUserCInvite.h"
@interface SMURecoABViewController () < SMUHorizontalCollectionViewLayoutDelegate ,SMURecoABUserACollectionHandlerDelegate,SMURecoBottomViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *recoUserACollectionView,*recoUserCCollectionView;
@property (nonatomic, strong) SMURecoABUserACollectionHandler *recoIntroduceUserACollectionHandler;
@property (nonatomic, strong) SMURecoABUserCCollectionHandler *recoIntroduceUserCCollectionHandler;
@property (nonatomic, strong) SMURecoAB *recoAB;

@property (weak, nonatomic) IBOutlet SMURecoBottomView *bottomView;
@property (readwrite,nonatomic) NSUInteger currentIndex;
@end

@implementation SMURecoABViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)cancel:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
    
//    NSMutableArray *seletcedConnIds = [[NSMutableArray alloc]init];
//    NSMutableArray *recoCs = [(SMURecoAB *) self.recos[self.currentIndex] cUserArray];
//    for(int i=0;i<[recoCs count];i++) {
//        SMURecoUserC *smuRecoUserCObj = (SMURecoUserC*)[recoCs objectAtIndex:i];
//       // if(smuRecoUserCObj.isSelected) {
//            [seletcedConnIds addObject:smuRecoUserCObj.connectionId];
//       // }
//    }
//    
//    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
//    fbAccessToken=[shRes getFbAccessToken];
//    fbUserId=[shRes getFbLoggedInUserId];
//    NSString *connIdStr =  [seletcedConnIds componentsJoinedByString:@","];
//    
//    
//    [SMUWebServices closeRecoWithAccessToken:fbAccessToken forUserId:fbUserId forConnId:connIdStr type:@"AB" success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
//        
//    }];
    
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *flag = @"Normal";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag forKey:@"flag"];
    
    
    NSString *introFlag = @"no";
  //  NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:introFlag forKey:@"introflag"];
    
    [self showTutorialView];
    
    [self setBlurredBgImage:[(SMURecoAB *) self.recos[0] userA]];
    //  User A Collection View
    _recoIntroduceUserACollectionHandler = [[SMURecoABUserACollectionHandler alloc] init];
    _recoIntroduceUserACollectionHandler.delegate = self;
    _recoIntroduceUserACollectionHandler.userAs = self.recos;
    _recoUserACollectionView.delegate = _recoIntroduceUserACollectionHandler;
    _recoUserACollectionView.dataSource = _recoIntroduceUserACollectionHandler;
    SMUHorizontalCollectionViewLayout *collectionViewLayout = [[SMUHorizontalCollectionViewLayout alloc] init];
    collectionViewLayout.delegate = self;

    //  User C Collection View
    _recoIntroduceUserCCollectionHandler = [[SMURecoABUserCCollectionHandler alloc] init];
    _recoUserCCollectionView.delegate = _recoIntroduceUserCCollectionHandler;
    _recoUserCCollectionView.dataSource = _recoIntroduceUserCCollectionHandler;
    [self loadUserCsForUserAForIndex:0];
    [_recoUserACollectionView setCollectionViewLayout:collectionViewLayout];
    [_bottomView applyBlurEffect:self.view];
    [_bottomView setDelegate:self];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"checkSelection"];
    _checkSelection = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
}

-(void)showTutorialView {
    
    NSString *recoTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"recoAB1TutorialStatus"];
    //NSLog(@"reco tutorial status:%@",recoTutorialStatus);
    if([recoTutorialStatus isEqualToString:@"New"]) {
        NSString *fcTutorialStatus1 = @"Old";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:fcTutorialStatus1 forKey:@"recoAB1TutorialStatus"];
        _ghView = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
        _ghView.pageControl.hidden = YES;
        _ghView.pageControl1.hidden = YES;
        [_ghView setDataSource:self];
        // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        self.ghView.floatingHeaderView = nil;
        [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
        [self.view addSubview:self.ghView];
        [self.ghView showInView:self.navigationController.view animateDuration:0.3];
        
  }
}

#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 1;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"reco1"];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}


- (void)didIgnoreButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    //NSLog(@"check selection flag:%@",_checkSelection);
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    //[shRes fetchUserProfile];
    
    NSMutableArray *seletcedConnIds = [[NSMutableArray alloc]init];
    NSMutableArray *recoCs = [(SMURecoAB *) self.recos[self.currentIndex] cUserArray];
    for(int i=0;i<[recoCs count];i++) {
        SMURecoUserC *smuRecoUserCObj = (SMURecoUserC*)[recoCs objectAtIndex:i];
        if(smuRecoUserCObj.isSelected) {
            [seletcedConnIds addObject:smuRecoUserCObj.connectionId];
        }
    }
    
   // SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
     NSString *connIdStr =  [seletcedConnIds componentsJoinedByString:@","];
    //NSLog(@"slected connid count:%d and string:%@",[seletcedConnIds count],connIdStr);
    [SMUWebServices ignoreRecoWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"abrecoall" forConnIds:connIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        if([_checkSelection isEqualToString:@"YES"]) {
//            SMURecoListViewController *obj = [[SMURecoListViewController alloc]init];
//            [obj loadRecoTable];
//        }
        [self loadNext];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        
    }];
    
}
- (void)didIntroduceButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    
    NSString *introFlag = @"yes";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:introFlag forKey:@"introflag"];
    
    NSMutableArray *seletcedConnIds = [[NSMutableArray alloc]init];
    NSMutableArray *recoCs = [(SMURecoAB *) self.recos[self.currentIndex] cUserArray];
    for(int i=0;i<[recoCs count];i++) {
        SMURecoUserC *smuRecoUserCObj = (SMURecoUserC*)[recoCs objectAtIndex:i];
        if(smuRecoUserCObj.isSelected) {
            //NSLog(@"selected value:%@",smuRecoUserCObj.connectionId);
            [seletcedConnIds addObject:smuRecoUserCObj.connectionId];
        }
    }
    
    NSMutableArray *selectedQuipData = [[NSMutableArray alloc]init];
    NSMutableArray *quipDataIdArray =[[NSMutableArray alloc]init];
    NSMutableArray *quipData = [(SMURecoAB *) self.recos[self.currentIndex] quipDataArray];
    for(int i=0;i<[quipData count];i++) {
        SMUQuipData *quipDataObj = (SMUQuipData *)[quipData objectAtIndex:i];
        [quipDataIdArray addObject:quipDataObj.quipId];
        NSMutableArray *quipQnArray = quipDataObj.questions;
        for(int j=0;j<[quipQnArray count];j++) {
            SMUQuipQuestion *quipQuesnObj = (SMUQuipQuestion *)[quipQnArray objectAtIndex:j];
            if(quipQuesnObj.isSelected) {
                [selectedQuipData addObject:quipQuesnObj.question_id];
            }
            
        }
    }

    NSMutableArray *ratingAnsArray =[[NSMutableArray alloc]init];
    NSMutableArray *ratingIDArray = [[NSMutableArray alloc]init];
    NSMutableArray *ratingData = [(SMURecoAB *) self.recos[self.currentIndex] ratingDataArray];
    for(int i=0;i<[ratingData count];i++) {
        SMURatingData *ratingDataObj = (SMURatingData *)[ratingData objectAtIndex:i];
        [ratingIDArray addObject:ratingDataObj.ratingId];
        if(ratingDataObj.isRatingsUpdated) {
            NSString *ratingStr = [NSString stringWithFormat:@"%f",ratingDataObj.rating];
            [ratingAnsArray addObject:ratingStr];
        }
    }
    
    SMURecoAB *recoABObj = (SMURecoAB *)self.recos[self.currentIndex];
    SMUPhraseQuestion *phraseQnObj = (SMUPhraseQuestion *)recoABObj.phraseQuestion;
    NSString *phraseQnId = phraseQnObj.questionId;
    NSString *phraseQnName =phraseQnObj.questionText;
    
   NSString *recoDetailsStr =  [self createRecoDetailsJSONFormatWithQnId:phraseQnId withQnText:phraseQnName quipIds:quipDataIdArray quipAns:selectedQuipData ratingId:ratingIDArray ratingAns:ratingAnsArray];
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    NSString *connIdStr =  [seletcedConnIds componentsJoinedByString:@","];
    
    [SMUWebServices sendCRecoWithAccessToken:fbAccessToken forUserId:fbUserId withRecoDetails:recoDetailsStr forConnId:connIdStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _nonSmuUserArray = (NSArray *)[responseObject objectForKey:@"nonSmuUsers"];
        
       // _nonSmu=[[NSMutableArray alloc]init];
        //if([array count]!=0){
//
//            for (NSDictionary *dic in array) {
//                SMUUserCInvite *ConnectedUser = [[SMUUserCInvite alloc] init];
//                [ConnectedUser setNonsmuUserWithDict:dic];
//                [_nonSmu addObject:ConnectedUser];
//            }
//            
////            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////            UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InviteUserCNVC"];
////            SMUInviteUserCViewController *recoABViewController = (SMUInviteUserCViewController *)navigationController.viewControllers[0];
////            recoABViewController.inviteCUserDetails=nonSmu;
////            [self presentViewController:navigationController animated:YES completion:^{
////                
////                NSLog(@"completed");
////            }];
//
//        }
        
        [self loadNext];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        
    }];
    
    //[self loadNext];
}

-(NSString *)createRecoDetailsJSONFormatWithQnId:(NSString *)phraseQnId
                      withQnText:(NSString *)qnText
                quipIds:(NSMutableArray *)quipIds
                      quipAns:(NSMutableArray *)quipAns
                                   ratingId:(NSMutableArray *)ratingId
                                   ratingAns:(NSMutableArray *)ratingAns{
    
    NSString *jsonString;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:quipIds forKey:@"quip_id"];
    [dict setObject:quipAns forKey:@"quip_question"];
    [dict setObject:ratingId forKey:@"rate_question"];
    [dict setObject:ratingAns forKey:@"rate_answer"];
    [dict setObject:phraseQnId forKey:@"my_question_id"];
    [dict setObject:qnText forKey:@"my_answer"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // NSLog(@"json string:%@",jsonString);
    }
    return jsonString;
}

- (void)loadNext
{
    SMUSharedReco * shRes = [SMUSharedReco sharedReco];
    [shRes checkRecoStatus];
    if([_nonSmuUserArray count] == 0) {
        if(self.recos.count == 1)
        {
            //  Simplay Dismiss View
            [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
        }
        if((self.currentIndex + 1) < self.recos.count)
        {
            //  Can Load Next Reco
            [self.recos removeObjectAtIndex:self.currentIndex];
            [self.recoUserACollectionView reloadData];
            [self loadUserCsForUserAForIndex:self.currentIndex];
        }
    } else {
        
        NSString *flag = @"InvitePopup";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:flag forKey:@"flag"];
        //NSLog(@"reco flag:%@ and nonsmu:%@",flag,_nonSmuUserArray);
        [def setObject:_nonSmuUserArray forKey:@"nonSMUUserArray"];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"UserAQuips"])
    {
        SMURecoQuipsViewController *recoQuipsViewController = segue.destinationViewController;
        recoQuipsViewController.bgImage = _bgImageView.image;
        NSIndexPath *indexPath = [_recoUserACollectionView indexPathsForSelectedItems][0];
        recoQuipsViewController.recoAB = self.recos[indexPath.row];
    }
}
#pragma mark - SMUHorizontalCollectionViewLayoutDelegate

- (void)SMUHorizontalCollectionViewLayout:(SMUHorizontalCollectionViewLayout *)horizontalCollectionViewLayout didLoadedPage:(NSUInteger )page
{
    [self loadUserCsForUserAForIndex:page];
}

- (void)loadUserCsForUserAForIndex:(NSUInteger)index
{
    self.currentIndex = index;
    [self setBlurredBgImage:[(SMURecoAB *) self.recos[index] userA]];
    NSMutableArray *recoCs = [(SMURecoAB *) self.recos[index] cUserArray];
    self.title = [NSString stringWithFormat:@"Introduce %@",[[(SMURecoAB *) self.recos[index] userA] firstname]];
    _recoIntroduceUserCCollectionHandler.userCs = recoCs;
    
    [_recoUserCCollectionView performBatchUpdates:^{
        [_recoUserCCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
}
- (void)setBlurredBgImage:(SMURecoUserA *)recoUserA
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        NSData *imageData = UIImageJPEGRepresentation(recoUserA.image, 0.01);
        UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:0.5];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            _bgImageView.image = blurredSnapshot;
        });
    });
//    SMURecoABViewController __block __weak *w_self = self;
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:recoUserA.img_url]];
//    [self.bgImageView setImageWithURLRequest:request
//                            placeholderImage:nil
//                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                         
//                                     }
//                                     failure:nil];
}
- (void)SMURecoIntroduceUserACollectionHandler:(SMURecoABUserACollectionHandler *)recoIntroduceUserACollectionHandler didLoadUserBForIndexPath:(NSIndexPath *)indexPath
{
    [self loadUserCsForUserAForIndex:indexPath.row];
}

@end
