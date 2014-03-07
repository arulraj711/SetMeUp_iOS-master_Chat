//
//  SMUFriendsThumbCell.m
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUFriendsThumbCell.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"
#import "SMUFriend.h"

@interface SMUFriendsThumbCell ()
@property(nonatomic, strong) IBOutlet UIImageView *photoThumbnail;
@property(nonatomic, strong) IBOutlet UILabel *descLabel;
@end

@implementation SMUFriendsThumbCell

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

-(void)setFriendObject:(SMUFriend *)friendObject
{
    _friendObject=friendObject;
    NSURL *url=[NSURL URLWithString:_friendObject.profilePicture];
    [_photoThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_per"]];
    _descLabel.text=friendObject.name;
}

-(void)setIsMutualFriend:(BOOL)isMutualFriend
{
    _isMutualFriend=isMutualFriend;
    if (_isMutualFriend)
        _photoThumbnail.layer.borderColor=[appCommonItemsUIColor CGColor];
    else
        _photoThumbnail.layer.borderColor=[appDefaultUserUIColor CGColor];
}

-(void)setDisplayOnlyPhoto:(BOOL)displayOnlyPhoto
{
    _displayOnlyPhoto=displayOnlyPhoto;
    if (_displayOnlyPhoto)
        _descLabel.hidden=YES;
    else
        _descLabel.hidden=NO;
}

@end
