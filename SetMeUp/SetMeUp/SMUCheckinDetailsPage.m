//
//  SMUCheckinDetailsPage.m
//  SetMeUp
//
//  Created by ArulRaj on 2/12/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCheckinDetailsPage.h"
#import "SPGooglePlacesPlaceDetailQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "SMUSharedResources.h"
#import "SMUConnectUser.h"
#import "SMUWebServices.h"

@interface SMUCheckinDetailsPage ()

@end

@implementation SMUCheckinDetailsPage
SPGooglePlacesAutocompletePlace *place;

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
    _selectedName = [[NSMutableArray alloc]init];
    //NSLog(@"selected placed dic:%@",_selectedDic);
    
   // self.title = @"SEARCH PLACES";
    
    NSString *letsmeetFlag = @"no";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:letsmeetFlag forKey:@"checkinflag"];
    
    NSString *letsmeetFlag1 = @"no";
    [def setObject:letsmeetFlag1 forKey:@"letsmeetflag"];
    placeDetailQuery = [[SPGooglePlacesPlaceDetailQuery alloc]init];
    place = (SPGooglePlacesAutocompletePlace *)_selectedDic;
  //  NSLog(@"place object:%@",place.reference);
   // placeDetailQuery.reference = [_selectedDic objectForKey:@"Reference"];
    placeDetailQuery.reference = place.reference;
    [placeDetailQuery fetchPlaceDetail:^(NSDictionary *placeDic,NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
            //NSLog(@"place details:%@",placeDic);
            _selectedPlaceDic = placeDic;
            //NSLog(@"place reference:%@",[_selectedPlaceDic objectForKey:@"reference"]);
            

            _photoArray = [placeDic objectForKey:@"photos"];
//            NSLog(@"photoArray:%@",photoArray);
//            if(photoArray == nil) {
//                NSLog(@"photo array nil");
//            } else {
//                NSLog(@"photo array not nil");
//            }
            _photoDic = [_photoArray objectAtIndex:0];
            _placeUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=60&photoreference=%@&sensor=true&key=AIzaSyBBva3CDp1gn8vWrNwsrRao55HEhDV8xPs",[_photoDic objectForKey:@"photo_reference"]];
           // NSLog(@"image url:%@",_placeUrlStr);
            [_placeImage setImageWithURL:[NSURL URLWithString:_placeUrlStr] placeholderImage:[UIImage imageNamed:@"fb_place"]];
            [SMUtils makeRoundedImageView:_placeImage withBorderColor:nil];
            _placeName.text = [_selectedPlaceDic objectForKey:@"name"];
           // NSLog(@"street name:%@",[_selectedPlaceDic objectForKey:@"formatted_address"]);
            _streetName.text = [_selectedPlaceDic objectForKey:@"formatted_address"];
            [self loadViewDetails];
        }
    }];
    
   
    
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self showTutorialView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)createCheckinJSONFormat:(NSDictionary *)dic {
    NSString *jsonString;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
        [dict setObject:[dic objectForKey:@"id"] forKey:@"place_id"];
        [dict setObject:[dic objectForKey:@"name"] forKey:@"place_name"];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[dic objectForKey:@"name"] forKey:@"checkedPlace"];
        
        NSArray *array = [[dic objectForKey:@"formatted_address"]componentsSeparatedByString:@","];
        // NSLog(@"array:%@ and count:%d",array,[array count]);
        NSString *street,*city,*state,*country;
        if([array count]>=5) {
            country = [array objectAtIndex:4];
            state = [array objectAtIndex:3];
            city = [array objectAtIndex:2];
            street = [array objectAtIndex:1];
        } else if([array count] == 4){
            country = [array objectAtIndex:3];
            state = [array objectAtIndex:2];
            city = [array objectAtIndex:1];
            street = [array objectAtIndex:0];
        } else if([array count] == 3) {
            country = [array objectAtIndex:2];
            state = [array objectAtIndex:1];
            city = [array objectAtIndex:0];
            street = @"";
        } else if([array count] == 2) {
            country = [array objectAtIndex:1];
            state = [array objectAtIndex:0];
            city = @"";
            street = @"";
        } else if([array count] == 1) {
            country = [array objectAtIndex:0];
            state =@"";
            city = @"";
            street = @"";
        } else {
            country = @"";
            state = @"";
            city =@"";
            street = @"";
        }
        [dict setObject:street forKey:@"street"];
        [dict setObject:city forKey:@"city"];
        [dict setObject:state forKey:@"state"];
        [dict setObject:country forKey:@"country"];
        if(_photoArray == nil) {
            [dict setObject:@"" forKey:@"photo_reference"];
        } else {
            [dict setObject:[_photoDic objectForKey:@"photo_reference"] forKey:@"photo_reference"];
        }
        [dict setObject:place.reference forKey:@"place_reference"];
        [dict setObject:[[[dic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]forKey:@"latitude"];
        [dict setObject:[[[dic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] forKey:@"longitude"];
        [dict setObject:@"IOS" forKey:@"application_type"];
        NSString *radius = [NSString stringWithFormat:@"%f",_milesRadius.value];
        [dict setObject:radius forKey:@"radius"];
        
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if (! jsonData) {
            //        //NSLog(@"Got an error: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //        // NSLog(@"json string:%@",jsonString);
        }
    
    return jsonString;
}


-(void)loadViewDetails{
    _milesRadius.minimumValue = 1;
    _milesRadius.maximumValue = 100;
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    [shRes fetchConnectedUserForBC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithConnectedUser) name:@"ConnectedUserForBCFetched" object:nil];
    
}

-(void)prepareViewsWithConnectedUser{
    
    _userDetails=[SMUSharedResources sharedResourceManager].connectedUserForBroadcast;
    //NSLog(@"userDetails:%@",_userDetails);
   // SMUConnectUser *user=(SMUConnectUser *)[_userDetails objectAtIndex:0];
    //NSLog(@"profile:%@",user.profilePicture);
    [_connectedUserTable reloadData];
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
    //NSLog(@"coming into cellfor row");
    UITableViewCell *cell=[self.connectedUserTable dequeueReusableCellWithIdentifier:@"ConnectedUserCell"];
    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConnectedUserCell"];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *personPhotoImageView=(UIImageView*)[cell.contentView viewWithTag:20];
    
    
    SMUConnectUser *connectUser=(SMUConnectUser *)[_userDetails objectAtIndex:indexPath.row];
    
    //NSLog(@"selectedUser array:%@ and connectedUser:%@",_selectedUserArray,connectUser.name);
    
    if([_selectedName containsObject:connectUser.name]) {
        //NSLog(@"correct");
        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
        selectedIconImageView.image = [UIImage imageNamed:@"checked_status"];
    }else {
       // NSLog(@"not correct");
        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
        selectedIconImageView.image = [UIImage imageNamed:@"unchecked"];
    }
    
    [personPhotoImageView setImageWithURL:[NSURL URLWithString:connectUser.profilePicture]];
    personPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [SMUtils makeRoundedImageView:personPhotoImageView withBorderColor:appBarTextUIColor];
    UILabel *descLabel=(UILabel*)[cell.contentView viewWithTag:10];
    descLabel.text=connectUser.name;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SMUConnectUser *connectUser=(SMUConnectUser *)[_userDetails objectAtIndex:indexPath.row];
//    if([_selectedUserArray containsObject:connectUser]) {
//        // NSLog(@"already exist");
//        [_selectedUserArray removeObject:connectUser];
//        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
//        selectedIconImageView.image = [UIImage imageNamed:@"unchecked"];
//    } else {
//        // NSLog(@"new item");
//        [_selectedUserArray addObject:connectUser];
//        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
//        selectedIconImageView.image = [UIImage imageNamed:@"checked_status"];
//    }
//}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"did select tableviewwwww");
    
    SMUConnectUser *connectUser=(SMUConnectUser *)[_userDetails objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if([_selectedName containsObject:connectUser.name]) {
       // NSLog(@"already exist");
       
        [_selectedName removeObject:connectUser.name];
        [_selectedUserArray removeObject:connectUser];
        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
        selectedIconImageView.image = [UIImage imageNamed:@"unchecked"];
       
    } else {
       // NSLog(@"new item");
        [_selectedName addObject:connectUser.name];
        [_selectedUserArray addObject:connectUser];
        UIImageView *selectedIconImageView=(UIImageView*)[cell.contentView viewWithTag:30];
        selectedIconImageView.image = [UIImage imageNamed:@"checked_status"];
    }
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


- (IBAction)checkinBtn:(id)sender {
    
    //NSLog(@"selected didcc:%@",_selectedPlaceDic);
    
    [self performSelector:@selector(delayAlert) withObject:nil afterDelay:2.0];
    

}

-(void)delayAlert{
    if([_selectedPlaceDic objectForKey:@"id"]==NULL) {
        //NSLog(@"correct");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet available" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        NSString *checkinflag = @"yes";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:checkinflag forKey:@"checkinflag"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        NSString *checkinDetailsStr = [self createCheckinJSONFormat:_selectedPlaceDic];
        //  NSLog(@"checkin details str:%@",checkinDetailsStr);
        
        SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
        NSString *fbAccessToken=[shRes getFbAccessToken];
        NSString *fbUserId=[shRes getFbLoggedInUserId];
        
        
        NSMutableArray *selectedIdArray = [[NSMutableArray alloc]init];
        for(int i=0;i<[_selectedUserArray count];i++) {
            SMUConnectUser *connectUser=(SMUConnectUser *)[_selectedUserArray objectAtIndex:i];
            [selectedIdArray addObject:connectUser.userID];
        }
        NSString *connUserId = [selectedIdArray componentsJoinedByString:@","];
        
        // [dict setObject:connUserId forKey:@"selected_users"];
        
        [SMUWebServices updateMobileCheckinWithAccessToken:fbAccessToken forUserId:fbUserId withCheckinDetails:checkinDetailsStr withSelectedUsers:connUserId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
            
        }];
        
    }
}

-(void)showTutorialView {
    
    NSString *checkinTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"checkinTutorialStatus"];
   // NSLog(@"reco tutorial status:%@",recoTutorialStatus);
    if([checkinTutorialStatus isEqualToString:@"New"]) {
    NSString *fcTutorialStatus1 = @"Old";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:fcTutorialStatus1 forKey:@"checkinTutorialStatus"];
    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
    _ghView.pageControl.hidden = YES;
    _ghView.pageControl1.hidden = YES;
    [_ghView setDataSource:self];
    // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    self.ghView.floatingHeaderView = nil;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    [self.navigationController.view addSubview:self.ghView];
    [self.ghView showInView:self.navigationController.view animateDuration:0.3];
    //
     }
}

#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 1;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"checkin_tutorial"];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

- (IBAction)sliderChanged:(id)sender {
    NSInteger val = lround(_milesRadius.value);
    _milesLabel.text=[NSString stringWithFormat:@"%d mi.",val];
}
@end
