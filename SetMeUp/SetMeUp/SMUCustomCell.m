//
//  SMUCustomCell.m
//  SetMeUp
//
//  Created by ArulRaj on 1/22/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCustomCell.h"
#import "SMUCheckin.h"
#import "UIImageView+WebCache.h"


@implementation SMUCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _placeImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        _placeName = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 180, 30)];
        _placeName.textColor = [UIColor blackColor];
        _placeAddress = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 100, 20)];
        _placeAddress.textColor = [UIColor grayColor];
        _placeAddress.font = [UIFont systemFontOfSize:10];
        _checkinDate = [[UILabel alloc]initWithFrame:CGRectMake(170, 30, 250, 20)];
        _checkinDate.textColor = [UIColor grayColor];
        _checkinDate.font = [UIFont systemFontOfSize:10];
        _checkinCount = [[UILabel alloc]initWithFrame:CGRectMake(280, 15, 25, 15)];
        _checkinCount.textColor = [UIColor greenColor];

        _checkinCount.textAlignment=NSTextAlignmentCenter;
        _checkinImage = [[UIImageView alloc]initWithFrame:CGRectMake(295, 18, 20, 10)];
        [self.contentView addSubview:_placeImage];
        [self.contentView addSubview:_placeName];
        [self.contentView addSubview:_placeAddress];
        [self.contentView addSubview:_checkinCount];
        [self.contentView addSubview:_checkinDate];
        [self.contentView addSubview:_checkinImage];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [SMUtils makeRoundedImageView:_placeImage withBorderColor:nil];
}

-(void)setSmuCheckin:(SMUCheckin *)smuCheckin {
     _smuCheckin = smuCheckin;
    [_placeImage setImageWithURL:[NSURL URLWithString:_smuCheckin.placeUrl] placeholderImage:nil];
    _placeName.text = _smuCheckin.placeName;
    _placeAddress.text = _smuCheckin.street;
    _checkinDate.text = [NSString stringWithFormat:@"Last Checked in %@",_smuCheckin.user_last_checkedin];
    int totalCheckinCnt = _smuCheckin.c_user_checkin_count+_smuCheckin.a_user_checkin_count;
    _checkinCount.text = [NSString stringWithFormat:@"%d",totalCheckinCnt];
    [_checkinImage setImage:[UIImage imageNamed:@"checkin_icon"]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
