//
//  SMURecoBottomView.h
//  SetMeUp
//
//  Created by In on 26/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMURecoBottomViewDelegate;
@interface SMURecoBottomView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) id < SMURecoBottomViewDelegate > delegate;
- (void)applyBlurEffect:(UIView *)bgView;
- (IBAction)ignore:(UIButton *)button;
- (IBAction)introduce:(UIButton *)button;


@end

@protocol SMURecoBottomViewDelegate <NSObject>

- (void)didIgnoreButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView;
- (void)didIntroduceButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView;

@end