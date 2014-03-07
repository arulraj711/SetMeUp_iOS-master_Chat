//
//  SMURecoListViewCell.h
//  SetMeUp
//
//  Created by In on 04/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMURecoListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelTwo;

@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightSideImageView;
@property (strong, nonatomic) IBOutlet UIImageView *notoficationImageView;
@property (strong, nonatomic) IBOutlet UILabel *notificationCountLabel;


@end
