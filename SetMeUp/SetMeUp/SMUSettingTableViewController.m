//
//  SMUSettingTableViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/31/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUSettingTableViewController.h"

#import "SMUFeedBackViewController.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
@interface SMUSettingTableViewController ()

@end

@implementation SMUSettingTableViewController

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
    
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    
    _milSlider.minimumValue = 1;
    _milSlider.maximumValue = 100;
    
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


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    wasSelected = [indexPath compare: currentSelection] == NSOrderedSame;
    return indexPath;
}

//-----------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    //If the cell started out selected, un-select it.
    
  
    if(indexPath.section==0 && row==0){
        
        //NSLog(@"coming into first row");
    }
    
    if(indexPath.section==1 && row==0){
        
       // NSLog(@"coming into second row");
    }
    if(indexPath.section==2 && row==0){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.setmeupapp.com/about"]];
    }
    if(indexPath.section==2 && row==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.setmeupapp.com/terms_of_service"]];
    }
    if(indexPath.section==3 && row==0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/SetMeUpapp"]];
        
    }
    if(indexPath.section==3 && row==1){
        
       // NSLog(@"coming into feedback");
        
        
        UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUFeedBackViewController"];
        [self presentViewController:navigationController animated:YES completion:nil];
        

        
    }
    if(indexPath.section==5 && row==0){
        
        
    }
    if(indexPath.section==5 && row==1){
        
        
    }
    
}


- (IBAction)syncButtonPressed:(id)sender {
    

    [[SMUSharedResources sharedResourceManager] showProgressHUDForView];
    
    
    [SMUWebServices faceBookSyncProcessWithAccessToken:fbAccessToken forUserId:userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //NSLog(@"sync button clicked");
}

- (IBAction)toggleValueChanged:(id)sender {
    
    if(_toggleSwitch.on){
        
        [SMUWebServices changeStatusOfNotificationWithAccessToken:fbAccessToken forUserId:userId ofType:@"Push" withStatus:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        //NSLog(@"toggle is off");
        [SMUWebServices changeStatusOfNotificationWithAccessToken:fbAccessToken forUserId:userId ofType:@"Push" withStatus:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }

}
- (IBAction)sliderValueChanged:(id)sender {
    
    
    NSInteger val = lround(_milSlider.value);
    _milesLabel.text=[NSString stringWithFormat:@"%d mi.",val];
}
@end
