//
//  SMURecoIntroduceUserCCollectionHandler.h
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMURecoABUserCCollectionHandler : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *userCs;
@end
