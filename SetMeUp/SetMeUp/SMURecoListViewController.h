//
//  SMURecoListViewController.h
//  SetMeUp
//
//  Created by In on 03/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMURecoListViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger closedRecoCount;
//@property (strong, nonatomic) IBOutlet UIImageView *notificationImage;
@property (nonatomic,strong) NSString *checkSelection;
- (IBAction)showLeftMenuPressed:(id)sender;

- (IBAction)refreshButtonPressed:(id)sender;

-(void)loadRecoTable;
@end
