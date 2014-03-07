//
//  SMURecoIntroduceCollectionHandler.m
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoABUserACollectionHandler.h"
#import "SMURecoCell.h"
#import "SMUHorizontalCollectionViewLayout.h"
#import "SMURecoUserA.h"
#import "SMURecoAB.h"
#import "UIImageView+WebCache.h"

@implementation SMURecoABUserACollectionHandler
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
    SMURecoUserA *userA = [(SMURecoAB * )self.userAs[indexPath.row] userA];
    NSURL *url=[NSURL URLWithString:userA.img_url];
    [cell.imageView setImageWithURL:url placeholderImage:nil];
    
   // NSLog(@"cell width %f and height:%f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
    
    UIImageView *img;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(screenBounds.size.height == 568) {
        img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.imageView.frame.origin.x,cell.imageView.frame.origin.y+87, 120, 30)];
    }else{
        img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.imageView.frame.origin.x+10,cell.imageView.frame.origin.y+93, 100, 25)];
    }
    
    img.image = [UIImage imageNamed:@"descri"];

    [cell.imageView addSubview:img];
    [cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    
    CALayer *layer=[cell.nameLabel layer];
    layer.shadowColor=[[UIColor blackColor] CGColor];
    layer.shadowOpacity=0.7;
    layer.shadowOffset=CGSizeMake(0,0);
    
    [cell.nameLabel.layer setMasksToBounds:YES];
    cell.nameLabel.text = userA.firstname;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    SMUHorizontalCollectionViewLayout *layout = ( SMUHorizontalCollectionViewLayout *)collectionView.collectionViewLayout;
    [layout configureCollectionViewXOffsetForIndexPath:indexPath];
    
    [self.delegate SMURecoIntroduceUserACollectionHandler:self didLoadUserBForIndexPath:indexPath];
}
@end
