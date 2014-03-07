//
//  SMURecoCUserBCollectionHandler.h
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserB;
@protocol SMURecoCUserBCollectionHandlerDelegate;
@interface SMURecoCUserBCollectionHandler : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *userBs;
@property (nonatomic, weak) id < SMURecoCUserBCollectionHandlerDelegate > delegate;
@end


@protocol SMURecoCUserBCollectionHandlerDelegate <NSObject>

- (void)SMURecoCUserBCollectionHandler:(SMURecoCUserBCollectionHandler *)recoCUserBCollectionHandler didLoadUserBForIndexPath:(NSIndexPath *)indexPath;

@end