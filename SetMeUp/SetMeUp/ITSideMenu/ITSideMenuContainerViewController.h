//
//  ITSideMenuContainerViewController.h
//  ITSideMenuDemoSplitViewController
//
//  Created by Go on 12/11/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITSideMenuShadow.h"

extern NSString * const ITSideMenuStateNotificationEvent;

typedef enum {
    ITSideMenuPanModeNone = 0, // pan disabled
    ITSideMenuPanModeCenterViewController = 1 << 0, // enable panning on the centerViewController
    ITSideMenuPanModeSideMenu = 1 << 1, // enable panning on side menus
    ITSideMenuPanModeDefault = ITSideMenuPanModeCenterViewController | ITSideMenuPanModeSideMenu
} ITSideMenuPanMode;

typedef enum {
    ITSideMenuStateClosed, // the menu is closed
    ITSideMenuStateLeftMenuOpen, // the left-hand menu is open
    ITSideMenuStateRightMenuOpen // the right-hand menu is open
} ITSideMenuState;

typedef enum {
    ITSideMenuStateEventMenuWillOpen, // the menu is going to open
    ITSideMenuStateEventMenuDidOpen, // the menu finished opening
    ITSideMenuStateEventMenuWillClose, // the menu is going to close
    ITSideMenuStateEventMenuDidClose // the menu finished closing
} ITSideMenuStateEvent;


@interface ITSideMenuContainerViewController : UIViewController<UIGestureRecognizerDelegate>

+ (ITSideMenuContainerViewController *)containerWithCenterViewController:(id)centerViewController
                                                  leftMenuViewController:(id)leftMenuViewController
                                                 rightMenuViewController:(id)rightMenuViewController;

@property (nonatomic, strong) id centerViewController;
@property (nonatomic, strong) UIViewController *leftMenuViewController;
@property (nonatomic, strong) UIViewController *rightMenuViewController;

@property (nonatomic, assign) ITSideMenuState menuState;
@property (nonatomic, assign) ITSideMenuPanMode panMode;

// menu open/close animation duration -- user can pan faster than default duration, max duration sets the limit
@property (nonatomic, assign) CGFloat menuAnimationDefaultDuration;
@property (nonatomic, assign) CGFloat menuAnimationMaxDuration;

// width of the side menus
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat leftMenuWidth;
@property (nonatomic, assign) CGFloat rightMenuWidth;

// shadow
@property (nonatomic, strong) ITSideMenuShadow *shadow;

// menu slide-in animation
@property (nonatomic, assign) BOOL menuSlideAnimationEnabled;
@property (nonatomic, assign) CGFloat menuSlideAnimationFactor; // higher = less menu movement on animation


- (void)toggleLeftSideMenuCompletion:(void (^)(void))completion;
- (void)toggleRightSideMenuCompletion:(void (^)(void))completion;
- (void)setMenuState:(ITSideMenuState)menuState completion:(void (^)(void))completion;
- (void)setMenuWidth:(CGFloat)menuWidth animated:(BOOL)animated;
- (void)setLeftMenuWidth:(CGFloat)leftMenuWidth animated:(BOOL)animated;
- (void)setRightMenuWidth:(CGFloat)rightMenuWidth animated:(BOOL)animated;

// can be used to attach a pan gesture recognizer to a custom view
- (UIPanGestureRecognizer *)panGestureRecognizer;

@end