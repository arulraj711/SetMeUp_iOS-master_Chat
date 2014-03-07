//
//  SMURecoListViewController.m
//  SetMeUp
//
//  Created by In on 03/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMURecoListViewController.h"
#import "SMURecoListViewCell.h"
#import "SMUWebServices.h"
#import "SMURecentStatus.h"
#import "SMURecoAB.h"
#import "SMUBCReco.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
#import "SMUUserProfile.h"
#import "SMURecoABViewController.h"
#import "SMURecoUserA.h"
//#import "UIImageView+AFNetworking.h"
#import "SMURecoUserB.h"
#import "SMURecoCViewController.h"
#import "UIImageView+WebCache.h"
#import "SMUCongrats.h"
#import "SMULetsMeet.h"
#import "SMULetsMeetReceiverPopup.h"
#import "SMUSharedReco.h"
#import "SMURecoGrouping.h"
#import "SMUCloseABRecoUserA.h"
#import "SMUCloseABReco.h"
#import "SMUCloseABRecoUserC.h"
#import "SMUCloseBCReco.h"
#import "SMUCloseBCRecoUserA.h"
#import "SMUCloseBCRecoUserB.h"
#import "ITSideMenu.h"
#import "SMUBannerView.h"

@interface SMURecoListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger imageDownloaderIndex,imageDownloaderIndexBC;
    BOOL isDismissInPregress;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *recos;
@property (nonatomic, strong) NSMutableArray *recosBC;
@property (nonatomic, strong) NSMutableArray *presentedViewControllers;
@property (nonatomic,strong) SMUBannerView *bannerView;
@end

@implementation SMURecoListViewController
SMURecoGrouping *recoGroup;

- (void)viewDidLoad
{
    //NSLog(@"reco list view didload");
    
    NSString *introFlag = @"no";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:introFlag forKey:@"introflag"];
    
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    _checkSelection = @"NO";
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    //NSLog(@"reco list view did appear");
    
    NSString *introFlag=[[NSUserDefaults standardUserDefaults] objectForKey:@"introflag"];
    if([introFlag isEqualToString:@"yes"])
    {
        NSString *introFlag = @"no";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:introFlag forKey:@"introflag"];
    _bannerView = [[SMUBannerView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _bannerView.backgroundColor = appCommonItemsUIColor;
    _bannerView.msgLabel.text = @"Intro sent successfully";
    _bannerView.iconImage.image = [UIImage imageNamed:@"new_int"];
    [self.view addSubview:_bannerView];
    [self performSelector:@selector(changeText:) withObject:nil afterDelay:2];
    }
    [SMUSharedReco sharedReco];
    [self loadRecoTable];
}


-(void)changeText:(id)sender {
    //_letsMeetLbl.hidden = YES;
    [_bannerView removeFromSuperview];
}

-(void)loadRecoTable{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=[shRes getFbLoggedInUserId];
    
    [SMUWebServices getRecentGroupingStatusWithAccessToken:fbAccessToken forUserId:fbUserId type:@"recoscreen"  success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"responseObject :%@",responseObject);
         
         recoGroup =(SMURecoGrouping *)responseObject;
         //NSLog(@"recogroup:%d and %d",[recoGroup.recoABs count],[recoGroup.recoBCs count]);
         _closedRecoCount = [recoGroup.recoABs count]+[recoGroup.recoBCs count];
         [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //NSLog(@"error :%@",error);
     }];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _closedRecoCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecoTableViewCell";
    SMURecoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    if(indexPath.row < [recoGroup.recoABs count]) {
       // NSLog(@"recoAB table");
        SMUCloseABReco *closeAB = (SMUCloseABReco *)[recoGroup.recoABs objectAtIndex:indexPath.row];
        SMUCloseABRecoUserA *recoA = closeAB.recoABUserA;
        
        NSMutableArray *recoCArray = closeAB.recoABUserCArray;
        SMUCloseABRecoUserC *recoC = (SMUCloseABRecoUserC *)[recoCArray objectAtIndex:0];
        if([recoCArray count] <= 1) {
            cell.notoficationImageView.hidden = YES;
            NSString *str=[NSString stringWithFormat:@"Wants to meet %@ Introduce %@!",recoC.first_name,recoA.first_name];
            cell.descLabel.text = str;
        } else {
            cell.notoficationImageView.hidden = NO;
             cell.descLabel.text = @"Wants to meet some of your friends";
        }
        NSString *notificationCnt  =[NSString stringWithFormat:@"+%d",[recoCArray count]-1];
        [cell.profileImageView setImageWithURL:[NSURL URLWithString:recoA.imgUrl] placeholderImage:nil];
        [cell.rightSideImageView setImageWithURL:[NSURL URLWithString:recoC.imgUrl] placeholderImage:nil];
        cell.titleLabel.text = recoA.first_name;
        cell.titleLabelTwo.text=recoC.first_name;
        cell.notificationCountLabel.text = notificationCnt;
    } else {
        //NSLog(@"recoBC table");
        int recoBCIndex = indexPath.row-[recoGroup.recoABs count];
        SMUCloseBCReco *closeBC = (SMUCloseBCReco *)[recoGroup.recoBCs objectAtIndex:recoBCIndex];
        SMUCloseBCRecoUserB *recoB = closeBC.recoBCUserB;
        NSMutableArray *recoAArray = closeBC.recoBCUserAArray;
        if([recoAArray count] <= 1) {
            cell.notoficationImageView.hidden = YES;
        } else {
            cell.notoficationImageView.hidden = NO;
        }

        SMUCloseBCRecoUserA *recoA = (SMUCloseBCRecoUserA *)[recoAArray objectAtIndex:0];
        NSString *notificationCnt = [NSString stringWithFormat:@"+%d",[recoAArray count]-1];
        [cell.profileImageView setImageWithURL:[NSURL URLWithString:recoB.imgUrl] placeholderImage:nil];
        [cell.rightSideImageView setImageWithURL:[NSURL URLWithString:recoA.imgUrl] placeholderImage:nil];
        cell.titleLabel.text = recoB.first_name;
        cell.titleLabelTwo.text=recoA.first_name;
        cell.descLabel.text = @"Recommended";
        cell.notificationCountLabel.text = notificationCnt;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _checkSelection = @"YES";
    if(indexPath.row < [recoGroup.recoABs count]) {
        SMUCloseABReco *closeAB = (SMUCloseABReco *)[recoGroup.recoABs objectAtIndex:indexPath.row];
        SMUCloseABRecoUserA *recoA = closeAB.recoABUserA;
        [self showRecoAB:recoA.userid];
    } else {
        int recoBCIndex = indexPath.row-[recoGroup.recoABs count];
        SMUCloseBCReco *closeBC = (SMUCloseBCReco *)[recoGroup.recoBCs objectAtIndex:recoBCIndex];
        SMUCloseBCRecoUserB *recoB = closeBC.recoBCUserB;
        [self showRecoBC:recoB.userid];
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:_checkSelection];
    [def setObject:data1 forKey:@"checkSelection"];
 //   [self showRecoAB];
   // [self showRecoBC];
}
#pragma mark - Reco AB
- (void)showRecoAB:(NSString *)selectedUserId
{
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    //If AB reco means need to pass A_userid as selectedUserId
    [SMUWebServices getClosedRecoStatusWithAccessToken:fbAccessToken forUserId:fbUserId type:@"AB" selectedUserId:selectedUserId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"responseObject :%@",responseObject);
         [self presentRecoABViewControllerWithRecos:responseObject];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //NSLog(@"error :%@",error);
     }];

    
    
//    [SMUWebServices getRecoStatusWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"abreco" success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"responseObject :%@",responseObject);
//         [self presentRecoABViewControllerWithRecos:responseObject];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"error :%@",error);
//     }];
}

- (void)downloadRecoABUserAProfileImage
{
    if(imageDownloaderIndex < _recos.count)
    {
        SMURecoUserA *recoUserA = [(SMURecoAB *) _recos[imageDownloaderIndex] userA];
        [self downloadImageForRecoUserA:recoUserA];
    }
    else
    {
        //  We have downloaded all images
        //  Now we can present Reco AB
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Reco" bundle:nil];
        UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"RecoABNVC"];
        SMURecoABViewController *recoABViewController = (SMURecoABViewController *)navigationController.viewControllers[0];
        recoABViewController.recos = _recos;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}
- (void)downloadImageForRecoUserA:(SMURecoUserA *)recoUserA
{
    NSURL *requestURL = [NSURL URLWithString:recoUserA.img_url];
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:recoUserA.img_url]];
    [self downloadImageFromURL:requestURL success:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //
        recoUserA.image = image;
        imageDownloaderIndex++;
        [self downloadRecoABUserAProfileImage];
    } failure:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //
        imageDownloaderIndex++;
        [self downloadRecoABUserAProfileImage];
    }];
}
- (void)presentRecoABViewControllerWithRecos:(NSMutableArray *)recos
{
    _recos = recos;
    imageDownloaderIndex = 0;
    [self downloadRecoABUserAProfileImage];
}
#pragma mark - Reco BC

- (void)showRecoBC:(NSString *)selectedUserId
{
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    //If BC reco means need to pass B_userid as selectedUserId
    [SMUWebServices getClosedRecoStatusWithAccessToken:fbAccessToken forUserId:fbUserId type:@"BC" selectedUserId:selectedUserId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"responseObject :%@",responseObject);
         [self presentRecoBCViewControllerWithRecos:responseObject];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"error :%@",error);
     }];
    
//    [SMUWebServices getRecoStatusWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"bcreco" success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"responseObject :%@",responseObject);
//         [self presentRecoBCViewControllerWithRecos:responseObject];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"error :%@",error);
//     }];
}
- (void)downloadRecoBCUserAProfileImage
{
    if(imageDownloaderIndexBC < _recosBC.count)
    {
        SMURecoUserB *recoUserB = [(SMUBCReco *) _recosBC[imageDownloaderIndexBC] userB];
        [self downloadImageForRecoUserB:recoUserB];
    }
    else
    {
        //  We have downloaded all images
        //  Now we can present Reco BC
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Reco" bundle:nil];
        UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"RecoCNVC"];
        SMURecoCViewController *recoBCViewController = (SMURecoCViewController *)navigationController.viewControllers[0];
        recoBCViewController.recos = _recosBC;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}
- (void)downloadImageForRecoUserB:(SMURecoUserB *)recoUserB
{
    
    [self downloadImageFromURL:[NSURL URLWithString:recoUserB.imageUrl] success:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //
       // NSLog(@"recoUserB.image :%@",image);
        recoUserB.image = image;
        imageDownloaderIndexBC++;
        [self downloadRecoBCUserAProfileImage];
    } failure:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //
        imageDownloaderIndexBC++;
        [self downloadRecoBCUserAProfileImage];
    }];
    //
    //
    //
    //    [self downloadImageFromURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //        //
    //        recoUserB.image = image;
    //        imageDownloaderIndex++;
    //        [self downloadRecoBCUserAProfileImage];
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //        //
    //        imageDownloaderIndex++;
    //        [self downloadRecoBCUserAProfileImage];
    //    }];
    
    //    [[[UIImageView alloc]init] setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //        success(request,response,image);
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //        failure(request,response,error);
    //    }];
}

- (void)presentRecoBCViewControllerWithRecos:(NSMutableArray *)recos
{
    _recosBC = recos;
    imageDownloaderIndexBC = 0;
    [self downloadRecoBCUserAProfileImage];
}

#pragma mark - Download Image

//- (void)downloadImageFromURLRequest:(NSURLRequest *)urlRequest
//                            success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
//                            failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
//{
//    [[[UIImageView alloc]init] setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        success(request,response,image);
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        failure(request,response,error);
//    }];
//}
- (void)downloadImageFromURL:(NSURL *)requestURL
                     success:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished))success
                     failure:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished))failure
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:requestURL options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (error) {
            failure(image,error,cacheType,finished);
        }
        else
        {
            success(image,error,cacheType,finished);
        }
    }];
    
    //    [[[UIImageView alloc]init] setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //        success(request,response,image);
    //    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    //        failure(request,response,error);
    //    }];
}
- (void)recoVCDismissed:(NSNotification *)notification
{
    if(!isDismissInPregress)
    {
       // NSLog(@"dismiss in progress");
        isDismissInPregress = YES;
        UIViewController *dismissVC = notification.object;
        [dismissVC dismissViewControllerAnimated:YES completion:^{
            [_presentedViewControllers removeObject:notification.object];
            isDismissInPregress = NO;
            

            //NSLog(@"_presentedViewControllers :%@",_presentedViewControllers);
        }];
    }
}

- (IBAction)showLeftMenuPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)refreshButtonPressed:(id)sender {
    
    [self loadRecoTable];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
