//
//  SMURecoListViewCell.m
//  SetMeUp
//
//  Created by In on 04/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMURecoListViewCell.h"
#import "SMUtils.h"
#import "UIImage+ImageEffects.h"

@implementation SMURecoListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    //NSLog(@"awakeFromNib :");
    [SMUtils makeRoundedImageView:self.profileImageView withBorderColor:[UIColor clearColor]];
    [SMUtils makeRoundedImageView:self.rightSideImageView withBorderColor:[UIColor clearColor]];
    UIImage *notificationImage = [UIImage squareImageWithColor:[UIColor redColor] dimension:CGSizeMake(30.0, 30.0)];
    _notoficationImageView.image = notificationImage;
    [SMUtils makeRoundedImageView:self.notoficationImageView withBorderColor:[UIColor clearColor]];

}
@end
