//
//  ViewController.m
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "ViewController.h"
#import "ServiceEngine.h"
#import "MMPage.h"
#import "RecoDetails.h"
#import "UserDetails.h"
#import "UserCPage.h"
@interface ViewController ()

@end

@implementation ViewController

RecoDetails *recoObj;
UserDetails *userObj;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginResponse:(id)sender {
    NSString *postString=[NSString stringWithFormat:@"access_token=CAAG2W8yoB9ABAD45Y7HSjBZCaAeWiJy4jIrN1rFqwnE8u7A0LZAEfg6WPBD1m98I5WOEybDfqssclsLM4WTKNyeumKUI9uwNEYCsvhvFQa5uuZB9PZBTLfOZC6g9nTFkK4korLCfj4TWHAM2CWo2FYFdJJcTsuXeZAE2ZBZCOMV8Y8xZB0vpOWVrQXavo5FJqS3IZD"];
    
    [ServiceEngine getResultsForFunctionName:@"initializerest/0" postStringValue:postString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.initializeResult = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"rest_response"]];
        userObj=[UserDetails userdetailsFromDictionary:self.initializeResult];
        NSDictionary *recoDic = [self.initializeResult objectForKey:@"reco"];
        recoObj = [RecoDetails recoDetailsFromDictionary:recoDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)  {
        
    }];
}

-(IBAction)matchMakerResponse:(id)sender {
     NSString *postString = @"access_token=CAAG2W8yoB9ABAD45Y7HSjBZCaAeWiJy4jIrN1rFqwnE8u7A0LZAEfg6WPBD1m98I5WOEybDfqssclsLM4WTKNyeumKUI9uwNEYCsvhvFQa5uuZB9PZBTLfOZC6g9nTFkK4korLCfj4TWHAM2CWo2FYFdJJcTsuXeZAE2ZBZCOMV8Y8xZB0vpOWVrQXavo5FJqS3IZD&mmSortTypeOrder=3";
    
    [ServiceEngine getResultsForFunctionName:@"myMatchMakers" postStringValue:postString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.matchMakers = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"rest_response"]];
        NSArray *result = [self.matchMakers objectForKey:@"matchmakers"];
        self.responseArray = [NSMutableArray array];
        for (NSDictionary *resultedDic in result) {
            MMPage *mmObject = [MMPage matchmakerDetailsFromDictionary:resultedDic];
            [self.responseArray addObject:mmObject];
        }
        
        NSDictionary *recoDic = [self.matchMakers objectForKey:@"reco"];
        recoObj = [RecoDetails recoDetailsFromDictionary:recoDic];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

-(IBAction)userCResponse:(id)sender {
   NSString *postString = @"access_token=CAAG2W8yoB9ABAD45Y7HSjBZCaAeWiJy4jIrN1rFqwnE8u7A0LZAEfg6WPBD1m98I5WOEybDfqssclsLM4WTKNyeumKUI9uwNEYCsvhvFQa5uuZB9PZBTLfOZC6g9nTFkK4korLCfj4TWHAM2CWo2FYFdJJcTsuXeZAE2ZBZCOMV8Y8xZB0vpOWVrQXavo5FJqS3IZD&slected_b_friends_id=9104857,100002112147565,100000417188018,100005062664439&slected_b_friends_name=Jay Wadhwani (SMU TEAM),John Chornelius,Bose,Rajesh Fithelis&c_count=4&pageno=0";
    
    [ServiceEngine getResultsForFunctionName:@"get_c_friend_new" postStringValue:postString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userC = [NSDictionary dictionaryWithDictionary:[responseObject valueForKeyPath:@"rest_response"]];
        
        NSArray *result = [self.userC objectForKey:@"user_c_details"];
        self.responseArray = [NSMutableArray array];
        for (NSDictionary *resultedDic in result) {
            UserCPage *userCObj = [UserCPage userCDetailsFromDictionary:resultedDic];
            [self.responseArray addObject:userCObj];
        }
        NSDictionary *recoDic = [self.matchMakers objectForKey:@"reco"];
        recoObj = [RecoDetails recoDetailsFromDictionary:recoDic];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    
}

-(IBAction)result:(id)sender {
    //testing
    
    //MMPage *mmObj = self.responseArray[0];
    UserCPage *usercObj = self.responseArray[0];
}
@end
