//
//  UIViewController+ITSideMenuAdditions.h
//  ITSideMenuDemoBasic
//
//  Created by Go on 12/11/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ITSideMenuContainerViewController;

// category on UIViewController to provide reference to the menuContainerViewController in any of the contained View Controllers
@interface UIViewController (ITSideMenuAdditions)

@property(nonatomic,readonly,retain) ITSideMenuContainerViewController *menuContainerViewController;

@end

