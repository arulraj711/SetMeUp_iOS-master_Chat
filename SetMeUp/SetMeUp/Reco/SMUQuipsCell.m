//
//  SMUQuipsCell.m
//  SMUReco
//
//  Created by In on 28/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMUQuipsCell.h"
#import "SMURecoCell.h"
#import "UIImageView+Additions.h"
#import "UIImage+ImageEffects.h"
#import "EDStarRating.h"
@interface SMUQuipsCell() < EDStarRatingProtocol >
-(IBAction)loadNext:(id)sender;
@end

@implementation SMUQuipsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    _starRating.backgroundColor  = [UIColor clearColor];
    _starRating.starImage = [[UIImage imageNamed:@"reco_default_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.starHighlightedImage = [[UIImage imageNamed:@"reco_active_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 0.0;
    _starRating.editable=YES;
    _starRating.rating= 0.0;
    _starRating.displayMode=EDStarRatingDisplayAccurate;
    [_starRating  setNeedsDisplay];
    _starRating.tintColor = [UIColor colorWithRed:(242.0/255.0) green:(232.0/255.0) blue:(89.0/255.0) alpha:1.0];
    [self starsSelectionChanged:_starRating rating:2.5];
}
-(IBAction)loadNext:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [self.delegate quipsCell:self didButtonClicked:button];
//    [self.delegate loadNextCellForSMUQuipsCell:self];
}
-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    [self.delegate quipsCell:self starsSelectionChanged:control rating:rating];
//    NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
- (void)setViewNonEditable
{
    [self.button1 setEnabled:NO];
    [self.button2 setEnabled:NO];
    _starRating.editable=NO;

//    [self.ratingView
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
