//
//  SMUMenuTableViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticTableViewControllerProtocol.h"
#import "StaticTableParentProtocol.h"
@interface SMUMenuTableViewController : UITableViewController <StaticTableViewControllerProtocol>
{
    BOOL wasSelected;
}
@property (nonatomic, weak) UIViewController <StaticTableParentProtocol> *delegate;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *notificationImage;
- (IBAction)searchToolButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *notificationlabeltwo;


@end
