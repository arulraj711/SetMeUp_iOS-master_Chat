//
//  SMULoginTutorialViewController.h
//  SetMeUp
//
//  Created by Go on 15/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMULoginTutorialViewControllerDelegate;

@interface SMULoginTutorialViewController : UIViewController
{
    NSMutableAttributedString *attString,*attString1;
}
@property (nonatomic,readwrite) NSUInteger pageIndex;
@property (nonatomic, weak) id<SMULoginTutorialViewControllerDelegate> delegate;
@property(nonatomic,strong) NSMutableAttributedString* attrStr;



@end

@protocol SMULoginTutorialViewControllerDelegate <NSObject>
@optional
-(void)loginButtonClickedInSMULoginTutorialViewController:(SMULoginTutorialViewController*)tutorialVc;
-(void)startOverButtonClickedInSMULoginTutorialViewController:(SMULoginTutorialViewController*)tutorialVc;
@end