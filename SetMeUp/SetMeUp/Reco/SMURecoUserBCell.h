//
//  SMURecoUserBCell.h
//  SetMeUp
//
//  Created by In on 29/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMURecoUserBCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView  *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

+(void)makeRoundedImageView:(UIImageView*)imageView withBorderColor:(UIColor*)color;

@end
