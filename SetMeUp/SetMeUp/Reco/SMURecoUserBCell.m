//
//  SMURecoUserBCell.m
//  SetMeUp
//
//  Created by In on 29/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMURecoUserBCell.h"

@implementation SMURecoUserBCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(void)makeRoundedImageView:(UIImageView*)imageView withBorderColor:(UIColor*)color
{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 3.0;
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
}
-(void)drawRect:(CGRect)rect
{
    NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.imageView addConstraints:@[con1]];
    [self layoutIfNeeded];
    [SMURecoUserBCell makeRoundedImageView:_imageView withBorderColor:[UIColor whiteColor]];
     _imageView.contentMode=UIViewContentModeScaleAspectFill;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
