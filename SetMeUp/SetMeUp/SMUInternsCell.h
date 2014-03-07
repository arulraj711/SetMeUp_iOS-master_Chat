//
//  SMUInternsCell.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUInterns.h"
@interface SMUInternsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *internImageView;

@property (weak, nonatomic) IBOutlet UILabel *internName;
@property (nonatomic, assign) SMUInterns *interns;


@property(nonatomic, readwrite) BOOL isSelected;
@end
