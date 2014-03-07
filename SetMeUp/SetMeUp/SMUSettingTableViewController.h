//
//  SMUSettingTableViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticTableParentProtocol.h"
#import "StaticTableViewControllerProtocol.h"

@interface SMUSettingTableViewController : UITableViewController<StaticTableViewControllerProtocol>
{
    BOOL wasSelected;
    NSString *fbAccessToken,*userId;
}

@property (nonatomic, weak) UIViewController <StaticTableParentProtocol> *delegate;
- (IBAction)syncButtonPressed:(id)sender;

- (IBAction)toggleValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UISlider *milSlider;

- (IBAction)sliderValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;

@end