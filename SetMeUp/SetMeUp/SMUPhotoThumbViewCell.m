//
//  SMUPhotoThumbViewCell.m
//  SetMeUp
//
//  Created by Go on 20/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUPhotoThumbViewCell.h"
#import "UIImageView+WebCache.h"
#import "SMUtils.h"
#import "SMUPhoto.h"

@interface SMUPhotoThumbViewCell()
@property(nonatomic, strong) IBOutlet UIImageView *photoThumbnail;
@end

@implementation SMUPhotoThumbViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [SMUtils makeRoundedImageView:_photoThumbnail withBorderColor:nil];
}

-(void)setAPhoto:(SMUPhoto *)aPhoto
{
    _aPhoto=aPhoto;
    NSURL *url=[NSURL URLWithString:_aPhoto.photoURLstring];
    [_photoThumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"album_plac"]];
}

@end
