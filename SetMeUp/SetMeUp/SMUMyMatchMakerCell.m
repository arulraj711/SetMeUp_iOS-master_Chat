//
//  SMUMyMatchMakerCell.m
//  SetMeUp
//
//  Created by In on 22/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUMyMatchMakerCell.h"
#import "SMUtils.h"
#import "UIImageView+WebCache.h"
#import "SMUFriend.h"

@interface SMUMyMatchMakerCell()

@property (nonatomic, strong) IBOutlet UILabel *matchMakerName;
@property (nonatomic, strong) IBOutlet UIImageView *matchMakerImageView;
@end

@implementation SMUMyMatchMakerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect
{
    if (_isActiveMatchmaker)
        [SMUtils makeRoundedImageView:_matchMakerImageView withBorderColor:appCommonItemsUIColor];
    else
        [SMUtils makeRoundedImageView:_matchMakerImageView withBorderColor:nil];
}

-(void)setSmuFriend:(SMUFriend *)smuFriend
{
    _smuFriend = smuFriend;
    NSURL *url=[NSURL URLWithString:_smuFriend.profilePicture];
    [_matchMakerImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder_per"]];
    _matchMakerName.text = _smuFriend.name;
}

-(void)setIsActiveMatchmaker:(BOOL)isActiveMatchmaker
{
    _isActiveMatchmaker=isActiveMatchmaker;
    if (_isActiveMatchmaker)
        _matchMakerImageView.layer.borderColor=[appCommonItemsUIColor CGColor];
    else
        _matchMakerImageView.layer.borderColor=[appDefaultUserUIColor CGColor];
}

@end
