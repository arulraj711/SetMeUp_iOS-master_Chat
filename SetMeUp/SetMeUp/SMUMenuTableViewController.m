//
//  SMUMenuTableViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUMenuTableViewController.h"
#import "UITableView+indexPathForCellContainingView.h"
#import "SMURecentStatus.h"
#import "UIImage+ImageEffects.h"
@interface SMUMenuTableViewController ()

@end

@implementation SMUMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecenStatusUpdated:) name:@"RecentStatusUpdated" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRecenStatusUpdated:(id)sender
{
    NSNotification *notification = sender;
    NSDictionary *userInfo = notification.userInfo;
    SMURecentStatus *recentStatus = [userInfo objectForKey:@"RecentStatus"];
    //NSLog(@"after updating recent status:%d",recentStatus.bRecoCount);
    
    int notificationCnt = recentStatus.bRecoCount+recentStatus.cRecoCount;
    NSString *notificationStr = [NSString stringWithFormat:@"%d",notificationCnt];

    if(notificationCnt > 0) {
        _notificationImage.hidden = NO;
        _notificationLabel.hidden = NO;
    _notificationLabel.text = notificationStr;
        [_notificationLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    UIImage *notificationImage = [UIImage squareImageWithColor:[UIColor redColor] dimension:CGSizeMake(30.0, 30.0)];
    _notificationImage.image = notificationImage;
    [SMUtils makeRoundedImageView:self.notificationImage withBorderColor:[UIColor clearColor]];
    } else {
        _notificationImage.hidden = YES;
        _notificationLabel.hidden = YES;
    }
    //[userProfileObj saveCustomObject:userProfile key:@"UserInfo"];
    
   // [self updateViewWithUserProfile:userProfile];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    wasSelected = [indexPath compare: currentSelection] == NSOrderedSame;
    return indexPath;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //If the cell started out selected, un-select it.
    if (wasSelected)
    {
        [self.tableView deselectRowAtIndexPath: indexPath animated: NO];
    }
    if ([self.delegate respondsToSelector: @selector(tableView:didSelect:cellAtIndexPath:inViewController:)])
    {
        [self.delegate tableView: tableView
                       didSelect:  !wasSelected
                 cellAtIndexPath: indexPath
                inViewController: self];
    }
}

- (void) deselectItemsWithAnimation: (BOOL) animation;
{
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath: currentSelection animated: animation];
}


- (IBAction)searchToolButtonPressed:(id)sender {
    
    //NSLog(@"coming into searchbuttonPressed");
    
    if ([self.delegate respondsToSelector: @selector(tableView:didSelect:cellAtIndexPath:inViewController:)])
    {
        NSIndexPath *buttonIndexPath = [self.tableView indexPathForCellContainingView: sender];
        [self.delegate tableView: self.tableView
                   clickedButton: sender
                     atIndexPath: buttonIndexPath
                inViewController: self];
    }
    
}
@end
