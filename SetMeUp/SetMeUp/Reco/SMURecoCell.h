//
//  Cell.h
//  CollectionViewExample
//
//  Created by Paul Dakessian on 9/6/12.
//  Copyright (c) 2012 Paul Dakessian, CapTech Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMURecoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView  *imageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

+(void)makeRoundedImageView:(UIImageView*)imageView withBorderColor:(UIColor*)color;

@end

