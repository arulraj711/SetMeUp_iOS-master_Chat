//
//  SMUSharedResources.h
//  SetMeUp
//
//  Created by Go on 17/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

@class SMUUserProfile;

@interface SMUSharedResources : NSObject

@property (nonatomic, strong) NSString *remoteNotificationDeviceToken;
@property (nonatomic, strong) SMUUserProfile *userProfile;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *matchMakers;
@property (nonatomic, strong) NSMutableArray *friendOfFriendsList;
@property (nonatomic,strong) NSMutableArray *connUsersList;
@property(nonatomic,strong) NSMutableArray *checkinsList;
@property (nonatomic,strong) NSMutableArray *letsMeetCheckin;
@property (nonatomic, strong) NSMutableArray *profilPictureAlbum;
@property (nonatomic,strong) NSMutableArray *chatConnUsersList;
@property (nonatomic,strong) NSMutableArray *searchResult;
@property (nonatomic,strong) NSMutableArray *internDetails;
@property (nonatomic,strong) NSMutableArray *connectedUserForBroadcast;
@property (nonatomic,strong) NSDictionary *searchDetails;
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic, readwrite) BOOL isManualMatchMaking;
@property (nonatomic, readonly) UIStoryboard *mainStoryBoard;
@property(nonatomic, readwrite) BOOL isLoginPresented;

+(SMUSharedResources*)sharedResourceManager;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (NSString*)getFbAccessToken;
- (NSString*)getFbLoggedInUserId;
- (BOOL)isFacebookLoggedIn;
- (void)logoutFbUser;

- (void)showProgressHUDForViewWithTitle:(NSString*)title withDetail:(NSString*)detail;
- (void)showProgressHUDForView;
- (void)hideProgressHUDForView;

- (void)presentLogin;

- (void)fetchUserProfile;
- (void)fetchUserFriends;
- (void)fetchInitialFOFList;
- (BOOL)iterateFOFListFetching;
- (void)endOflistingReachedInUserC;

- (void)fetchConnUser;
- (void)fetchUserProfilePictures;
//- (BOOL)iterateNextConnUser;
//- (void)fetchNextConnUserList;
- (void)fetchDateSuggestionDetails:(NSString *)placeId withSelectedUserId:(NSString *)selectedUserId withType:(NSString *)type;
- (void)fetchChatConnUser;
- (void)fetchChatList;
-(void)fetchSearchResult:(NSString *)forKey withType:(NSString *)type;
-(void)fetchInternUsers;
-(void)fetchConnectedUserForBC;
-(void)detailsForEdit;
-(void)showSelectedCheckin:(NSString *)UserID;
@end
