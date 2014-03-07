//
//  CollectionViewLayout.h
//  CollectionViewExample
//
//  Created by Paul Dakessian on 9/6/12.
//  Copyright (c) 2012 Paul Dakessian, CapTech Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMUHorizontalCollectionViewLayoutDelegate;
@interface SMUHorizontalCollectionViewLayout : UICollectionViewFlowLayout < UICollectionViewDelegateFlowLayout >
{
    UICollectionViewScrollDirection scrollDirection;
}
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, weak) id < SMUHorizontalCollectionViewLayoutDelegate > delegate;
@property (nonatomic, assign) float currentContentOffsetX;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) NSInteger pageCount;

-(UICollectionViewScrollDirection) scrollDirection;
-(void)configureCollectionViewXOffsetForIndexPath:(NSIndexPath *)indexPath;
@end


@protocol SMUHorizontalCollectionViewLayoutDelegate <NSObject>

- (void)SMUHorizontalCollectionViewLayout:(SMUHorizontalCollectionViewLayout *)horizontalCollectionViewLayout didLoadedPage:(NSUInteger )page;

@end