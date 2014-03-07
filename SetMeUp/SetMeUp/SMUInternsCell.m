//
//  SMUInternsCell.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUInternsCell.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"
@implementation SMUInternsCell

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
  [SMUtils makeRoundedImageView:_internImageView withBorderColor:nil];
}

-(void)setInterns:(SMUInterns *)smuInterns
{
    _interns = smuInterns;
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",_interns.InternId];
    NSURL *url=[NSURL URLWithString:urlString];
    [_internImageView setImageWithURL:url placeholderImage:nil];

    _internName.text = _interns.InternName;
}

-(void)setIsSelected:(BOOL)isSelectedImage
{
    _isSelected=isSelectedImage;
    if (_isSelected)
        _internImageView.layer.borderColor=[appCommonItemsUIColor CGColor];
    else
        _internImageView.layer.borderColor=[appDefaultUserUIColor CGColor];
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
