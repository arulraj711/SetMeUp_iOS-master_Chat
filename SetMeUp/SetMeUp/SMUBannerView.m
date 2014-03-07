//
//  SMUBannerView.m
//  SetMeUp
//
//  Created by ArulRaj on 2/19/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUBannerView.h"

@implementation SMUBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) setup
{
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 7.5, 25, 25)];
   // _iconImage.image = [UIImage imageNamed:@"letsmeet"];
    
    _msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 225, 30)];
    _msgLabel.textColor = [UIColor whiteColor];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
   // NSLog(@"msg string:%@",_msgString);
    //_msgLabel.text = _msgString;
    [self addSubview:_msgLabel];
    [self addSubview:_iconImage];
    
}


@end
