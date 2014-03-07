//
//  SMUWebServices.m
//  SetMeUp
//
//  Created by Go on 17/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUWebServices.h"
#import "SMUUserProfile.h"
#import "SMUFriend.h"
#import "SMUFriendOfFriend.h"
#import "SMUAlertViewController.h"
#import "SMURecentStatus.h"
#import "SMURecoAB.h"
#import "SMUBCReco.h"
#import "SMUUserAPicture.h"
#import "SMUGetMessage.h"
#import "SMUSearchFilter.h"
#import "SMURecoGrouping.h"
#import "SMUInterns.h"
#import "SMUBroadCastUser.h"
#import "Reachability.h"
// ---LOCALSERVER---
//#define CAPESTART_SERVICE_URL @"http://connectme.capestart.com/SMURC/restapis"
// LOCAL FB APP ID 481980368553936

// ---PUNE AMAZON SERVER---
#define CAPESTART_SERVICE_URL @"http://stage.setmeupapp.com/restapis"
// LIVE FB APP ID 202331203278983


// ---LIVE  SERVER---
//#define CAPESTART_SERVICE_URL @"http://www.setmeupapp.com/restapis"
// LIVE FB APP ID 573610095985092


#define SERVICE_TIMEOUT_INTERVAL 60
#define USE_MOCK_LAYER  1
@implementation SMUWebServices

#pragma mark - BaseService

+ (void)getResultsForFunctionName:(NSString *)urlPath withPostDetails:(NSString*)postDetails withFbUserId:(NSString*)userID withFbAuthToken:(NSString*)authToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    NSString *postURL = [NSString stringWithFormat:@"%@/%@/",CAPESTART_SERVICE_URL,urlPath];
    NSData *postData = [postDetails dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setTimeoutInterval:SERVICE_TIMEOUT_INTERVAL];
    [req setHTTPMethod:@"POST"];
    [req setValue:userID forHTTPHeaderField:@"id"];
    [req setValue:authToken forHTTPHeaderField:@"extendedAccessToken"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
//    Reachability *reach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus status = [reach currentReachabilityStatus];
//    
//    NSLog(@"internet status:%d",status);
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"\n=========REQUEST=========\n%@\n%@\n===========================",operation.request.URL.absoluteString,postDetails);
         //NSLog(@"response object:%@",responseObject);
         id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         NSLog(@"\n=========RESPONSE=========\n%@\n===========================",JSON);
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"\n=========REQUEST=========\n%@",operation.request);
         NSLog(@"\n=========RESPONSE(ERROR)=========\n%@\n==================",error);
         if(error.code != -999)
             failure(operation, error);
         
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

#pragma mark - Login
+(void)loginWithAccessToken:(NSString*)fbAccessToken ofType:(NSString*)accessTokenType forFbUserId:(NSString*)fbUserId withPushMessageDeviceToken:(NSString*)deviceToken onSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success onFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([deviceToken length]==0) {
        deviceToken=@"123";
    }
    NSMutableString *postString=[[NSMutableString alloc] init];
    [postString appendFormat:@"access_token=%@&tokenType=%@&deviceToken=%@",fbAccessToken,accessTokenType,deviceToken];
    [self getResultsForFunctionName:@"initializerest/0" withPostDetails:postString withFbUserId:fbUserId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        SMUAlertViewController *alert=[SMUAlertViewController sharedInstance];
        [alert setUpAlertWithTitle:@"ERR" withSubTile:@"Match maker failed" withOperation:operation];
        //[alert presentModelInRootViewController];
    }];
}
#pragma mark - UserC & MatchMakers

+(void)getMatchmakerDetailsWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId withSortingType:(int)sortType success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&mmSortTypeOrder=%d",fbAccessToken,sortType];
    [self getResultsForFunctionName:@"myMatchmakers" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = (NSArray *)[responseObject objectForKey:@"matchmakers"];
        NSMutableArray *friends = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            SMUFriend *friend = [[SMUFriend alloc] init];
            [friend setFriendDetailsWithDict:dic];
            [friends addObject:friend];
        }
        success(operation , friends);
//        SMUMatchmakers *matchMakers=[[SMUMatchmakers alloc]init];
//        [matchMakers setMatchmakersFromDict:responseObject];
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        SMUAlertViewController *alert=[SMUAlertViewController sharedInstance];
        [alert setUpAlertWithTitle:@"ERR" withSubTile:@"Match maker failed" withOperation:operation];
        //[alert presentModelInRootViewController];
    }];
}

+(void)getUserCDetailsWithAccessToken:(NSString *)fbAccessToken forUserId:(id)userId forSelectedFriendsID:(NSString *)selectedID andSelectedFriendsName:(NSString *)selectedName withCount:(NSInteger)count withPageNO:(NSInteger)pageno andSearchParams:(NSDictionary*)searchParams success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    if (searchParams) {
        
      
[postString appendFormat:@"access_token=%@&selected_b_friends_id=%@&c_count=%ld&pageno=%ld&serachType=%d&cgender=%@&cminAge=%d&cmaxAge=%d&csearch_order=%d&location=%@&education=%@&workplace=%@",fbAccessToken,selectedID,(long)count,(long)pageno,1,[searchParams objectForKey:@"gender"],[[searchParams objectForKey:@"minage"]integerValue],[[searchParams objectForKey:@"maxage"] integerValue],1,[searchParams objectForKey:@"location"],[searchParams objectForKey:@"education"],[searchParams objectForKey:@"workplace"]];
    }else{
        [postString appendFormat:@"access_token=%@&selected_b_friends_id=%@&c_count=%ld&pageno=%ld",fbAccessToken,selectedID,(long)count,(long)pageno];
    }
    [self getResultsForFunctionName:@"get_c_friend_new" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

//serachType=1&cgender=Male&cminAge=27&cmaxAge=45&csearch_order=1&location=&education=&workplace
/*
+(void)getUserCDetailsWithAccessToken:(NSString *)fbAccessToken forUserId:(id)userId forSelectedFriendsID:(NSString *)selectedID andSelectedFriendsName:(NSString *)selectedName withCount:(NSInteger)count andPageNO:(NSInteger)pageno withSearchType:(NSInteger)searchType forGender:(NSString *)gender fromAge:(NSInteger)minAge toAge:(NSInteger)maxAge ofSearchOrder:(NSInteger)searchOrder withLocation:(NSString *)location withEducation:(NSString *)education withWorkplace:(NSString *)workplace success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&slected_b_friends_id=%@&slected_b_friends_name=%@&c_count=%ld&pageno=%ld&serachType=%ld&cgender=%@&cminAge=%ld&cmaxAge=%ld&csearch_order=%ld&location=%@&education=%@&workplace=%@",fbAccessToken,selectedID,selectedName,(long)count,(long)pageno,(long)searchType,gender,(long)minAge,(long)maxAge,(long)searchOrder,location,education,workplace];
    
    [self getResultsForFunctionName:@"get_c_friend_new" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];

    
}
 */
+(void)setmeUpWithAccessToken:(NSString *)fbAccessToken
                    forUserId:userId
         forSelectedFriendsID:(NSString *)selectedIDs
                         type:(NSString *)type
                    userCId  :(NSString *)userCId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&user_c_id=%@&slected_b_friends_id=%@&type=%@",fbAccessToken,userCId,selectedIDs,type];
    
    [self getResultsForFunctionName:@"setmeupRequest" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+(void)ignoreWithAccessToken:(NSString *)fbAccessToken
                   forUserId:userId
                     userCId:(NSString *)userCId
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&user_c_id=%@",fbAccessToken,userCId];
    
    [self getResultsForFunctionName:@"removeUserC" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}
+(void)approveWithAccessToken:(NSString *)fbAccessToken
                    forUserId:userId
                      userCId:(NSString *)userCId
                      selectedMatchMakersIds:(NSString *)selectedMMIds
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&user_c_id=%@&sel_mm=%@",fbAccessToken,userCId,selectedMMIds];
    
    [self getResultsForFunctionName:@"approveUserC" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+(void)disApproveWithAccessToken:(NSString *)fbAccessToken
                       forUserId:userId
                         userCId:(NSString *)userCId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&user_c_id=%@",fbAccessToken,userCId];
    
    [self getResultsForFunctionName:@"disapproveUserC" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}
#pragma mark - Reco
+(void)getRecentStatusWithAccessToken:(NSString *)fbAccessToken
                            forUserId:userId
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    if(USE_MOCK_LAYER)
//    {
//        NSDictionary *JSON = [self dictionaryWithFileName:@"get_recent_status"];
//        success(nil,[self parseRecentStatusDic:JSON]);
//        return;
//    }
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    
    [self getResultsForFunctionName:@"get_recent_status" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"response:%@",responseObject);
        success(operation, [self parseRecentStatusDic:responseObject]);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error :%@",error);
        failure(operation, error);
    }];
}
+(void)getRecoStatusWithAccessToken:(NSString *)fbAccessToken
                          forUserId:userId
                       withRecoType:recoType
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
//    if(USE_MOCK_LAYER)
//    {
//        if([recoType isEqualToString:@"abreco"])
//        {
//            NSDictionary *JSON = [self dictionaryWithFileName:@"ABReco"];
//            success(nil,[self parseRecoABDic:JSON]);
//        }
//        else
//        {
//            NSDictionary *JSON = [self dictionaryWithFileName:@"BCReco"];
//            success(nil,[self parseRecoBCDic:JSON]);
////            success(nil,[SMUBCReco mock]);
//        }
//        return;
//    }
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@",fbAccessToken,recoType];
    
    [self getResultsForFunctionName:@"viewReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"response:%@",responseObject);
        if([recoType isEqualToString:@"abreco"])
        {
            success(operation,[self parseRecoABDic:responseObject]);
        }
        else
        {
            success(operation,[self parseRecoBCDic:responseObject]);
        }
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error :%@",error);
        failure(operation, error);
    }];
}

+(void)getUserADetailsWithAccessToken:(NSString *)fbAccessToken
                            forUserId:(NSString *)userAId
                       selectedUserID:(NSString *)selectedId
                              success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //    if(USE_MOCK_LAYER)
    //    {
    //        NSDictionary *JSON = [self dictionaryWithFileName:@"RecocUserB"];
    //        success(nil,[self parseRecoCUserB:JSON]);
    //        return;
    //    }
    
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&userA_Id=%@",fbAccessToken,selectedId];
    
    [self getResultsForFunctionName:@"userA_details" withPostDetails:postString withFbUserId:userAId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"response:%@",responseObject);
        success(operation, [self parseRecoCUserB:responseObject]);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error :%@",error);
        failure(operation, error);
    }];
}

+(void)getUserAProfilePictureWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSMutableString * postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&selected_ausr_id=%@",fbAccessToken,userId];
    
    [self getResultsForFunctionName:@"user_A_album" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"result for profilePictures:%@",responseObject);
        NSArray *array = (NSArray *)[responseObject objectForKey:@"user_a_album"];
        NSMutableArray *profilePictures = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            SMUUserAPicture *picture = [[SMUUserAPicture alloc] init];
            [picture setProfilePictureWithDict:dic];
            [profilePictures addObject:picture];
        }
        success(operation,profilePictures);
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

+(void)getRecentGroupingStatusWithAccessToken:(NSString *)fbAccessToken
                                    forUserId:userId
                                         type:type
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@",fbAccessToken,type];
    //
    [self getResultsForFunctionName:@"viewReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dic = [responseObject objectForKey:@"RecoDetails"];
         SMURecoGrouping *recoGrouping = [[SMURecoGrouping alloc]init];
         [recoGrouping setDictionary:dic];
         success(operation, recoGrouping);
     } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"Error :%@",error);
         failure(operation, error);
     }];
}

+(void)getClosedRecoStatusWithAccessToken:(NSString *)fbAccessToken
                                forUserId:userId
                                     type:type
                           selectedUserId:userid
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&user_id=%@",fbAccessToken,type,userid];
    //
    [self getResultsForFunctionName:@"closed_reco_details" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //         NSLog(@"response:%@",responseObject);
         //success(operation, responseObject);
         
         if([type isEqualToString:@"AB"])
         {
             success(operation,[self parseRecoABDic:responseObject]);
         }
         else
         {
             success(operation,[self parseRecoBCDic:responseObject]);
         }
         
     } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         NSLog(@"Error :%@",error);
         failure(operation, error);
     }];
}

//+(void)getRecentGroupingStatusWithAccessToken:(NSString *)fbAccessToken
//                            forUserId:userId
//                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
////    if(USE_MOCK_LAYER)
////    {
////        NSDictionary *JSON = [self dictionaryWithFileName:@"reco_grouping_status"];
////        success(nil,[self parseRecentGroupingStatusDic:JSON]);
////        return;
////    }
//    
//    NSMutableString *postString=[[NSMutableString alloc]init];
//    [postString appendFormat:@"access_token=%@",fbAccessToken];
////    
//    [self getResultsForFunctionName:@"recoScreen" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
////         NSLog(@"response:%@",responseObject);
//         success(operation, responseObject);
//     } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
////         NSLog(@"Error :%@",error);
//         failure(operation, error);
//     }];
//}

#pragma mark - Others

+(void)faceBookSyncProcessWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    [self getResultsForFunctionName:@"fbSync" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"response object:%@",responseObject);
        
        SMUUserProfile *userProfile = [[SMUUserProfile alloc] init];
        [userProfile setUserProfileWithDict:responseObject];
        success(operation,userProfile);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+(void)saveProfileInfoWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId withProfileString:(NSString *)profileString success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&profile_string=%@",fbAccessToken,profileString];
    
    [self getResultsForFunctionName:@"saveProfile" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SMUUserProfile *userProfile = [[SMUUserProfile alloc] init];
        [userProfile setUserProfileWithDict:responseObject];
        
        success(operation,userProfile);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)sendFeedbackWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId withFeedbackSubject:(NSString *)subject feedbackMessage:(NSString *)message success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&fbMessage=%@&fbSubject=%@",fbAccessToken,message,subject];
    
    [self getResultsForFunctionName:@"sendFeedback" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)getCongratulationStatusWithAccessToken:(NSString *)fbAccessToken forUserId:(id)userId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    
    [self getResultsForFunctionName:@"showAcceptedDate" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"Congratulation response:%@",responseObject);
         success(operation,responseObject);
     } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error :%@",error);
         failure(operation, error);
     }];
    
    
}

+(void)getShowDateRequsetWithAccessToken:(NSString *)fbAccessToken
                               forUserId:userId
                   withConnectionMatchId:(NSInteger)matchId
                                 success:(void (^)(AFHTTPRequestOperation *, id))success
                                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
 {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&date_sug_id=%d",fbAccessToken,matchId];
    [self getResultsForFunctionName:@"showDateRequest" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)changeLetsMeetStatusWithAccessToken:(NSString *)fbAccessToken
                                 forUserId:(NSString *)userId
                                      type:(NSString *)type
                                withDateId:(NSString *)dateId
                                   success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                   failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&dateId=%@",fbAccessToken,type,dateId];
    [self getResultsForFunctionName:@"changeStatus" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
        //NSLog(@"change Status Response:%@",responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)changeCongratsStatus:(NSString *)fbAccessToken forUserId:(NSString *)userId type:(NSString *)type userAId:(NSString *)userAId userCId:(NSString *)userCId  connectionId:(NSString *)connectionId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&a_user_id=%@&c_user_id=%@&connectionID=%@",fbAccessToken,type,userAId,userCId,connectionId];
    
   [self getResultsForFunctionName:@"changeStatus" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
        //NSLog(@"change Status Response:%@",responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
    
}

+(void)getPlaceMakerIndexWithAccessToken:(NSString *)fbAccessToken
                               forUserId:(NSString *)userId
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    [self getResultsForFunctionName:@"firstconnect" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)getSelectedCheckinsWithAccessToken:(NSString *)fbAccessToken
                                forUserId:(NSString *)userId
                         withSelectedUser:(NSString *)selectedUserID
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&user_id=%@",fbAccessToken,selectedUserID];
    [self getResultsForFunctionName:@"mycheckins" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)dateSuggestionWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                         withPlaceId:(NSString *)placeId
                  withSelectedUserId:(NSString *)selectedUserId
                            withType:(NSString *)type
                             success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                             failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&place_id=%@&c_user_id=%@&type=%@",fbAccessToken,placeId,selectedUserId,type];
    [self getResultsForFunctionName:@"dateSuggestion" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

#pragma mark - getMessage

+(void)getMessageDetailsWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId withMessageType:(NSString *)msgType success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@",fbAccessToken,msgType];
    [self getResultsForFunctionName:@"getMessages" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"getmessage:%@",responseObject);
        //        SMUHomeMessage *homeMessage = [[SMUHomeMessage alloc]init];
        //        [homeMessage setHomeMessageWithDict:responseObject];
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)confirmDateWithAccessToken:(NSString *)fbAccessToken
                        forUserId:(NSString *)userId
               withSelectedUserId:(NSString *)selectedUserId
                      withPlaceId:(NSString *)placeId
                         withDate:(NSString *)dateandTime
                            withType:(NSString *)type
                          comment:(NSString *)comment
                          success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&user_id=%@&dateAndTime=%@&place_id=%@&comment=%@&checkin_type=%@",fbAccessToken,selectedUserId,dateandTime,placeId,comment,type];
    [self getResultsForFunctionName:@"confirmDate" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

#pragma mark - homeMessage
+(void)homeMessageDetailsWithAccessToken:(NSString *)fbAccessToken
                               forUserId:(NSString *)userId
                         withMessageType:(NSString *)msgType
                              fromUserId:(NSString *)fromUserId
                                  pageNo:(int)pageNo
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&from_user_id=%@&pageno=%d",fbAccessToken,msgType,fromUserId,pageNo];
    [self getResultsForFunctionName:@"getMessages" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"getMessages Result:%@",responseObject);
        
//        SMUGetMessage *msgModels = [[SMUGetMessage alloc]init];
//        [msgModels setTotalMessageWithDict:responseObject];
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)sendReplyWithAccessToken:(NSString *)fbAccessToken
                      forUserId:(NSString *)userId
                withMessageType:(NSString *)msgType
                  messageString:(NSString *)messageString
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&messageArray=%@",fbAccessToken,msgType,messageString];
    [self getResultsForFunctionName:@"getMessages" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"send reply result:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}

+(void)sendNewMessageWithAccessToken:(NSString *)fbAccessToken
                           forUserId:(NSString *)userId
                     withMessageType:(NSString *)msgType
                       messageString:(NSString *)messageString
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&messageArray=%@",fbAccessToken,msgType,messageString];
    [self getResultsForFunctionName:@"getMessages" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"send reply result:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
    
}

+(void)changeMessageStatusWithAccessToken:(NSString *)fbAccessToken
                                forUserId:(NSString *)userId
                          withMessageType:(NSString *)msgType
                                 user_id1:(NSString *)userid1
                                 user_id2:(NSString *)userid2
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&user_id1=%@&user_id2=%@",fbAccessToken,msgType,userid1,userid2];
    [self getResultsForFunctionName:@"getMessages" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"send reply result:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}



+(void)locationServiceWithAccessToken:(NSString *)fbAccessToken
                            forUserId:(NSString *)userId
                            withMiles:(float)miles
                        withLattitude:(float)lattitude
                        withLongitude:(float)longitude
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&miles=%f&lat1=%f&lon1=%f",fbAccessToken,miles,lattitude,longitude];
    [self getResultsForFunctionName:@"fclocationService" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"location service response:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}


+(void)updateLocationWithAccessToken:(NSString *)fbAccessToken
                            forUserId:(NSString *)userId
                        withLocationArray:(NSString *)locationArray
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&locationArray=%@",fbAccessToken,locationArray];
    [self getResultsForFunctionName:@"updateLocation" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"location updated:%@",responseObject);
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error :%@",error);
        failure(operation, error);
    }];
}
+(void)getSearchResultsWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId withSearchType:(NSString *)searchType forKey:(NSString *)keyword success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&key=%@",fbAccessToken,searchType,keyword];
    
    [self getResultsForFunctionName:@"searchTools" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        
        success(operation,responseObject);
    
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+(void)getInternUsersWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    [self getResultsForFunctionName:@"getinternUsers" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"response object:%@",responseObject);
    
        
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)getConnectUsersWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    [self getResultsForFunctionName:@"myConnections" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"response object:%@",responseObject);
        
        
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+(void)saveInternsWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId withInternId:(NSString *)internId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&internId=%@",fbAccessToken,internId];
    
    [self getResultsForFunctionName:@"addInternUser" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)changeStatusOfNotificationWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId ofType:(NSString *)type withStatus:(int)status success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&status=%d&type=%@",fbAccessToken,status,type];
    [self getResultsForFunctionName:@"updateStatus" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)inviteNonSmuUserWithAccessToken:(NSString *)fbAccessToken forUserId:(NSString *)userId toUserIds:(NSString *)userIds success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&userArray=%@",fbAccessToken,userIds];
    [self getResultsForFunctionName:@"inviteNonSmuUser" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)ignoreRecoWithAccessToken:(NSString *)fbAccessToken
                       forUserId:(NSString *)userId
                    withRecoType:(NSString *)recoType
                      forConnIds:(NSString *)connIds
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&ConnectionId=%@",fbAccessToken,recoType,connIds];
    [self getResultsForFunctionName:@"rejectReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



+(void)sendCRecoWithAccessToken:(NSString *)fbAccessToken
                      forUserId:(NSString *)userId
                withRecoDetails:(NSString *)recoDetails
                      forConnId:(NSString *)connId
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&connectionId=%@&recoDetails=%@",fbAccessToken,connId,recoDetails];
    [self getResultsForFunctionName:@"sendCReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)acceptRecoWithAccessToken:(NSString *)fbAccessToken
                       forUserId:(NSString *)userId
                       forConnId:(NSString *)connId
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&connectionId=%@",fbAccessToken,connId];
    [self getResultsForFunctionName:@"acceptReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)ignoreBCRecoWithAccessToken:(NSString *)fbAccessToken
                         forUserId:(NSString *)userId
                      withRecoType:(NSString *)recoType
                        forConnIds:(NSString *)connIds
                            status:(NSString *)status
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&ConnectionId=%@&status=%@",fbAccessToken,recoType,connIds,status];
    [self getResultsForFunctionName:@"rejectReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)closeRecoWithAccessToken:(NSString *)fbAccessToken
                      forUserId:(NSString *)userId
                      forConnId:(NSString *)connId
                          type :(NSString *) type
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&connection_ids=%@&type=%@",fbAccessToken,connId,type];
    [self getResultsForFunctionName:@"closeReco" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([type isEqualToString:@"AB"])
        {
            success(operation,[self parseRecoABDic:responseObject]);
        }
        else
        {
            success(operation,[self parseRecoBCDic:responseObject]);
        }
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)getBroadcastsWithAccessToken:(NSString *)fbAccessToken
                          forUserId:(NSString *)userId
                            success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                            failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@",fbAccessToken];
    [self getResultsForFunctionName:@"getBroadcasts" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,[self parseBroadCastDic:responseObject]);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)sendBroadCastLocationWithAccessToken:(NSString *)fbAccessToken
                                  forUserId:(NSString *)userId
                       withBroadCastDetails:(NSString *)broadcastDetails
                           withSelectedUser:(NSString *)selectedUser
                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                    failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&brodcastDetailsArray=%@&c_usersArray=%@",fbAccessToken,broadcastDetails,selectedUser];
    [self getResultsForFunctionName:@"brodcastLocation" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)changeBroadcastStatusWithAccessToken:(NSString *)fbAccessToken
                                  forUserId:(NSString *)userId
                                   withType:(NSString *)type
                                 withStatus:(NSString *)status
                                  forUserId:(NSString *)broadId
                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                    failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&type=%@&status=%@&broadcast_id=%@",fbAccessToken,type,status,broadId];
    [self getResultsForFunctionName:@"updateStatus" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)updateMobileCheckinWithAccessToken:(NSString *)fbAccessToken
                                forUserId:(NSString *)userId
                       withCheckinDetails:(NSString *)checkinDetails
                        withSelectedUsers:(NSString *)selectedUsers
                                  success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                  failure:(void(^)(AFHTTPRequestOperation *operation,NSError *error))failure {
    NSMutableString *postString=[[NSMutableString alloc]init];
    [postString appendFormat:@"access_token=%@&checkin_data=%@&users=%@",fbAccessToken,checkinDetails,selectedUsers];
    [self getResultsForFunctionName:@"mobileCheckin" withPostDetails:postString withFbUserId:userId withFbAuthToken:fbAccessToken onSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Parse
+ (NSMutableArray *)parseRecoBCDic:(NSDictionary *)dictionary
{
//    NSDictionary *JSON = [self dictionaryWithFileName:@"BCReco"];
    NSArray *recos = [dictionary objectForKey:@"reco_details"];
    NSMutableArray *recoBCs = [NSMutableArray array];
    for (NSDictionary *reco in recos) {
        SMUBCReco *bcReco = [[SMUBCReco alloc]init];
        [bcReco setBCRecoDetailsWithDict:reco];
        [recoBCs addObject:bcReco];
    }
    //NSLog(@"bcReco :%@", recoBCs);
    return recoBCs;
}
+ (SMUFriendOfFriend *)parseRecoCUserB:(NSDictionary *)dictionary
{
    SMUFriendOfFriend *friendOfFriend = [[SMUFriendOfFriend alloc] init];
    [friendOfFriend setUserCDetailsFromDictionary:[dictionary objectForKey:@"result"]];
   // NSLog(@"parseRecoCUserB :%@", friendOfFriend);
    return friendOfFriend;
}

+ (NSMutableArray *)parseRecoABDic:(NSDictionary *)dictionary
{
    //NSLog(@"parseRecoABDic");
    NSArray *recos = [dictionary objectForKey:@"RecoDetails"];
    NSMutableArray *recoABs = [NSMutableArray array];
    for (NSDictionary *reco in recos) {
        //NSLog(@"dictionary:%@",reco);
        SMURecoAB *singleReco = [[SMURecoAB alloc]init];
        [singleReco setSingleRecoDetailsWithDict:reco];
        [recoABs addObject:singleReco];
    }
   // NSLog(@"recoABs :%@", recoABs);
    return recoABs;
}
+(NSMutableArray *)parseBroadCastDic:(NSDictionary *)dictionary {
    
      //NSLog(@"parseBroadCast");
    NSArray *broadcast = [dictionary objectForKey:@"my_broadcasts"];
    
    
    NSMutableArray *broadCastArray = [NSMutableArray array];

    for(NSDictionary *broadcastDic in broadcast) {
        SMUBroadCastUser *broadcastUser = [[SMUBroadCastUser alloc]init];
        [broadcastUser setBroadCastDetails:broadcastDic];
        [broadCastArray addObject:broadcastUser];
        
    }
        return broadCastArray;
    
    
}
+ (SMURecentStatus *)parseRecentStatusDic:(NSDictionary *)dictionary
{
    SMURecentStatus *recentStatus = [[SMURecentStatus alloc]init];
    [recentStatus setRectStatusFromDict:[dictionary objectForKey:@"recent_status"]];
    //NSLog(@"recentstatus :%@", recentStatus);
    return recentStatus;
}
+ (SMURecoGrouping * )parseRecentGroupingStatusDic:(NSDictionary *)dictionary
{
    SMURecoGrouping *recentStatus = [[SMURecoGrouping alloc]init];
    [recentStatus setDictionary:dictionary];
    //NSLog(@"recentstatus :%@", recentStatus);
    return recentStatus;
}
+ (NSDictionary *)dictionaryWithContentOfFile:(NSString *)path
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
+ (NSDictionary *)dictionaryWithFileName:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
    NSDictionary *dic = [self dictionaryWithContentOfFile:path];
    return dic ;
}

@end