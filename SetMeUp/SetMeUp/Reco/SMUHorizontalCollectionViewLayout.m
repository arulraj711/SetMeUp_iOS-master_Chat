//
//  CollectionViewLayout.m
//  CollectionViewExample
//
//  Created by Paul Dakessian on 9/6/12.
//  Copyright (c) 2012 Paul Dakessian, CapTech Consulting. All rights reserved.
//

#import "SMUHorizontalCollectionViewLayout.h"
@interface SMUHorizontalCollectionViewLayout()


@end;
@implementation SMUHorizontalCollectionViewLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 50.0;
        self.sectionInset = UIEdgeInsetsMake(10.0, 100.0, 0, 100.0);
        
        CGSize size = CGSizeMake(120,150  );
        self.itemSize = size;

        self.pageSize = CGSizeMake(self.itemSize.width + self.minimumLineSpacing, self.itemSize.height);
        self.contentSize = CGSizeMake(self.pageSize.width * self.pageCount, self.pageSize.height);
  }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.pageCount = [self.collectionView numberOfItemsInSection:0];
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    return array;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    float current = _currentContentOffsetX;
    float diff = fabsf(proposedContentOffset.x - current);
    
    if(diff < (self.pageSize.width /2.0))
    {
        //Nothing
        return CGPointMake(current, proposedContentOffset.y);
    }
    
    if(proposedContentOffset.x < current)
    {
        current -= self.pageSize.width;
    }
    else
    {
        current += self.pageSize.width;
    }
    
    if(current < 0)
        current = 0;
    
    if(current >= ((self.pageCount * self.pageSize.width) + 0.0))
        current -= self.pageSize.width;
    _currentContentOffsetX = current;
//    NSLog(@" %f %f",_currentContentOffsetX, self.pageSize.width);
    NSUInteger page = _currentContentOffsetX / self.pageSize.width;
    [self.delegate SMUHorizontalCollectionViewLayout:self didLoadedPage:page];
    return CGPointMake(_currentContentOffsetX, proposedContentOffset.y);
}
-(void)configureCollectionViewXOffsetForIndexPath:(NSIndexPath *)indexPath
{
    float offsetX = (self.pageSize.width) * indexPath.row;
    _currentContentOffsetX = offsetX;
//    NSLog(@"configureCollectionViewXOffsetForIndexPath _currentContentOffsetX :%f",_currentContentOffsetX);
}

//- (BOOL)isValidOffset:(CGFloat)offset
//{
//    return (offset >= [self minContentOffset] && offset <= [self maxContentOffset]);
//}
//
//- (CGFloat)minContentOffset
//{
//    return -self.collectionView.contentInset.left;
//}
//
//- (CGFloat)maxContentOffset
//{
//	return [self minContentOffset] + self.collectionView.contentSize.width - self.itemSize.width;
//}
//
//- (CGFloat)snapStep
//{
//	return self.itemSize.width + self.minimumLineSpacing;
//}
@end