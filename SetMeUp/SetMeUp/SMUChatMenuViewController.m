//
//  SMUChatMenuViewController.m
//  SetMeUp
//
//  Created by Go on 12/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUChatMenuViewController.h"
#import "SMUSharedResources.h"
#import "SMUWebServices.h"
#import "SMUHomeMessage.h"
#import "SMUConnectedUser.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUHomeMessage.h"
#import "UIImage+ImageEffects.h"

@interface SMUChatMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *chatMenuTableView;

@end

@implementation SMUChatMenuViewController
@synthesize searchDisplayController;
SMUHomeMessage *homeMessage;
SMUConnectedUser *connectedUser;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
   // NSLog(@"chat view didload");
    _chatListArray = [[NSMutableArray alloc]init];
    self.menuContainerViewController.menuWidth = 270.0f;
    //[self getMessage];
    [_connUserSearch setBackgroundColor:[UIColor clearColor]];
    [_connUserSearch setBarTintColor:[UIColor clearColor]];
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated {
  //  NSLog(@"chat view did appear");
   // NSLog(@"pan mode:%u",self.menuContainerViewController.panMode);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewForChatConn) name:@"ChatUsersRetrievedSuccessfully" object:nil];
    self.menuContainerViewController.menuWidth = 270.0f;
   // [self getMessage];
}

-(void)dismissKeyboard {
    NSLog(@"dismiss keyboard");
    self.menuContainerViewController.menuWidth = 270.0f;
    [_connUserSearch resignFirstResponder];
    _connUserSearch.showsCancelButton = NO;
    [self.view removeGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getMessage
-(void)getMessage {
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    [shRes fetchChatConnUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewForChatConn) name:@"ChatUsersRetrievedSuccessfully" object:nil];
}

- (void)prepareViewForChatConn;
{
    // NSLog(@"prepareViewsWithConnUser");
  //  [_chatListArray removeAllObjects];
    _chatListArray = [SMUSharedResources sharedResourceManager].chatConnUsersList;
    SMUHomeMessage *homeObj = (SMUHomeMessage *)[_chatListArray objectAtIndex:0];
   // NSLog(@"chat count:%d",[homeObj.connectedUser count]);
    [_savedArray removeAllObjects];
    [_connUserArray removeAllObjects];
    _savedArray = [[NSMutableArray alloc]initWithArray:homeObj.connectedUser];
    _connUserArray = [[NSMutableArray alloc]initWithArray:homeObj.connectedUser];
    [_chatMenuTableView reloadData];
    //  NSLog(@"connected user array:%d",[_fcConnUserArray count]);
    // [self loadselectedUserCheckin:_selectedIndex];
    
}


#pragma mark -
#pragma mark - UITableViewDataSource    UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"connected user count:%d",[homeMessage.connectedUser count]);
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 60;
    }
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCnt;
    rowCnt = [_connUserArray count];
    return rowCnt;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[self.chatMenuTableView dequeueReusableCellWithIdentifier:@"ChatMenuTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *personPhotoImageView=(UIImageView*)[cell.contentView viewWithTag:20];
    UIImageView *availabilityImageView=(UIImageView*)[cell.contentView viewWithTag:21];
    connectedUser = (SMUConnectedUser *)[_connUserArray objectAtIndex:indexPath.row];
    
    
    
    NSString *connectedUserUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",connectedUser.user_id];
    
    [personPhotoImageView setImageWithURL:[NSURL URLWithString:connectedUserUrl]];
    personPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [SMUtils makeRoundedImageView:personPhotoImageView withBorderColor:appOfflineUserUIColor];
    if (indexPath.row%4)
    {
        [self markAvailabilityImage:availabilityImageView isOnline:NO];
    }
    else
    {
        [self markAvailabilityImage:availabilityImageView isOnline:YES];
    }
    UILabel *nameLabel=(UILabel*)[cell.contentView viewWithTag:10];
    UILabel *descLabel=(UILabel*)[cell.contentView viewWithTag:11];
    //nameLabel.text=[NSString stringWithFormat:@"Friend %ld%ld",(long)indexPath.section, (long)indexPath.row];
    nameLabel.text = connectedUser.name;
    //NSLog(@"connected user name:%@ and count:%d",connectedUser.name,connectedUser.msgCount);
    
    
    if(connectedUser.msgCount > 0) {
    
    UILabel *notificationLbl = (UILabel*)[cell.contentView viewWithTag:100];
    UIImageView *notificationImg =(UIImageView *)[cell.contentView viewWithTag:101];
    
        notificationImg.hidden = NO;
        notificationLbl.hidden = NO;
        
    UIImage *notificationImage = [UIImage squareImageWithColor:[UIColor redColor] dimension:CGSizeMake(30.0, 30.0)];
    notificationImg.image = notificationImage;
    [SMUtils makeRoundedImageView:notificationImg withBorderColor:[UIColor clearColor]];
    NSString *str =[NSString stringWithFormat:@"%d",connectedUser.msgCount];
    
    notificationLbl.text = str;
    notificationLbl.textColor = [UIColor whiteColor];
    [notificationLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    } else {
        UILabel *notificationLbl = (UILabel*)[cell.contentView viewWithTag:100];
        UIImageView *notificationImg =(UIImageView *)[cell.contentView viewWithTag:101];
        notificationImg.hidden = YES;
        notificationLbl.hidden = YES;
    }
    if([connectedUser.b_user_name isEqualToString:@""]){
        descLabel.text=[NSString stringWithFormat:@"Matched on %@",connectedUser.b_user_connected_date];
    }else{
        descLabel.text=[NSString stringWithFormat:@"Introduced by %@",connectedUser.b_user_name];
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    connectedUser = (SMUConnectedUser *)[_connUserArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

  
    [connSearchBar resignFirstResponder];

    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:connectedUser.user_id];
    [def setObject:data1 forKey:@"selectedUser"];
    
    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:connectedUser.name];
    [def setObject:data2 forKey:@"selectedName"];
    
    [self makeDict:connectedUser];
    
    
//    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUConversationViewController"];
//    [self presentViewController:navigationController animated:YES completion:nil];
    
   
    UINavigationController  *navigationController = [self.storyboard  instantiateViewControllerWithIdentifier:@"ConversationNVC"];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
-(void)makeDict:(SMUConnectedUser *)connectedUser{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    

    
    NSString *name=connectedUser.b_user_name ;
     NSString *userid=connectedUser.b_user_id ;
     NSString *date=connectedUser.b_user_connected_date ;
     NSString *url=connectedUser.b_user_image_url ;
    
    [dict setObject:name forKey:@"bUserName"];
    [dict setObject:userid forKey:@"bUserId"];

    [dict setObject:date forKey:@"connectedDate"];
    [dict setObject:url forKey:@"bUserImageUrl"];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:dict forKey:@"connectedDetails"];

    
}
#pragma mark -
#pragma mark - Helpers

// Not used may be utilized in future
-(void)markUserImage:(UIImageView*)imageView isOnline:(BOOL)isOnline
{
    if (isOnline) {
        [SMUtils makeRoundedImageView:imageView withBorderColor:appOnlineUserUIColor];
    }
    else
    {
        [SMUtils makeRoundedImageView:imageView withBorderColor:appOfflineUserUIColor];
    }
}

-(void)markAvailabilityImage:(UIImageView*)imageView isOnline:(BOOL)isOnline
{
    [SMUtils makeRoundedImageView:imageView withBorderColor:nil];
    if (isOnline) {
        [imageView setBackgroundColor:appOnlineUserUIColor];
    }
    else{
        [imageView setBackgroundColor:appOfflineUserUIColor];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //[_searchTextField resignFirstResponder];
    return NO;
}

#pragma mark Content Filtering



-(void)filterData {
    if ([_connUserSearch.text length]==0) {
        [_connUserArray removeAllObjects];
        [_connUserArray addObjectsFromArray:_savedArray];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", _connUserSearch.text];
        [_connUserArray removeAllObjects];
        [_connUserArray addObjectsFromArray:[_savedArray filteredArrayUsingPredicate:predicate]];
    }
    [_chatMenuTableView reloadData];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    tap = [[UIPanGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.menuContainerViewController.menuWidth = 320.0f;
    //searchBar.frame = CGRectMake(0, 0, 320, 44);
   // _connUserSearch.frame = CGRectMake(0, 0, 270, 44);
    searchBar.showsCancelButton = YES;
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.chatMenuTableView.frame;
    frame.origin.y = 50;
    [self.chatMenuTableView setFrame:frame];
    [UIView commitAnimations];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.chatMenuTableView.frame;
    frame.origin.y = 50;
    [self.chatMenuTableView setFrame:frame];
    [UIView commitAnimations];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    self.menuContainerViewController.menuWidth = 270.0f;
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchBar.showsCancelButton = NO;
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.chatMenuTableView.frame;
    frame.origin.y = 50;
    [self.chatMenuTableView setFrame:frame];
    [UIView commitAnimations];
    [self filterData];
    [_chatMenuTableView reloadData];
    
}

@end
