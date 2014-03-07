//
//  SMUSharedReco.m
//  SetMeUp
//
//  Created by In on 25/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUSharedReco.h"
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
#import "SMUUpdateUserLocation.h"
#import "SMUUserCInvite.h"
#import "SMUInviteUserCViewController.h"
#import "SMUInviteUserCViewController.h"

@interface SMUSharedReco()
{
    NSUInteger imageDownloaderIndex,imageDownloaderIndexBC;
    BOOL isDismissInPregress;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer1;
//@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *recos;
@property (nonatomic, strong) NSMutableArray *recosBC;
@property (nonatomic, strong) NSMutableArray *presentedViewControllers;
@end

@implementation SMUSharedReco
+(SMUSharedReco *)sharedReco
{
	static dispatch_once_t p = 0;
	__strong static id _sharedReco = nil;
	dispatch_once(&p, ^{
		_sharedReco = [[self alloc] init];
        [_sharedReco checkRecoStatus];
        [_sharedReco initProcess];
        [_sharedReco updateUserLocations];
      // [_sharedReco checkBroadCastStatus];
    });
	return _sharedReco;
}
- (id)init
{
    self = [super init];
    if (self) {
        _presentedViewControllers = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoVCDismissed:) name:@"recoVCDismissedNotification" object:nil];
    }
    return self;
}
- (void)initProcess
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(checkRecoStatus) userInfo:nil repeats:YES];
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:900.0 target:self selector:@selector(updateUserLocations) userInfo:nil repeats:YES];
//    _timer1 = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkBroadCastStatus) userInfo:nil repeats:YES];
    _aUserForCongrats = [[NSMutableArray alloc]init];
    _cUserForCongrats = [[NSMutableArray alloc]init];
    _letsMeetArray = [[NSMutableArray alloc]init];
    _broadcastArray = [[NSMutableArray alloc]init];
}
#pragma mark - Check Reco Status

- (void)checkRecoStatus
{
    
    NSString *connID = [NSString stringWithFormat:@""];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:connID forKey:@"connMatchID"];
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    [SMUWebServices getRecentStatusWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         SMURecentStatus *recentStatus = (SMURecentStatus *)responseObject;
//         if(recentStatus.cRecoCount > 0)
//             [self showRecoBC];
//         if(recentStatus.bRecoCount > 0)
//             [self showRecoAB];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RecentStatusUpdated" object:nil userInfo:@{@"RecentStatus": recentStatus}];
         //NSLog(@"date ID:%d and breco count:%d",recentStatus.dateSuggId,recentStatus.bRecoCount);
         if(recentStatus.dateSuggId != 0) {
             [self setDetailsforLetsMeetModel:recentStatus.dateSuggId];
             
         }
         if(recentStatus.googleDateSuggId != 0) {
             [self setDetailsforLetsMeetModel:recentStatus.googleDateSuggId];
         }
         if (recentStatus.connMatchId != 0) {
             
             
             NSString *connID = [NSString stringWithFormat:@"%d",recentStatus.connMatchId];
             NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
             [def setObject:connID forKey:@"connMatchID"];
             [self setDetailsIntoCongratsModel];
         }
         if(recentStatus.broadcastCount != 0) {
             [self showBroadCastPopup];
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check your network connection" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
         //alert.tag=FOF_LIST_FAIL_ALERT;
         [alert show];
     }];
}

- (void)updateUserLocations
{
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
  //  NSLog(@"inside update location");
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    
    
    //NSLog(@"update location JSON array:%@ and %f",[self createLocationJSONFormatWithLatitude:lat withLongitude:lon],self.locationManager.location.coordinate.latitude);
    
    
    
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    NSLog(@"did update map view");
////    _mapView.centerCoordinate =
////    userLocation.location.coordinate;
//}



-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //CLLocation *location = [locations lastObject];
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
   // NSLog(@"start updating user locations:%f",location.coordinate.latitude);
    NSString *lat = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
    [SMUWebServices updateLocationWithAccessToken:fbAccessToken forUserId:fbUserId withLocationArray:[self createLocationJSONFormatWithLatitude:lat withLongitude:lon] success:^(AFHTTPRequestOperation *operation, id responseObject) {
         _mapView.showsUserLocation = NO;
         [self.locationManager stopUpdatingLocation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check your network connection" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
//        //alert.tag=FOF_LIST_FAIL_ALERT;
//        [alert show];
    }];
    
   // [self.locationManager stopUpdatingLocation];
}

//- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    CLLocation *location = [locations lastObject];
////    lastLocation = location.coordinate;
////    _latitudeLabel.text = [NSString stringWithFormat:@"Current latitude: %f", location.coordinate.latitude];
////    _longitudeLabel.text = [NSString stringWithFormat:@"Current longitude: %f", location.coordinate.longitude];
////    _altitudeLabel.text = [NSString stringWithFormat:@"Current altitude: %f m", location.altitude];
//}


-(void)showBroadCastPopup {
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    [SMUWebServices getBroadcastsWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       
         _broadcastArray = responseObject;
        // [_broadcastArray addObject:responseObject];
         [self presentBroadCastViewController:responseObject];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //NSLog(@"error :%@",error);
     }];
    
}

-(NSString *)createLocationJSONFormatWithLatitude:(NSString *)lattitude withLongitude:(NSString *)longitude{
    NSString *jsonString;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:lattitude forKey:@"latitude"];
    [dict setObject:longitude forKey:@"longitude"];
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

-(void)presentBroadCastViewController:(NSMutableArray *)broadcastArr {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"BroadCastReceivedNVC"];
    
//    SMURecoCViewController *recoBCViewController = (SMURecoCViewController *)navigationController.viewControllers[0];
//    recoBCViewController.recos = _recosBC;
    
    
    [self presentRecoViewController:navigationController];
}



#pragma mark - Present VC
- (void)presentRecoViewController:(UIViewController *)viewController
{
    static BOOL isPresentationInPregress;
    if(!isPresentationInPregress && !isDismissInPregress)
    {
        isPresentationInPregress = YES;
        if(_presentedViewControllers.count)
        {
            UIViewController *presenter = (UIViewController *)[_presentedViewControllers lastObject];
            [presenter presentViewController:viewController animated:YES completion:^{
                [_presentedViewControllers addObject:viewController];
                isPresentationInPregress = NO;
            }];
        }
        else
        {
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:viewController animated:YES completion:^{
                [_presentedViewControllers addObject:viewController];
                isPresentationInPregress = NO;
            }];
        }
    }
    else
    {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self presentRecoViewController:viewController];
        });
    }
    //NSLog(@"_presentedViewControllers :%@",_presentedViewControllers);
}
- (void)recoVCDismissed:(NSNotification *)notification
{
    if(!isDismissInPregress)
    {
        //NSLog(@"dismiss in progress");
        isDismissInPregress = YES;
        UIViewController *dismissVC = notification.object;
        [dismissVC dismissViewControllerAnimated:YES completion:^{
            [_presentedViewControllers removeObject:notification.object];
            isDismissInPregress = NO;

            
            NSString *flag=[[NSUserDefaults standardUserDefaults] objectForKey:@"flag"];
            NSArray *nonSMUUserArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"nonSMUUserArray"];
            //NSLog(@"flag value:%@ and nonsmuuser:%@",flag,nonSMUUserArray);
            
        if([flag isEqualToString:@"InvitePopup"]) {
            //NSLog(@"come inside invite popup");
            NSMutableArray *nonSmuArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in nonSMUUserArray) {
                    SMUUserCInvite *ConnectedUser = [[SMUUserCInvite alloc] init];
                    [ConnectedUser setNonsmuUserWithDict:dic];
                    [nonSmuArray addObject:ConnectedUser];
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InviteUserCNVC"];
            SMUInviteUserCViewController *inviteViewController = (SMUInviteUserCViewController *)navigationController.viewControllers[0];
            inviteViewController.inviteCUserDetails=nonSmuArray;
            [self presentRecoViewController:navigationController];
            //NSLog(@"After processing");
           // NSLog(@"_presentedViewControllers :%@",_presentedViewControllers);
        }

        }];
    }
}
#pragma mark - Reco AB
- (void)showRecoAB
{
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;

    [SMUWebServices getRecoStatusWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"abreco" success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"responseObject :%@",responseObject);
        [self presentRecoABViewControllerWithRecos:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check your network connection" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        //alert.tag=FOF_LIST_FAIL_ALERT;
        [alert show];
    }];
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
        [self presentRecoViewController:navigationController];
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

- (void)showRecoBC
{
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    [SMUWebServices getRecoStatusWithAccessToken:fbAccessToken forUserId:fbUserId withRecoType:@"bcrecomulti" success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"responseObject :%@",responseObject);
         [self presentRecoBCViewControllerWithRecos:responseObject];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check your network connection" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
         //alert.tag=FOF_LIST_FAIL_ALERT;
         [alert show];
     }];
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
        [self presentRecoViewController:navigationController];
    }
}
- (void)downloadImageForRecoUserB:(SMURecoUserB *)recoUserB
{
    
    [self downloadImageFromURL:[NSURL URLWithString:recoUserB.imageUrl] success:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //
        //NSLog(@"recoUserB.image :%@",image);
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

#pragma mark - LetsMeet Popup
-(void)setDetailsforLetsMeetModel:(NSInteger)matchId {
    
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LetsMeetNVC"];
//    SMULetsMeetReceiverPopup *recoABViewController = (SMULetsMeetReceiverPopup *)navigationController.viewControllers[0];
//   // recoABViewController.recos = _recos;
   // [self presentRecoViewController:navigationController];
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
[SMUWebServices getShowDateRequsetWithAccessToken:fbAccessToken forUserId:fbUserId withConnectionMatchId:matchId success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
    NSMutableArray *fofs = [NSMutableArray array];
    NSArray *user_c_details = [responseObject objectForKey:@"DateDetails"];
    for (NSDictionary *dic in user_c_details) {
        SMULetsMeet *letsMeet = [[SMULetsMeet alloc] init];
        [letsMeet setLetsMeetWithDict:dic];
        [fofs addObject:letsMeet];
    }
    [_letsMeetArray addObjectsFromArray:fofs];
    [self showLetsMeetPopup];
    
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check your network connection" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
    //alert.tag=FOF_LIST_FAIL_ALERT;
    [alert show];
}];
}


-(void)showLetsMeetPopup {
    
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LetsMeetNVC"];
    //SMULetsMeetReceiverPopup *letsMeetVC = (SMULetsMeetReceiverPopup *)navigationController.viewControllers[0];
    [self presentRecoViewController:navigationController];
    
    //    letsMeetVC.letsMeetArray = _letsMeetArray;
   // [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Congrats Popup
- (void)setDetailsIntoCongratsModel
{
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    [SMUWebServices getCongratulationStatusWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray *aUsers = [NSMutableArray array];
        NSDictionary *user_a_details = [responseObject objectForKey:@"a_user"];
        
        SMUCongrats *congrats = [[SMUCongrats alloc] init];
        [congrats setConnectedUserFromDict:user_a_details];
        [aUsers addObject:congrats];
        
        [_aUserForCongrats removeAllObjects];
        [_aUserForCongrats addObjectsFromArray:aUsers];
        
        NSMutableArray *cUsers = [NSMutableArray array];
        NSDictionary *user_c_details = [responseObject objectForKey:@"c_user"];
        
        SMUCongrats *congratsc = [[SMUCongrats alloc] init];
        [congratsc setConnectedUserFromDict:user_c_details];
        [cUsers addObject:congratsc];
        
        [_cUserForCongrats removeAllObjects];
        [_cUserForCongrats addObjectsFromArray:cUsers];
        //
        
        [self showCongratsPopup];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)showCongratsPopup{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"CongratsNVC"];
//    SMUInviteUserCViewController *inviteViewController = (SMUInviteUserCViewController *)navigationController.viewControllers[0];
    [self presentRecoViewController:navigationController];
    //[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navigationController animated:YES completion:nil];
    
}


-(void)showInvitePopupWithAccessToken:(NSString *)fbAccessToken withUserId:(NSString *)fbUserId withRecoDetails:(NSString *)recoDetails withConnID:(NSString *)connId {
    
    [SMUWebServices sendCRecoWithAccessToken:fbAccessToken forUserId:fbUserId withRecoDetails:recoDetails forConnId:connId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = (NSArray *)[responseObject objectForKey:@"nonSmuUsers"];
        
        NSMutableArray *nonSmu=[[NSMutableArray alloc]init];
        if([array count]!=0){
            
            for (NSDictionary *dic in array) {
                SMUUserCInvite *ConnectedUser = [[SMUUserCInvite alloc] init];
                [ConnectedUser setNonsmuUserWithDict:dic];
                [nonSmu addObject:ConnectedUser];
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InviteUserCNVC"];
            SMUInviteUserCViewController *recoABViewController = (SMUInviteUserCViewController *)navigationController.viewControllers[0];
            recoABViewController.inviteCUserDetails=nonSmu;
            [self presentRecoViewController:navigationController];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check your network connection" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        //alert.tag=FOF_LIST_FAIL_ALERT;
        [alert show];
    }];

    
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"CongratsNVC"];
//    [self presentRecoViewController:navigationController];
}


-(void)showNoUserCPopup{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NoUserCNVC"];
    [self presentRecoViewController:navigationController];
}


#pragma mark - Services

- (SMURecentStatus *)getRecentStatus
{
    NSDictionary *JSON = [self dictionaryWithFileName:@"get_recent_status"];
    SMURecentStatus *recentStatus = [[SMURecentStatus alloc]init];
    [recentStatus setRectStatusFromDict:JSON];
    //NSLog(@"recentstatus :%@", recentStatus);
    return recentStatus;
}
- (NSMutableArray *)getRecoAB
{
    NSDictionary *JSON = [self dictionaryWithFileName:@"ABReco"];
    NSArray *recos = [JSON objectForKey:@"RecoDetails"];
    NSMutableArray *recoABs = [NSMutableArray array];
    for (NSDictionary *reco in recos) {
        SMURecoAB *singleReco = [[SMURecoAB alloc]init];
        [singleReco setSingleRecoDetailsWithDict:reco];
        [recoABs addObject:singleReco];
    }
    //NSLog(@"recoABs :%@", recoABs);
    return recoABs;
}
- (NSMutableArray *)getRecoBC
{
    NSDictionary *JSON = [self dictionaryWithFileName:@"BCReco"];
    NSArray *recos = [JSON objectForKey:@"reco_details"];
    NSMutableArray *recoBCs = [NSMutableArray array];
    for (NSDictionary *reco in recos) {
        SMUBCReco *bcReco = [[SMUBCReco alloc]init];
        [bcReco setBCRecoDetailsWithDict:reco];
        [recoBCs addObject:bcReco];
    }
    //NSLog(@"bcReco :%@", recoBCs);
    return recoBCs;
}
#pragma mark - Load local JSON

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
- (NSDictionary *)dictionaryWithContentOfFile:(NSString *)path
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //NSLog(@"error :%@",error);
    if(error)
        return nil;
    //NSLog(@"JSON :%@",JSON);
    return JSON;

}
- (NSDictionary *)dictionaryWithFileName:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
    NSDictionary *dic = [self dictionaryWithContentOfFile:path];
    return dic ;
}
@end
