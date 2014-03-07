//
//  SPHBubbleCellOther.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHBubbleCellOther : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Avatar_Image;
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusindicator;

@end
