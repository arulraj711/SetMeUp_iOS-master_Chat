//
//  SMUConnectedUserCell.h
//  SetMeUp
//
//  Created by ArulRaj on 1/22/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMUFCConnectedUser;
@interface SMUConnectedUserCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *connUserImage;
@property (strong, nonatomic) IBOutlet UILabel *connUserName;
@property(nonatomic, strong) SMUFCConnectedUser *connUser;
@property(nonatomic, readwrite) BOOL isActiveConnUser;
@end
