//
//  SMUConnectedUserCell.m
//  SetMeUp
//
//  Created by ArulRaj on 1/22/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUConnectedUserCell.h"
#import "SMUFCConnectedUser.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"

@implementation SMUConnectedUserCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_isActiveConnUser) {
        [SMUtils makeRoundedImageView:_connUserImage withBorderColor:appCommonItemsUIColor];
    }else {
        [SMUtils makeRoundedImageView:_connUserImage withBorderColor:appOnlineUserUIColor];
    }
}

-(void)setConnUser:(SMUFCConnectedUser *)connUser
{
    //NSLog(@"set connected user cell:%@",_connUser.firstname);
    _connUser=connUser;
    NSURL *url=[NSURL URLWithString:_connUser.imageUrl];
    [_connUserImage setImageWithURL:url placeholderImage:nil];
    _connUserImage.contentMode = UIViewContentModeScaleAspectFill;
    _connUserName.text = _connUser.firstname;
//    [_photoThumbnail setImageWithURL:url placeholderImage:nil];
}

-(void)setIsActiveConnUser:(BOOL)isActiveConnUser
{
    //_connUserImage.layer.borderColor = [appCommonItemsUIColor CGColor];
    _isActiveConnUser=isActiveConnUser;
    if (_isActiveConnUser) {
        _connUserImage.layer.borderColor=[appCommonItemsUIColor CGColor];
    }else {
        _connUserImage.layer.borderColor=[appOnlineUserUIColor CGColor];
    }
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
