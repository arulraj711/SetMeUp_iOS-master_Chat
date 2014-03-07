//
//  SMUInterestsThumbCell.m
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUInterestsThumbCell.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"
#import "SMUInterest.h"

@interface SMUInterestsThumbCell ()
@property(nonatomic, strong) IBOutlet UIImageView *photoThumbnail;
@property(nonatomic, strong) IBOutlet UILabel *descLabel;
@end

@implementation SMUInterestsThumbCell

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
    NSLayoutConstraint *con1 = [NSLayoutConstraint constraintWithItem:self.photoThumbnail attribute:NSLayoutAttributeHeight relatedBy:0 toItem:self.photoThumbnail attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.photoThumbnail addConstraints:@[con1]];
    [SMUtils makeRoundedImageView:_photoThumbnail withBorderColor:nil];
}

-(void)setAInterest:(SMUInterest *)aInterest
{
    _aInterest=aInterest;
    NSURL *url=[NSURL URLWithString:_aInterest.photoUrlString];
    [_photoThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"likes_placehodler"]];
    
    //album_plac
    _descLabel.text=_aInterest.name;
    if (_aInterest.isCommon)
        _photoThumbnail.layer.borderColor=[appCommonItemsUIColor CGColor];
    else
        _photoThumbnail.layer.borderColor=[appDefaultUserUIColor CGColor];
}

-(void)setUserCObject:(SMUUserCInvite *)userCObject{
    
    _userCObject=userCObject;
    NSURL *url=[NSURL URLWithString:_userCObject.c_user_imgurl];
    [_photoThumbnail setImageWithURL:url placeholderImage:nil];
    _descLabel.textColor=[UIColor blackColor];
    _descLabel.text=_userCObject.c_user_name;
}

@end
