//
//  SMUSharedReco.h
//  SetMeUp
//
//  Created by In on 25/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SMURecentStatus;
@class SMURecoAB;
@class SMUBCReco;


@interface SMUSharedReco : NSObject<CLLocationManagerDelegate,MKMapViewDelegate>

+ (SMUSharedReco *)sharedReco;
- (SMURecentStatus *)getRecentStatus;
- (NSMutableArray *)getRecoAB;
- (SMUBCReco *)getRecoBC;
- (void)setDetailsIntoCongratsModel;

-(void)showInvitePopupWithAccessToken:(NSString *)fbAccessToken withUserId:(NSString *)fbUserId withRecoDetails:(NSString *)recoDetails withConnID:(NSString *)connId;

-(void)showNoUserCPopup;
-(void)checkRecoStatus;
@property(nonatomic,strong)NSMutableArray *aUserForCongrats;
@property(nonatomic,strong)NSMutableArray *letsMeetArray;
@property(nonatomic,strong)NSMutableArray *cUserForCongrats;
@property (nonatomic,strong) NSMutableArray *broadcastArray;

@end
