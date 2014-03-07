//
//  SMURecoCUserACollectionViewLayout.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoCUserACollectionViewLayout.h"

@implementation SMURecoCUserACollectionViewLayout
-(id)initWIthCollectionViewFrame:(CGRect)collectionViewFrame
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        if(collectionViewFrame.size.height > 230 )
        {
            //  iPhone 4 inch
           // NSLog(@"4 inch");
            self.minimumLineSpacing = 30.0;
            self.sectionInset = UIEdgeInsetsMake(0.0, 55.0, 0, 55.0);
            self.itemSize = CGSizeMake(200,240  );
        }
        else
        {
            //  iPhone 3.5 inch
            //NSLog(@"3.5 inch");
            self.minimumLineSpacing = 40.0;
            self.sectionInset = UIEdgeInsetsMake(0.0, 85.0, 0, 85.0);
            self.itemSize = CGSizeMake(160,200  );
        }
        self.pageSize = CGSizeMake(self.itemSize.width + self.minimumLineSpacing, self.itemSize.height);
        self.contentSize = CGSizeMake(self.pageSize.width * self.pageCount, self.pageSize.height);
    }
    return self;
}
@end
