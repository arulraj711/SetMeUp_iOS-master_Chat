//
//  SMULoginViewController.h
//  SetMeUp
//
//  Created by Go on 15/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHWalkThroughView.h"
@interface SMULoginViewController : UIViewController
{
    UIView *useLessView;
}
@property (nonatomic, strong) GHWalkThroughView* ghView;

- (IBAction)fbButtonPressed:(id)sender;

@end
