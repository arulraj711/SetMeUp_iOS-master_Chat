//
//  SMURecoBottomView.m
//  SetMeUp
//
//  Created by In on 26/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMURecoBottomView.h"
#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"

@implementation SMURecoBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)applyBlurEffect:(UIView *)bgView
{
    UIImage *bottomImage = [_bottomImageView blurredBackgroundImageWithBackgroundView:bgView];
    bottomImage = [bottomImage applyLightDarkEffect];
    _bottomImageView.image = bottomImage;

}
- (IBAction)ignore:(UIButton *)button
{
    [self.delegate didIgnoreButtonClickedSMURecoBottomView:self];
}
- (IBAction)introduce:(UIButton *)button
{
    [self.delegate didIntroduceButtonClickedSMURecoBottomView:self];
}

@end
