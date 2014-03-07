//
//  SMURecoCUserBCollectionViewLayout.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoCUserBCollectionViewLayout.h"

@implementation SMURecoCUserBCollectionViewLayout
-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 70.0;
        self.sectionInset = UIEdgeInsetsMake(0.0, 120.0, 0, 130.0);
        
        CGSize size = CGSizeMake(80,110);
        self.itemSize = size;
        
        self.pageSize = CGSizeMake(self.itemSize.width + self.minimumLineSpacing, self.itemSize.height);
        self.contentSize = CGSizeMake(self.pageSize.width * self.pageCount, self.pageSize.height);
    }
    return self;
}

@end
