//
//  SMURecoIntroduceCollectionHandler.h
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserA;
@protocol SMURecoABUserACollectionHandlerDelegate;
@interface SMURecoABUserACollectionHandler : NSObject <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *userAs;
@property (nonatomic, weak) id < SMURecoABUserACollectionHandlerDelegate > delegate;
@end

@protocol SMURecoABUserACollectionHandlerDelegate <NSObject>

- (void)SMURecoIntroduceUserACollectionHandler:(SMURecoABUserACollectionHandler *)recoIntroduceUserACollectionHandler didLoadUserBForIndexPath:(NSIndexPath *)indexPath;

@end