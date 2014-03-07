//
//  SMUQuipsCell.h
//  SMUReco
//
//  Created by In on 28/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDStarRating;
@protocol SMUQuipsCellDelegate;
@interface SMUQuipsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *quipsLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *button1, *button2;
@property (nonatomic, weak) id < SMUQuipsCellDelegate > delegate;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint,*heightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *ratingsTitleLable;
@property (strong, nonatomic) IBOutlet EDStarRating *starRating;
- (void)setViewNonEditable;
@end

@protocol SMUQuipsCellDelegate <NSObject>

- (void)quipsCell:(SMUQuipsCell *)quipsCell didButtonClicked:(UIButton *)button;
- (void)quipsCell:(SMUQuipsCell *)quipsCell starsSelectionChanged:(EDStarRating *)control rating:(float)rating;

@end
