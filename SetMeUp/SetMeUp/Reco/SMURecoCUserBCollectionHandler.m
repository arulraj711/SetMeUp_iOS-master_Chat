//
//  SMURecoCUserBCollectionHandler.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoCUserBCollectionHandler.h"
#import "SMURecoCell.h"
#import "SMUHorizontalCollectionViewLayout.h"
#import "SMURecoUserB.h"
#import "SMUBCReco.h"
#import <UIImageView+AFNetworking.h>
@implementation SMURecoCUserBCollectionHandler

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.userBs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SMURecoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    SMUBCReco *reco = self.userBs[indexPath.row];
    SMURecoUserB *userA = reco.userB;
    NSURL *url=[NSURL URLWithString:userA.imageUrl];
    [cell.imageView setImageWithURL:url placeholderImage:nil];
    [cell.nameLabel setFont:[UIFont fontWithName:@"System" size:17.0]];
    cell.nameLabel.text = userA.firstname;
    [SMURecoCell makeRoundedImageView:cell.imageView withBorderColor:[UIColor colorWithRed:(144.0/255.0) green:(123.0/255.0) blue:(207.0/255.0) alpha:1.0]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    SMUHorizontalCollectionViewLayout *layout = ( SMUHorizontalCollectionViewLayout *)collectionView.collectionViewLayout;
  //  [layout configureCollectionViewXOffsetForIndexPath:indexPath];
    [self.delegate SMURecoCUserBCollectionHandler:self didLoadUserBForIndexPath:indexPath];
}

@end
