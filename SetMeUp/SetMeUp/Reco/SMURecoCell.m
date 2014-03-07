//
//  Cell.m
//  CollectionViewExample
//
//  Created by Paul Dakessian on 9/6/12.
//  Copyright (c) 2012 Paul Dakessian, CapTech Consulting. All rights reserved.
//

#import "SMURecoCell.h"

@implementation SMURecoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
+(void)makeRoundedImageView:(UIImageView*)imageView withBorderColor:(UIColor*)color
{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 3.0;
    if (color)
        imageView.layer.borderColor = [color CGColor];
    else
        imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
}
-(void)drawRect:(CGRect)rect
{
    NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.imageView addConstraints:@[con1]];
    [self layoutIfNeeded];
    [SMURecoCell makeRoundedImageView:_imageView withBorderColor:[UIColor whiteColor]];
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
   

}
@end