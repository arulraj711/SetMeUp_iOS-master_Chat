//
//  SMURecoIntroduceUserCCollectionHandler.m
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoABUserCCollectionHandler.h"
#import "SMURecoCell.h"
#import "SMUHorizontalCollectionViewLayout.h"
#import "SMURecoUserC.h"
#import "SMURecoUserCCell.h"
#import "UIImageView+WebCache.h"

@implementation SMURecoABUserCCollectionHandler

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.userCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SMURecoUserCCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    SMURecoUserC *userc = self.userCs[indexPath.row];
    NSURL *url=[NSURL URLWithString:userc.img_url];
    [cell.imageView setImageWithURL:url placeholderImage:nil];
     cell.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [cell.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:12.0]];
    
    CALayer *layer=[cell.nameLabel layer];
    layer.shadowColor=[[UIColor blackColor] CGColor];
    layer.shadowOpacity=0.7;
    layer.shadowOffset=CGSizeMake(0,0);
    
    [cell.nameLabel.layer setMasksToBounds:YES];
    cell.nameLabel.text = userc.firstname;
    [cell setSelected:NO];
    [SMURecoCell makeRoundedImageView:cell.imageView withBorderColor:(userc.isSelected ? [UIColor colorWithRed:(124.0/255.0) green:(226.0/255.0) blue:(124.0/255.0) alpha:1.0]: [UIColor colorWithRed:(255.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0])];

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMURecoUserC *userc = self.userCs[indexPath.row];
    SMURecoUserCCell *cell = ( SMURecoUserCCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //NSLog(@"selected :%d",cell.selected);
    userc.isSelected = !userc.isSelected;
    [SMURecoCell makeRoundedImageView:cell.imageView withBorderColor:(userc.isSelected ? [UIColor colorWithRed:(124.0/255.0) green:(226.0/255.0) blue:(124.0/255.0) alpha:1.0]: [UIColor colorWithRed:(255.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0])];
}
@end
