//
//  SMUProfilePictureCell.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUUserAPicture.h"
@interface SMUProfilePictureCell : UICollectionViewCell

@property (nonatomic, assign) SMUUserAPicture *profilePicture;


@property(nonatomic, readwrite) BOOL isSelectedImage;
@property(assign)NSInteger defaultUrl;
@property (weak, nonatomic) IBOutlet UIImageView *photoThamnail;

@end
