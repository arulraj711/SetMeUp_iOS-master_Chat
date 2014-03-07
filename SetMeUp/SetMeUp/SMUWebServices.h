//
//  SMUWebServices.h
//  SetMeUp
//
//  Created by Go on 17/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface SMUWebServices : NSObject {
    bool isAvailable;
}
#pragma mark - BaseService

+(void)getResultsForFunctionName:(NSString *)urlPath
                  withPostDetails:(NSString*)postDetails
                     withFbUserId:(NSString*)userID
                  withFbAuthToken:(NSString*)authToken
                        onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Login
+(void)loginWithAccessToken:(NSString*)fbAccessToken
                     ofType:(NSString*)accessTokenType
                forFbUserId:(NSString*)fbUserId
 withPushMessageDeviceToken:(NSString*)deviceToken
                  onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - UserC & MatchMakers

+(void)getMatchmakerDetailsWithAccessToken:(NSString *)fbAccessToken
                                 forUserId:(NSString *)userId
                           withSortingType:(int )sortType
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getUserCDetailsWithAccessToken:(NSString *)fbAccessToken
                            forUserId:userId
                 forSelectedFriendsID:(NSString *)selectedName
               andSelectedFriendsName:(NSString *)selectedID
                            withCount:(NSInteger)count
                           withPageNO:(NSInteger)pageno
                           andSearchParams:(NSDictionary*)searchParams
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//User C Fitler change

/*
+(void)getUserCDetailsWithAccessToken:(NSString *)fbAccessToken
                            forUserId:userId
                 forSelectedFriendsID:(NSString *)selectedID
               andSelectedFriendsName:(NSString *)selectedName
                            withCount:(NSInteger)count
                            andPageNO:(NSInteger)pageno
                       withSearchType:(NSInteger)searchType
                            forGender:(NSString *)gender
                           fromAge:(NSInteger)minAge
                           toAge:(NSInteger)maxAge
                         ofSearchOrder:(NSInteger)searchOrder
                         withLocation:(NSString *)location
                        withEducation:(NSString *)education
                        withWorkplace:(NSString *)workplace
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
*/

+(void)setmeUpWithAccessToken:(NSString *)fbAccessToken
                    forUserId:userId
         forSelectedFriendsID:(NSString *)selectedIDs
                         type:(NSString *)type
                      userCId:(NSString *)userCId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)ignoreWithAccessToken:(NSString *)fbAccessToken
                   forUserId:userId
                     userCId:(NSString *)userCId
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)approveWithAccessToken:(NSString *)fbAccessToken
                    forUserId:userId
                      userCId:(NSString *)userCId
       selectedMatchMakersIds:(NSString *)selectedMMIds
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)disApproveWithAccessToken:(NSString *)fbAccessToken
                       forUserId:userId
                         userCId:(NSString *)userCId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark - Reco
+(void)getRecentStatusWithAccessToken:(NSString *)fbAccessToken
                            forUserId:userId
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getRecoStatusWithAccessToken:(NSString *)fbAccessToken
                          forUserId:userId
                       withRecoType:recoType
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)getUserADetailsWithAccessToken:(NSString *)fbAccessToken
                            forUserId:(NSString *)userAId
                       selectedUserID:(NSString *)selectedId
                              success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getUserAProfilePictureWithAccessToken:(NSString *)fbAccessToken
                                   forUserId:(NSString *)userId
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)faceBookSyncProcessWithAccessToken:(NSString *)fbAccessToken
                                forUserId:(NSString *)userId
                                  success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                  failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)saveProfileInfoWithAccessToken:(NSString *)fbAccessToken
                            forUserId:(NSString *)userId
                    withProfileString:(NSString *)profileString
                              success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                              failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;
+(void)sendFeedbackWithAccessToken:(NSString *)fbAccessToken
                         forUserId:(NSString *)userId
               withFeedbackSubject:(NSString *)subject
                   feedbackMessage:(NSString *)message
                           success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                           failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)getCongratulationStatusWithAccessToken:(NSString *)fbAccessToken
                                    forUserId:userId
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getShowDateRequsetWithAccessToken:(NSString *)fbAccessToken
                               forUserId:userId
                   withConnectionMatchId:(NSInteger)matchId
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)changeLetsMeetStatusWithAccessToken:(NSString *)fbAccessToken
                                 forUserId:(NSString *)userId
                                      type:(NSString *)type
                                withDateId:(NSString *)dateId
                                   success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                   failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)changeCongratsStatus:(NSString *)fbAccessToken
                                 forUserId:(NSString *)userId
                                      type:(NSString *)type
                                userAId:(NSString *)userAId
                                userCId:(NSString *)userCId
                            connectionId:(NSString *)connectionId
                                   success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                   failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)getPlaceMakerIndexWithAccessToken:(NSString *)fbAccessToken
                               forUserId:(NSString *)userId
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)getSelectedCheckinsWithAccessToken:(NSString *)fbAccessToken
                               forUserId:(NSString *)userId
                         withSelectedUser:(NSString *)selectedUserID
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(void)dateSuggestionWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                         withPlaceId:(NSString *)placeId
                  withSelectedUserId:(NSString *)userId
                            withType:(NSString *)type
                             success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                             failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)getMessageDetailsWithAccessToken:(NSString *)fbAccessToken
                              forUserId:(NSString *)userId
                        withMessageType:(NSString *)msgType
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)confirmDateWithAccessToken:(NSString *)fbAccessToken
                        forUserId:(NSString *)userId
               withSelectedUserId:(NSString *)selectedUserId
                      withPlaceId:(NSString *)placeId
                         withDate:(NSString *)dateandTime
                         withType:(NSString *)type
                          comment:(NSString *)comment
                          success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;
+(void)homeMessageDetailsWithAccessToken:(NSString *)fbAccessToken
                               forUserId:(NSString *)userId
                         withMessageType:(NSString *)msgType
                              fromUserId:(NSString *)fromUserId
                                  pageNo:(int)pageNo
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)sendReplyWithAccessToken:(NSString *)fbAccessToken
                      forUserId:(NSString *)userId
                withMessageType:(NSString *)msgType
                  messageString:(NSString *)messageString
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)sendNewMessageWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                     withMessageType:(NSString *)msgType
                       messageString:(NSString *)messageString
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)changeMessageStatusWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                     withMessageType:(NSString *)msgType
                            user_id1:(NSString *)userid1
                            user_id2:(NSString *)userid2
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)locationServiceWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                     withMiles:(float)miles
                       withLattitude:(float)lattitude
                        withLongitude:(float)longitude
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)updateLocationWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                   withLocationArray:(NSString *)locationArray
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getSearchResultsWithAccessToken:(NSString *)fbAccessToken
                             forUserId:(NSString *)userId
                        withSearchType:(NSString *)searchType
                                forKey:(NSString *)keyword
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)getInternUsersWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                             success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                             failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)getConnectUsersWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                             success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                             failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)saveInternsWithAccessToken:(NSString *)fbAccessToken
                        forUserId:(NSString *)userId
                     withInternId:(NSString *)internId
                          success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)changeStatusOfNotificationWithAccessToken:(NSString *)fbAccessToken
                                       forUserId:(NSString *)userId
                                          ofType:(NSString *)type
                                      withStatus:(int)status
                                         success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                         failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;


+(void)inviteNonSmuUserWithAccessToken:(NSString *)fbAccessToken
                             forUserId:(NSString *)userId
                             toUserIds:(NSString *)userIds
                               success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                               failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;


+(void)ignoreRecoWithAccessToken:(NSString *)fbAccessToken
                             forUserId:(NSString *)userId
                        withRecoType:(NSString *)recoType
                                forConnIds:(NSString *)connIds
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)sendCRecoWithAccessToken:(NSString *)fbAccessToken
                       forUserId:(NSString *)userId
                    withRecoDetails:(NSString *)recoDetails
                      forConnId:(NSString *)connId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)acceptRecoWithAccessToken:(NSString *)fbAccessToken
                      forUserId:(NSString *)userId
                      forConnId:(NSString *)connId
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)ignoreBCRecoWithAccessToken:(NSString *)fbAccessToken
                       forUserId:(NSString *)userId
                    withRecoType:(NSString *)recoType
                      forConnIds:(NSString *)connIds
                            status:(NSString *)status
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)closeRecoWithAccessToken:(NSString *)fbAccessToken
                       forUserId:(NSString *)userId
                       forConnId:(NSString *)connId
                          type :(NSString *) type
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getRecentGroupingStatusWithAccessToken:(NSString *)fbAccessToken
                                    forUserId:userId
                                         type:type
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)getClosedRecoStatusWithAccessToken:(NSString *)fbAccessToken
                                    forUserId:userId
                                         type:type
                           selectedUserId:userid
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)getBroadcastsWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                             success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                             failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)sendBroadCastLocationWithAccessToken:(NSString *)fbAccessToken
                          forUserId:(NSString *)userId
                       withBroadCastDetails:(NSString *)broadcastDetails
                           withSelectedUser:(NSString *)selectedUser
                            success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                            failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

+(void)changeBroadcastStatusWithAccessToken:(NSString *)fbAccessToken
                                  forUserId:(NSString *)userId
                       withType:(NSString *)type
                           withStatus:(NSString *)status
                                  forUserId:(NSString *)userid
                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                    failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;
+(void)updateMobileCheckinWithAccessToken:(NSString *)fbAccessToken
                                  forUserId:(NSString *)userId
                       withCheckinDetails:(NSString *)checkinDetails
                        withSelectedUsers:(NSString *)selectedUsers
                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                    failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure;

@end
