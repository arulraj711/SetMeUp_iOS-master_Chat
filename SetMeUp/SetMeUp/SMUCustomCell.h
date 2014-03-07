//
//  SMUCustomCell.h
//  SetMeUp
//
//  Created by ArulRaj on 1/22/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMUCheckin;
@interface SMUCustomCell : UITableViewCell

@property (nonatomic, assign) SMUCheckin *smuCheckin;
@property (nonatomic,strong) UIImageView *placeImage;
@property (nonatomic,strong) UILabel *placeName;
@property (nonatomic,strong) UILabel *placeAddress;
@property (nonatomic,strong) UILabel *checkinDate;
@property (nonatomic,strong) UILabel *checkinCount;
@property (nonatomic,strong) UIImageView *checkinImage;
@end
