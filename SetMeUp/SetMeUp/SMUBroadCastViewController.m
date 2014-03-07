//
//  SMUBroadCastViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/8/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUBroadCastViewController.h"
#import "SMUSharedResources.h"
#import "UIImageView+WebCache.h"
#import "SMUConnectUser.h"
#import "SMUWebServices.h"
#import "SMUUserProfile.h"
@interface SMUBroadCastViewController ()

@end

@implementation SMUBroadCastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedUserArray = [[NSMutableArray alloc]init];
    
	// Do any additional setup after loading the view.
    [self loadViewDetails];
    
}
-(void)loadViewDetails{
    
    
    _sliderForMiles.minimumValue = 1;
    _sliderForMiles.maximumValue = 100;
    
    
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    
    [shRes fetchConnectedUserForBC];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithConnUser) name:@"ConnectedUserForBCFetched" object:nil];
    
}
-(void)prepareViewsWithConnUser{
    
    _userDetails=[SMUSharedResources sharedResourceManager].connectedUserForBroadcast;
    //NSLog(@"userDetails:%@",_userDetails);
    //SMUConnectUser *user=(SMUConnectUser *)[_userDetails objectAtIndex:0];
    //NSLog(@"profile:%@",user.profilePicture);
    [_connectedUsertbl reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"connected user count:%d",[homeMessage.connectedUser count]);
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCnt;
    rowCnt = [_userDetails count];
    return rowCnt;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"coming into cellforrow");
    UITableViewCell *cell=[self.connectedUsertbl dequeueReusableCellWithIdentifier:@"ConnectedUserCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *personPhotoImageView=(UIImageView*)[cell.contentView viewWithTag:20];

   
    SMUConnectUser *connectUser=(SMUConnectUser *)[_userDetails objectAtIndex:indexPath.row];

    [personPhotoImageView setImageWithURL:[NSURL URLWithString:connectUser.profilePicture]];
    personPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [SMUtils makeRoundedImageView:personPhotoImageView withBorderColor:appOfflineUserUIColor];
       UILabel *descLabel=(UILabel*)[cell.contentView viewWithTag:10];
    descLabel.text=connectUser.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"did select tableviewwwww");
    
    SMUConnectUser *connectUser=(SMUConnectUser *)[_userDetails objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([_selectedUserArray containsObject:connectUser]) {
        //NSLog(@"already exist");
        [_selectedUserArray removeObject:connectUser];
        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
        selectedIconImageView.image = [UIImage imageNamed:@"unchecked_status"];
    } else {
        //NSLog(@"new item");
        [_selectedUserArray addObject:connectUser];
        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
        selectedIconImageView.image = [UIImage imageNamed:@"checked_status"];
    }
    
    
//    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
    
    
}
- (IBAction)slideValueChanged:(id)sender {
    
    NSInteger val = lround(_sliderForMiles.value);
    _mileLabel.text=[NSString stringWithFormat:@"%d mi.",val];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)broadcastPressed:(id)sender {
    NSMutableArray *selectedIdArray = [[NSMutableArray alloc]init];
    for(int i=0;i<[_selectedUserArray count];i++) {
        SMUConnectUser *connectUser=(SMUConnectUser *)[_selectedUserArray objectAtIndex:i];
        [selectedIdArray addObject:connectUser.userID];
    }
    NSString *connUserId = [selectedIdArray componentsJoinedByString:@","];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    //NSLog(@"latt:%f and long:%f and slider:%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,_sliderForMiles.value);
    NSString *lat = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
    NSString *milesRadius = [NSString stringWithFormat:@"%f",_sliderForMiles.value];
    NSString *jsonString = [self createJSONforBroadcastDetails:lat withLongitude:lon withMileRadius:milesRadius];
    
    SMUSharedResources * shRes = [SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    NSString *fbUserId=shRes.userProfile.userID;
    
    
    [SMUWebServices sendBroadCastLocationWithAccessToken:fbAccessToken forUserId:fbUserId withBroadCastDetails:jsonString withSelectedUser:connUserId success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self dismissViewControllerAnimated:YES completion:^{
             
         }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"error :%@",error);
     }];
    
}


-(NSString *)createJSONforBroadcastDetails:(NSString *)lattitude withLongitude:(NSString *)longitude withMileRadius:(NSString *)radius
{
    NSString *jsonString;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:lattitude forKey:@"latitude"];
    [dict setObject:longitude forKey:@"logitude"];
    [dict setObject:radius forKey:@"radius"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // NSLog(@"json string:%@",jsonString);
    }
    return jsonString;
}
@end
