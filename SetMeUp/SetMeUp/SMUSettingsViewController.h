//
//  SMUSettingsViewController.h
//  SetMeUp
//
//  Created by ArulRaj on 1/20/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMUSettingsViewController : UIViewController
{
    NSString *fbAccessToken,*userId;
}
- (IBAction)showLeftMenuPressed:(id)sender;

- (IBAction)fbButtonClick:(id)sender;
- (IBAction)twButtonClick:(id)sender;
- (IBAction)linkButtonClick:(id)sender;

@end
