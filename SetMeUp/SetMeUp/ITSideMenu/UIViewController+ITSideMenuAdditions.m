//
//  UIViewController+ITSideMenuAdditions.m
//  ITSideMenuDemoBasic
//
//  Created by Go on 12/11/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "UIViewController+ITSideMenuAdditions.h"
#import "ITSideMenuContainerViewController.h"

@implementation UIViewController (ITSideMenuAdditions)

@dynamic menuContainerViewController;

- (ITSideMenuContainerViewController *)menuContainerViewController {
    id containerView = self;
    while (![containerView isKindOfClass:[ITSideMenuContainerViewController class]] && containerView) {
        if ([containerView respondsToSelector:@selector(parentViewController)])
            containerView = [containerView parentViewController];
        if ([containerView respondsToSelector:@selector(splitViewController)] && !containerView)
            containerView = [containerView splitViewController];
    }
    return containerView;
}

@end