//
//  SMURecoCUserACollectionHandler.h
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserA;

@interface SMURecoCUserACollectionHandler : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *userAs;
@end
