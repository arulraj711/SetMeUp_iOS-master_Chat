//
//  SMUSharedResources.m
//  SetMeUp
//
//  Created by Go on 17/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUSharedResources.h"
#import "SMUWebServices.h"
#import "SMUUserProfile.h"
#import "SMUFriend.h"
#import "SMUFriendOfFriend.h"
#import "SMUAlertViewController.h"
#import "SMULoginViewController.h"
#import "SDWebImageManager.h"
#import "SMUFCConnectedUser.h"
#import "SMUCheckin.h"
#import "SMUHomeMessage.h"
#import "SMUSearchFilter.h"
#import "SMUInterns.h"
#import "SMUConnectUser.h"
#import "SMUSharedReco.h"
#import "SMUSetMeUpViewController.h"
#import "SMUTotalCheckin.h"

#define FOF_FETCH_INIT_LIMIT 50
#define FOF_FETCH_ITERATION_LIMIT 50
#define FRIENDS_LIST_FAIL_ALERT 102
#define FOF_LIST_FAIL_ALERT 103
#define CONN_USER_FAIL_ALERT 104

@interface SMUSharedResources () <UIAlertViewDelegate>

@property(nonatomic, strong) NSString *loggedUserId;
@property(nonatomic, readwrite) NSInteger currentFOFPage;

@property(nonatomic, readwrite) NSInteger totalFOFCount;
@property(nonatomic, readwrite) NSInteger fetchedFOFCount;
@property(nonatomic, readwrite) __block BOOL isIterationFetchingRunning;
@property(nonatomic,readwrite) NSInteger currentConnUserPage;
@property(nonatomic,readwrite) NSInteger totalConnUserCount;
@property(nonatomic,readwrite) NSInteger fetchedConnUserCount;
@property(nonatomic,readwrite) NSInteger runningMatchmakerIndex;
@property(nonatomic,readwrite) BOOL isAllMatchmakersChecked;

@property(nonatomic, readwrite) NSInteger searchType;
@property(nonatomic, readwrite) NSInteger searchOrder;
@property(nonatomic, readwrite) NSInteger minAge;
@property(nonatomic, readwrite) NSInteger maxAge;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *education;
@property(nonatomic, strong) NSString *workplace;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, readwrite) NSInteger searchFlag;
@end

@implementation SMUSharedResources
SMUSetMeUpViewController *smuVC;
+(SMUSharedResources*)sharedResourceManager
{
	static dispatch_once_t p = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&p, ^{
		_sharedObject = [[self alloc] init];
        [_sharedObject initDefaults];
    });
	return _sharedObject;
}

-(void)initDefaults
{

    _friends=[[NSMutableArray alloc] init];
    _matchMakers=[[NSMutableArray alloc] init];
    _friendOfFriendsList=[[NSMutableArray alloc] init];
    _connUsersList =[[NSMutableArray alloc]init];
    _checkinsList = [[NSMutableArray alloc]init];
    _profilPictureAlbum=[[NSMutableArray alloc]init];
    _letsMeetCheckin = [[NSMutableArray alloc]init];
    _chatConnUsersList = [[NSMutableArray alloc]init];
    _searchResult=[[NSMutableArray alloc]init];
    _internDetails=[[NSMutableArray alloc]init];
    _connectedUserForBroadcast=[[NSMutableArray alloc]init];
    smuVC=[[SMUSetMeUpViewController alloc]init];
    _isManualMatchMaking=NO;
    _isAllMatchmakersChecked=NO;
    _currentFOFPage=0;
    _totalFOFCount=0;
    _totalConnUserCount=0;
    _runningMatchmakerIndex=0;
    _currentConnUserPage = 0;
    _searchType=0;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFiltersUpdated) name:@"SearchCriteriaRetrived" object:nil];
    
    _mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

-(void)searchFiltersUpdated
{
    if (!_isManualMatchMaking) {
        _runningMatchmakerIndex-=4;
        if (_runningMatchmakerIndex<0)
            _runningMatchmakerIndex=0;
    }
    [self showProgressHUDForView];
    [self fetchInitialFOFList];
}

#pragma mark - Getter Setter methods

- (void)setMatchMakers:(NSMutableArray *)matchMakers
{
    [_matchMakers removeAllObjects];
    _isManualMatchMaking=YES;
    [_matchMakers addObjectsFromArray:matchMakers];
}

#pragma mark - Facebook methods

- (NSString*)getFbAccessToken;
{
    return [[[FBSession activeSession] accessTokenData] accessToken];
}

- (NSString*)getFbLoggedInUserId;
{
//  TODO: avoid using sync request to obatin the user details
    //if (_loggedUserId==nil) {
        NSString *urlStr=[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",[self getFbAccessToken]];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *req=[NSURLRequest requestWithURL:url];
        NSError *error;
        NSData *facebookData=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
        if (error!=nil) {
            //NSLog(@"FB USER PROFILE FETCH ERROR %@",[error localizedDescription]);
        }
        else{
            NSDictionary *facebookLoggedUserDetails= [NSJSONSerialization JSONObjectWithData:facebookData  options:kNilOptions error:&error];
            NSLog(@"fb dictionary:%@",facebookLoggedUserDetails);
            _loggedUserId=(NSString*)[facebookLoggedUserDetails objectForKey:@"id"];
        }
   // }
    return _loggedUserId;
}

- (BOOL)isFacebookLoggedIn{
    BOOL _isFbLoggedIn=NO;
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        _isFbLoggedIn=YES;
    }
    return _isFbLoggedIn;
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        //NSLog(@"Session opened");
        // Show the user the logged-in UI
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SMU_FBLOGIN_SUCCESS" object:nil];
        NSString *userId=[self getFbLoggedInUserId];
        NSLog(@"userId:%@",userId);
        if (userId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SMU_FBLOGIN_SUCCESS_AND_READY" object:nil];
            [self fetchUserProfile];
        }
        else{
            [self hideProgressHUDForView];
             [FBSession.activeSession closeAndClearTokenInformation];
            [self presentLogin];
        }
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        [self hideProgressHUDForView];
        // If the session is closed
                // Show the user the logged-out UI
    }
    // Handle errors
    if (error){
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"SetMeUp";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                [self hideProgressHUDForView];
                alertTitle = @"SetMeUp";
                alertText = @"We need you to login with Facebook and grant permission so you can get your friends and interests";
                [self showMessage:alertText withTitle:alertTitle];

               // NSLog(@"User cancelled login");
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                // Show the user an error message
                alertTitle = @"SetMeUp";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
    }
    [self presentLogin];
}

- (void)logoutFbUser;
{
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [[SDWebImageManager sharedManager] cancelAll];
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        [imageCache cleanDisk];
    }
}

#pragma mark - UserData fetch methods

-(void)fetchUserProfile{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=[self getFbLoggedInUserId];
    
   // NSString *deviceToken=_remoteNotificationDeviceToken;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"deviceToken"];
    NSString *deviceToken = [NSKeyedUnarchiver unarchiveObjectWithData:data1];

   // NSLog(@"devicetoken in fetchuserprofile:%@",deviceToken);
    SMUSharedResources * __weak weakSelf = self;
    [SMUWebServices loginWithAccessToken:fbAccessToken ofType:@"ios" forFbUserId:fbUserId withPushMessageDeviceToken:deviceToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int code=[[responseObject objectForKey:@"code"]integerValue];
        NSLog(@"code:%d",code);
        
        if(code==100){
        
        SMUUserProfile *userProfile = [[SMUUserProfile alloc] init];
        [userProfile setUserProfileWithDict:responseObject];
        
      //  SMUUserProfile *userProfile = (SMUUserProfile *)responseObject;
        [weakSelf setUserProfile:userProfile];
        
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:userProfile.profilePicture forKey:@"UserAId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileInformationRetrieved" object:nil userInfo:@{@"UserProfile": userProfile}];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showColoredBackgroud" object:nil];
        [weakSelf fetchUserFriends];
        }else{
            [self fetchUserProfile];
        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weakSelf logoutFbUser];
        [self presentLogin];
        [weakSelf hideProgressHUDForView];
    }];
}

-(void)fetchUserFriends{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=[_userProfile userID];
    SMUSharedResources * __weak weakSelf = self;
    [SMUWebServices getMatchmakerDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withSortingType:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_friends removeAllObjects];
        [_friends addObjectsFromArray:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserFriendsListRetrieved" object:nil userInfo:nil];
        [_matchMakers removeAllObjects];
        _isAllMatchmakersChecked=NO;
        [weakSelf fetchChatConnUser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideProgressHUDForView];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to fetch friends list" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        alert.tag=FRIENDS_LIST_FAIL_ALERT;
        [alert show];
    }];
    //  TODO: handle friends fetching failure case in err block
}


- (void)fetchInitialFOFList
{
    NSDictionary *searchFilters=[[NSUserDefaults standardUserDefaults] objectForKey:@"searchDetails"];
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
    SMUSharedResources * __weak weakSelf = self;
    if (!_isManualMatchMaking) {
        [self updateNextSetOfMatchmakers];
    }
    NSMutableArray *friendIDs = [NSMutableArray array];
    NSMutableArray *friendNames = [NSMutableArray array];
    for (int index = 0; index < [_matchMakers count]; index++) {
        SMUFriend * friend = _matchMakers[index];
        [friendIDs addObject:friend.userID];
        [friendNames addObject:friend.name];
    }
    NSString *friendsIdStr=[friendIDs componentsJoinedByString:@","];
    NSString *friendsNameStr=[friendNames componentsJoinedByString:@","];
    _currentFOFPage=0;
    _fetchedFOFCount=0;
    _totalFOFCount=0;
    [_friendOfFriendsList removeAllObjects];
    [SMUWebServices getUserCDetailsWithAccessToken:fbAccessToken
                                         forUserId:fbUserId
                              forSelectedFriendsID:friendsIdStr
                            andSelectedFriendsName:friendsNameStr
                                         withCount:FOF_FETCH_INIT_LIMIT
                                        withPageNO:_currentFOFPage
                                   andSearchParams:searchFilters
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               _totalFOFCount=[[responseObject objectForKey:@"total_cfriends"] integerValue];
                                               
                                               if(_totalFOFCount==0){
//
                                                   [smuVC hideUseLessView];
                                                       [weakSelf hideProgressHUDForView];
                                                //   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchDetails"];
                                               
                                                   // [[NSNotificationCenter defaultCenter] postNotificationName:@"noUserCFound" object:nil];
                                                   NSString *noUserC = [NSString stringWithFormat:@"YES"];
                                                   NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                                                   [def setObject:noUserC forKey:@"emptyResults"];
                                                   
                                               [self showNoUserCPopup];

                                                   
                                                   
//                                                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"We were't able to get matches for you..Please change the search filter" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                                                   [alert show];

                                                  // UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"We were't able to get matches for you..Please change the search filter" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                                  // [alert show];

//                                             
                                               }
//                                               NSString *noUserC = [NSString stringWithFormat:@"NO"];
//                                               NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//                                               [def setObject:noUserC forKey:@"noUserC"];
                                               NSMutableArray *fofs = [NSMutableArray array];
                                               NSArray *user_c_details = [responseObject objectForKey:@"user_c_details"];
                                               for (NSDictionary *dic in user_c_details) {
                                                   SMUFriendOfFriend *friendOfFriend = [[SMUFriendOfFriend alloc] init];
                                                   [friendOfFriend setUserCDetailsFromDictionary:dic];
                                                   [fofs addObject:friendOfFriend];
                                               }
                                               [_friendOfFriendsList addObjectsFromArray:fofs];
                                               if ([fofs count]==0) {
                                                   //as the result array is empty its assumed that there is no further UserC available
                                                   //if auto selection mode we have to queue with new matchmaker set
                                                   if (!_isManualMatchMaking) {
                                                       if (!_isAllMatchmakersChecked) {
                                                           [weakSelf fetchInitialFOFList];
                                                       }
                                                       else
                                                       {

//                                                           UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"We were't able to get matches for you." message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];

                                                           //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"We were't able to get matches for you." message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];

                                                           //[alert show];
                                                           [weakSelf hideProgressHUDForView];
                                                           _isAllMatchmakersChecked =NO;
                                                           _runningMatchmakerIndex=0;
                                                           return;
                                                           //worst case alert- occur only when all user C completed with all friends.
                                                       }
                                                   }
                                                   else
                                                   {
                                                       _isAllMatchmakersChecked=YES;
                                                       [weakSelf hideProgressHUDForView];

//                                                       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"It seems you ran out of possible matches.\nPlease try with a different Matchmaker" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];

                                                     //  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"It seems you ran out of possible matches.\nPlease try with a different Matchmaker" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];

                                                       //[alert show];
//                                                       [self showNoUserCPopup];
                                                   }
                                               }
                                               else{
                                                 
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"UserFOFListRetrieved" object:nil userInfo:nil];
                                                   _currentFOFPage++;
                                                   _fetchedFOFCount=[user_c_details count];
                                                   
                                                   [weakSelf hideProgressHUDForView];
                                                   if (_totalFOFCount==_fetchedFOFCount)
                                                       _isAllMatchmakersChecked=YES;
                                                   else
                                                       _isAllMatchmakersChecked=NO;
                                               }
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               [weakSelf hideProgressHUDForView];
                                               UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Unable to fetch your matches. Please check you internet connection and try again" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
                                               alert.tag=FOF_LIST_FAIL_ALERT;
                                               [alert show];
//                                               SMUAlertViewController *alert=[SMUAlertViewController sharedInstance];
//                                               [alert setUpAlertWithTitle:@"ERR" withSubTile:@"UserC failed" withOperation:operation];
//                                               [alert presentModelInRootViewController];
                                           }];
}

-(void)showNoUserCPopup{
//    NSString *noUserC = [NSString stringWithFormat:@"YES"];
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:noUserC forKey:@"noUserC"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NoUserCNVC"];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navigationController animated:YES completion:nil];
}

-(void)showSearchFilterView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController  *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"SMUSearchToolViewController"];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navigationController animated:YES completion:nil];
}
-(BOOL)iterateFOFListFetching
{
    if (_isIterationFetchingRunning) {
        return NO;
    }
    else if (_isAllMatchmakersChecked)
        return NO;

    
    NSDictionary *searchFilters=[[NSUserDefaults standardUserDefaults] objectForKey:@"searchDetails"];
    _isIterationFetchingRunning=YES;
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
    SMUSharedResources * __weak weakSelf = self;

    NSMutableArray *friendIDs = [NSMutableArray array];
    NSMutableArray *friendNames = [NSMutableArray array];
    for (int index = 0; index < [_matchMakers count]; index++) {
        SMUFriend * friend = _matchMakers[index];
        [friendIDs addObject:friend.userID];
        [friendNames addObject:friend.name];
    }
    NSString *friendsIdStr=[friendIDs componentsJoinedByString:@","];
    NSString *friendsNameStr=[friendNames componentsJoinedByString:@","];
    [SMUWebServices getUserCDetailsWithAccessToken:fbAccessToken
                                         forUserId:fbUserId
                              forSelectedFriendsID:friendsIdStr
                            andSelectedFriendsName:friendsNameStr
                                         withCount:FOF_FETCH_ITERATION_LIMIT
                                        withPageNO:_currentFOFPage
                                   andSearchParams:searchFilters
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               NSMutableArray *fofs = [NSMutableArray array];
                                               NSArray *user_c_details = [responseObject objectForKey:@"user_c_details"];
                                               for (NSDictionary *dic in user_c_details) {
                                                   SMUFriendOfFriend *friendOfFriend = [[SMUFriendOfFriend alloc] init];
                                                   [friendOfFriend setUserCDetailsFromDictionary:dic];
                                                   [fofs addObject:friendOfFriend];
                                               }
                                               [_friendOfFriendsList addObjectsFromArray:fofs];
                                               _currentFOFPage++;
                                               _fetchedFOFCount+=[user_c_details count];
                                               _isIterationFetchingRunning=NO;
                                               if (_totalFOFCount==_fetchedFOFCount)
                                                   _isAllMatchmakersChecked=YES;
                                               else
                                                   _isAllMatchmakersChecked=NO;
                                               [weakSelf hideProgressHUDForView];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"UserFOFListUpdated" object:nil userInfo:nil];
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              // NSLog(@"Silently ignoring the failure");
                                               _isIterationFetchingRunning=NO;
                                               [weakSelf hideProgressHUDForView];
                                           }];
    return YES;
}


- (void)endOflistingReachedInUserC;
{
    if (_isManualMatchMaking) {
        if (_totalFOFCount>_fetchedFOFCount) {
            [self showProgressHUDForView];
//            NSString *noUserC = [NSString stringWithFormat:@"NO"];
//            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//            [def setObject:noUserC forKey:@"noUserC"];
            //[def setObject:data1 forKey:@"noUserC"];
            [self iterateFOFListFetching];
        }
        else{
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"It seems you ran out of possible matches.\nPlease try with a different Matchmaker" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            
            NSString *noUserC = [NSString stringWithFormat:@"YES"];
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:noUserC forKey:@"emptyResults"];
            [self showNoUserCPopup];
        }
    }
    else{
        if (_totalFOFCount>_fetchedFOFCount) {
            [self showProgressHUDForView];
            [self iterateFOFListFetching];
        }
        else{
            [self showProgressHUDForView];
            [self fetchInitialFOFList];
        }
    }
}

-(void)fetchUserProfilePictures{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=[self getFbLoggedInUserId];
    
    [SMUWebServices getUserAProfilePictureWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
       // NSLog(@"response for profile:%@",responseObject);
        [_profilPictureAlbum removeAllObjects];
        [_profilPictureAlbum addObjectsFromArray:responseObject];
        
              [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfilePicturesRetrieved" object:nil userInfo:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to fetch user profile" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        //alert.tag=FOF_LIST_FAIL_ALERT;
        [alert show];
    }];
}
-(void)fetchConnectedUserForBC{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=[self getFbLoggedInUserId];
    
    [SMUWebServices getConnectUsersWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *fofs = [NSMutableArray array];
        NSArray *intern_details = (NSArray *)[responseObject objectForKey:@"connected_users"];
        if([intern_details count]!=0)
        {
        for (NSDictionary *dic in intern_details) {
            SMUConnectUser *interns = [[SMUConnectUser alloc] init];
            [interns setConnectedDetailsWithDict:dic];
            [fofs addObject:interns];
        }
        
        [_connectedUserForBroadcast removeAllObjects];
        [_connectedUserForBroadcast addObjectsFromArray:fofs];
    
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectedUserForBCFetched" object:nil userInfo:nil];
    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)fetchConnUser {
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
     SMUSharedResources * __weak weakSelf = self;
    _totalConnUserCount = 0;
    _currentConnUserPage = 0;
    // _fetchedConnUserCount = 0;
    [_connUsersList removeAllObjects];
    
    [SMUWebServices getPlaceMakerIndexWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"inside fetch conn user shared resource");
         [weakSelf hideProgressHUDForView];
        int responseCode = [[responseObject objectForKey:@"code"] intValue];
        if(responseCode == 300) {
            //_totalConnUserCount=[[responseObject objectForKey:@"total_connecteduser_count"] integerValue];
       
            NSMutableArray *fofs = [NSMutableArray array];
            NSArray *user_c_details = [responseObject objectForKey:@"connected_users"];
            for (NSDictionary *dic in user_c_details) {
                SMUFCConnectedUser *friendOfFriend = [[SMUFCConnectedUser alloc] init];
                [friendOfFriend setFCConnUserWithDict:dic];
                [fofs addObject:friendOfFriend];
            }
            
            [_connUsersList addObjectsFromArray:fofs];
            _fetchedConnUserCount = [user_c_details count];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnUserListRetrieved" object:nil userInfo:nil];
        } else {
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No connections available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to fetch connected users" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        alert.tag=CONN_USER_FAIL_ALERT;
        [alert show];
    }];
}

-(void)showSelectedCheckin:(NSString *)UserID {
    [_checkinsList removeAllObjects];
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
    [SMUWebServices getSelectedCheckinsWithAccessToken:fbAccessToken forUserId:fbUserId withSelectedUser:UserID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *fofs = [NSMutableArray array];
      // NSDictionary *user_c_details = [responseObject objectForKey:@"checkins"];
       //for (NSDictionary *dic in user_c_details) {
            //NSLog(@"for loop:%@",user_c_details);
            SMUTotalCheckin *totalCheckin = [[SMUTotalCheckin alloc] init];
            [totalCheckin setFCConnUserWithDict:responseObject];
            [fofs addObject:totalCheckin];
       // }
        
        [_checkinsList addObjectsFromArray:fofs];
       // NSLog(@"checkins list:%@",_checkinsList);
        //_fetchedConnUserCount = [user_c_details count];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckinsRetrieved" object:nil userInfo:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to fetch checkin details" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        //alert.tag=FOF_LIST_FAIL_ALERT;
        [alert show];
    }];
    
}

//- (void)fetchNextConnUserList {
//    NSString *fbAccessToken=[self getFbAccessToken];
//    NSString *fbUserId=_userProfile.userID;
//    // SMUSharedResources * __weak weakSelf = self;
//    // _totalConnUserCount = 0;
//    _currentConnUserPage++;
//    //[_connUsersList removeAllObjects];
////    [SMUWebServices getPlaceMakerIndexWithAccessToken:fbAccessToken forUserId:fbUserId withConnType:@"connectionReference" withCount:5 pageNo:_currentConnUserPage withConnId:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        //  NSLog(@"inside fetch conn user shared resource");
////        // _totalConnUserCount=[[responseObject objectForKey:@"total_connecteduser_count"] integerValue];
////        NSMutableArray *fofs = [NSMutableArray array];
////        NSArray *user_c_details = [responseObject objectForKey:@"connected_users_checkins"];
////        for (NSDictionary *dic in user_c_details) {
////            SMUFCConnectedUser *friendOfFriend = [[SMUFCConnectedUser alloc] init];
////            [friendOfFriend setFCConnUserWithDict:dic];
////            [fofs addObject:friendOfFriend];
////        }
////        
////        [_connUsersList addObjectsFromArray:fofs];
////        _fetchedConnUserCount += [user_c_details count];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"NextConnUserListRetrieved" object:nil userInfo:nil];
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        
////    }];
//}
//
//- (BOOL)iterateNextConnUser {
//    
//    if(_totalConnUserCount>_fetchedConnUserCount) {
//        return YES;
//    }
//    return NO;
//}

- (void)fetchDateSuggestionDetails:(NSString *)placeId withSelectedUserId:(NSString *)selectedUserId withType:(NSString *)type{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
    [_letsMeetCheckin removeAllObjects];
    [SMUWebServices dateSuggestionWithAccessToken:fbAccessToken forUserId:fbUserId withPlaceId:placeId withSelectedUserId:selectedUserId withType:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *fofs = [NSMutableArray array];
        NSDictionary *dic = [responseObject objectForKey:@"checkin"];
        
        SMUCheckin *checkin = [[SMUCheckin alloc] init];
        [checkin setCheckinsWithDict:dic];
        [fofs addObject:checkin];
        
        [_letsMeetCheckin addObjectsFromArray:fofs];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LetsMeetCheckinRetrieved" object:nil userInfo:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)fetchChatConnUser {
   // NSLog(@"fetch chat connected user list");
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
    SMUSharedResources * __weak weakSelf = self;
    [SMUWebServices getMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"Home" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_chatConnUsersList removeAllObjects];
        SMUHomeMessage *homeMessage = [[SMUHomeMessage alloc]init];
        [homeMessage setHomeMessageWithDict:responseObject];
        
        
        [_chatConnUsersList addObject:homeMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUsersRetrievedSuccessfully" object:nil userInfo:nil];
        [weakSelf fetchInitialFOFList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to fetch connected users" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        //alert.tag=FOF_LIST_FAIL_ALERT;
        [alert show];
    }];
}

- (void)fetchChatList {
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
   // SMUSharedResources * __weak weakSelf = self;
    [SMUWebServices getMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"Home" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_chatConnUsersList removeAllObjects];
        SMUHomeMessage *homeMessage = [[SMUHomeMessage alloc]init];
        [homeMessage setHomeMessageWithDict:responseObject];
        
        
        [_chatConnUsersList addObject:homeMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUsersRetrievedSuccessfully" object:nil userInfo:nil];
       // [weakSelf fetchInitialFOFList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to fetch connected users" message:@"" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        //alert.tag=FOF_LIST_FAIL_ALERT;
        [alert show];
    }];
}

-(void)fetchSearchResult:(NSString *)forKey withType:(NSString *)type{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=_userProfile.userID;
    
    [SMUWebServices getSearchResultsWithAccessToken:fbAccessToken forUserId:fbUserId withSearchType:type forKey:forKey success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = (NSArray *)[responseObject objectForKey:@"Suggestions"];
        [_searchResult removeAllObjects];
        if([array count]>0){
        NSMutableArray *suggestions = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            SMUSearchFilter *filter = [[SMUSearchFilter alloc] init];
            [filter setvalueforAutofilldataWithDict:dic];
            [suggestions addObject:filter];
        }
            
            [_searchResult addObjectsFromArray:suggestions];
        }
      // NSLog(@"count of searchresult:%d",[_searchResult count]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchResultFetched" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)fetchInternUsers{
    NSString *fbAccessToken=[self getFbAccessToken];
    NSString *fbUserId=[self getFbLoggedInUserId];
    [SMUWebServices getInternUsersWithAccessToken:fbAccessToken forUserId:fbUserId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      //  NSLog(@"coming into fetchinterns");
        NSMutableArray *fofs = [NSMutableArray array];
        NSArray *intern_details = (NSArray *)[responseObject objectForKey:@"internDetails"];
        for (NSDictionary *dic in intern_details) {
            SMUInterns *interns = [[SMUInterns alloc] init];
            [interns setInternDetailsFromDict:dic];
            [fofs addObject:interns];
        }
        
        [_internDetails addObjectsFromArray:fofs];
        
               [[NSNotificationCenter defaultCenter] postNotificationName:@"InternDetailsFetched" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

-(void)detailsForEdit{
    
}
#pragma mark - Helpers

-(void)updateNextSetOfMatchmakers{
    if ([_friends count]>_runningMatchmakerIndex) {
        [_matchMakers removeAllObjects];
        for (int i=_runningMatchmakerIndex; i<[_friends count]; i++) {
            [_matchMakers addObject:[_friends objectAtIndex:i]];
            _runningMatchmakerIndex++;
            if ([_matchMakers count]>3) {
                break;
            }
        }
    }
    else{
        _isAllMatchmakersChecked=YES;
    }
}

-(void)showMessage:(NSString*)msg withTitle:(NSString*)title;
{

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];

  
}

- (void)showProgressHUDForViewWithTitle:(NSString*)title withDetail:(NSString*)detail;
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] windows][0] animated:YES];
    [hud setLabelText:title];
    [hud setDetailsLabelText:detail];
}

- (void)showProgressHUDForView
{
    [self showProgressHUDForViewWithTitle:nil withDetail:nil];
}

- (void)hideProgressHUDForView
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] windows][0] animated:YES];
}

- (void)presentLogin{
    if (!_isLoginPresented) {
        _isLoginPresented=YES;
        UIViewController *LoginViewController = [self.mainStoryBoard instantiateViewControllerWithIdentifier:@"SMULoginViewController"];
        [[[[UIApplication sharedApplication] windows][0] rootViewController] presentViewController:LoginViewController animated:YES completion:NULL];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger alertTag=alertView.tag;
    if (alertTag==FRIENDS_LIST_FAIL_ALERT) {
        [self showProgressHUDForView];
        [self fetchUserFriends];
    }
    else if (alertTag==FOF_LIST_FAIL_ALERT){
        [self showProgressHUDForView];
        [self fetchInitialFOFList];
    }
    else if(alertTag==CONN_USER_FAIL_ALERT) {
        [self showProgressHUDForView];
        [self fetchConnUser];
    }
}

@end
