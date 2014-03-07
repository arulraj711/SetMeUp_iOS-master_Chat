//
//  SMUUpdateUserLocation.m
//  SetMeUp
//
//  Created by ArulRaj on 2/9/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUUpdateUserLocation.h"
#import "SMUSharedResources.h"
#import "SMUUserProfile.h"
#import "SMUWebServices.h"
#import "SMURecentStatus.h"

@implementation SMUUpdateUserLocation
+(SMUUpdateUserLocation *)updateLocation
{
	static dispatch_once_t p = 0;
	__strong static id _updateLocation = nil;
	dispatch_once(&p, ^{
		_updateLocation = [[self alloc] init];
         [_updateLocation updateUserLocation];
        [_updateLocation checkBroadCastStatus];
         [_updateLocation initProcess];
    });
	return _updateLocation;
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
    _timer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(updateUserLocation) userInfo:nil repeats:YES];
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkBroadCastStatus) userInfo:nil repeats:YES];
}

- (void)updateUserLocation
{
    _mapView.showsUserLocation = YES;
    //NSLog(@"inside update location");
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    NSString *lat = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
    
    //NSLog(@"update location JSON array:%@",[self createLocationJSONFormatWithLatitude:lat withLongitude:lon]);
    
    [SMUWebServices updateLocationWithAccessToken:fbAccessToken forUserId:fbUserId withLocationArray:[self createLocationJSONFormatWithLatitude:lat withLongitude:lon] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)checkBroadCastStatus {
    //NSLog(@"broadcast status after 60 sec");
    //need to implement one service
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    [SMUWebServices getRecentStatusWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         SMURecentStatus *recentStatus = (SMURecentStatus *)responseObject;
         if(recentStatus.cRecoCount == 0)
             [self showBroadCastPopup];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //
     }];
}

-(void)showBroadCastPopup {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LetsMeetNVC"];
    [self presentRecoViewController:navigationController];
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
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LetsMeetNVC"];
            [self presentRecoViewController:navigationController];

            //NSLog(@"_presentedViewControllers in sharedreco:%@",_presentedViewControllers);
        }];
    }
}
@end
