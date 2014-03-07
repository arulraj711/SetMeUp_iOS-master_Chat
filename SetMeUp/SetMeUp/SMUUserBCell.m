//
//  SMUUserBCell.m
//  SetMeUp
//
//  Created by In on 24/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUUserBCell.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"
#import "SMUFriend.h"

@interface SMUUserBCell ()
@property(nonatomic, strong) IBOutlet UIImageView *photoThumbnail;

@end

@implementation SMUUserBCell

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
    if (_isMutualFriend) {
        [SMUtils makeRoundedImageView:_photoThumbnail withBorderColor:appCommonItemsUIColor];
    }
    else{
        [SMUtils makeRoundedImageView:_photoThumbnail withBorderColor:appOnlineUserUIColor];
    }
}

-(void)setSmuFriend:(SMUFriend *)smuFriend
{
    _smuFriend = smuFriend;
    NSURL *url=[NSURL URLWithString:_smuFriend.profilePicture];
    [_photoThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_per"]];
}

-(void)setIsMutualFriend:(BOOL)isMutualFriend
{
//    UIImage *img = [UIImage imageNamed:@"checked_status"];
//    UIImageView *image = [[UIImageView alloc]initWithImage:img];
//    [_photoThumbnail addSubview:image];
    _isMutualFriend=isMutualFriend;
    if (isMutualFriend) {
        _photoThumbnail.alpha = 1.0;
       
        [SMUtils makeRoundedImageView:_photoThumbnail withBorderColor:appCommonItemsUIColor];
    }
    else{
        
        _photoThumbnail.alpha = 1.0;
//        UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _photoThumbnail.frame.size.width, _photoThumbnail.frame.size.height / 2)];
//        [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
//        [_photoThumbnail addSubview:overlay];
        
        [SMUtils makeRoundedImageView:_photoThumbnail withBorderColor:appOnlineUserUIColor];
    }
}

@end
