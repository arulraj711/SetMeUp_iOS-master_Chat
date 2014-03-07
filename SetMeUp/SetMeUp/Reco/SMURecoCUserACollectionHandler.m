//
//  SMURecoCUserACollectionHandler.m
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoCUserACollectionHandler.h"
#import "SMURecoCell.h"
#import "SMUHorizontalCollectionViewLayout.h"
#import "SMURecoUserA.h"
#import "UIImageView+AFNetworking.h"
@implementation SMURecoCUserACollectionHandler

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.userAs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SMURecoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    [SMURecoCell makeRoundedImageView:cell.imageView withBorderColor:[UIColor whiteColor]];
    SMURecoUserA *userA = self.userAs[indexPath.row];
    [cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    
    CALayer *layer=[cell.nameLabel layer];
    layer.shadowColor=[[UIColor blackColor] CGColor];
    layer.shadowOpacity=0.7;
    layer.shadowOffset=CGSizeMake(0,0);
    
    [cell.nameLabel.layer setMasksToBounds:YES];
    
    cell.nameLabel.text = userA.name;
    [SMURecoCell makeRoundedImageView:cell.imageView withBorderColor:[UIColor whiteColor]];
    NSURL *url=[NSURL URLWithString:userA.img_url];
    [cell.imageView setImageWithURL:url placeholderImage:nil];

    
    UIImageView *img;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(screenBounds.size.height == 568) {
    img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.imageView.frame.origin.x+10,cell.imageView.frame.origin.y + 135, 165, 48)];
    }else{
    img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.imageView.frame.origin.x,cell.imageView.frame.origin.y + 100, 144, 48)];
    }
    
    
    img.image = [UIImage imageNamed:@"info"];
    [cell.imageView addSubview:img];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    SMUHorizontalCollectionViewLayout *layout = ( SMUHorizontalCollectionViewLayout *)collectionView.collectionViewLayout;
    [layout configureCollectionViewXOffsetForIndexPath:indexPath];
    
    
}

@end
