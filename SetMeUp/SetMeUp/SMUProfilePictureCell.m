//
//  SMUProfilePictureCell.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUProfilePictureCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@implementation SMUProfilePictureCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    //    NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:self.photoThamnail attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.photoThamnail attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    //    [self.photoThamnail addConstraints:@[con1]];
    if (_isSelectedImage)
        [SMUtils makeRoundedImageView:_photoThamnail withBorderColor:appCommonItemsUIColor];
    else
        [SMUtils makeRoundedImageView:_photoThamnail withBorderColor:nil];
}
-(void)setProfilePicture:(SMUUserAPicture *)smuProfile
{
    _profilePicture=smuProfile;
    NSURL *url=[NSURL URLWithString:_profilePicture.picUrl];
    _defaultUrl=_profilePicture.defaultUrl;
    [_photoThamnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_per"]];
    _photoThamnail.contentMode = UIViewContentModeScaleAspectFill;
//    if(_profilePicture.defaultUrl==1){
//        _photoThamnail.layer.borderColor=[appCommonItemsUIColor CGColor];
//    }else{
//        _photoThamnail.layer.borderColor=[appDefaultUserUIColor CGColor];
//    }
    
}
-(void)setIsSelectedImage:(BOOL)isSelectedImage
{
    //NSLog(@"coming into set");
    _isSelectedImage=isSelectedImage;
    if (_isSelectedImage)
        _photoThamnail.layer.borderColor=[appCommonItemsUIColor CGColor];
    else
        _photoThamnail.layer.borderColor=[appDefaultUserUIColor CGColor];
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
