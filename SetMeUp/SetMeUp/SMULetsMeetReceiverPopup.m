//
//  SMULetsMeetReceiverPopup.m
//  SetMeUp
//
//  Created by ArulRaj on 1/29/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMULetsMeetReceiverPopup.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUFirstConnectViewController.h"
#import "SMULoggedInUserMenuViewController.h"
#import "SMULetsMeet.h"
#import "SMUDateDetails.h"
#import "SMUPlaceDetails.h"
#import "SMUSharedReco.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "JPSThumbnailAnnotation.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
#define GEORGIA_TECH_LATITUDE 38.660547
#define GEORGIA_TECH_LONGITUDE -96.492357
#define ZOOM_LEVEL 15

@interface SMULetsMeetReceiverPopup ()

@end

@implementation SMULetsMeetReceiverPopup
SMUDateDetails *dateDetails;
SMUPlaceDetails *placeDetails;

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
    
    //NSLog(@"lets meet array:%@",_letsMeetArray);
    
    
    
    //_dateTextField.text = @"23213214124";
    _msgTextView.layer.borderColor=[letmeetBorderUIColor CGColor];
    _msgTextView.layer.borderWidth=1.0f;
    
    _dateTextField.layer.borderColor=[letmeetBorderUIColor CGColor];
    _dateTextField.layer.borderWidth=1.0f;
    
    _mapView.layer.borderColor=[letmeetBorderUIColor CGColor];
    _mapView.layer.borderWidth=1.0f;
    
    flag=0;
    
    [self setLetsMeetDetails];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)setLetsMeetDetails {
    
    //NSLog(@"lets meet count:%d and last object:%@",[_letsMeetArray count],_letsMeetArray);
    _letsMeetArray = [SMUSharedReco sharedReco].letsMeetArray;
    SMULetsMeet *letsMeet = (SMULetsMeet *)[_letsMeetArray lastObject];
    NSArray *dateArr = letsMeet.calendarDateArray;
    dateDetails = (SMUDateDetails *)[dateArr objectAtIndex:0];
    NSArray *placeArr = letsMeet.placeDetailsArray;
    placeDetails = (SMUPlaceDetails *)[placeArr objectAtIndex:0];
    
    //change the date status as read
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    [SMUWebServices changeLetsMeetStatusWithAccessToken:fbAccessToken forUserId:fbUserId type:@"AcceptDate" withDateId:dateDetails.dateId success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        
    }];
    
    
    NSString *profileImageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",dateDetails.from_msg_id];
    
    [_mapView addAnnotations:[self generateAnnotations:placeArr withUserImage:profileImageUrl]];
    
    
    _dateTextField.text = dateDetails.date_time;
    _dateTextField.textAlignment=NSTextAlignmentCenter;
    _msgTextView.text = dateDetails.from_message;
    _profileName.text = dateDetails.from_first_name;
    
    [_profileImage setImageWithURL:[NSURL URLWithString:profileImageUrl] placeholderImage:nil];
    _profileImage.contentMode = UIViewContentModeScaleAspectFill;
    [_placeImage setImageWithURL:[NSURL URLWithString:placeDetails.place_thumb_url] placeholderImage:nil];
    _placeName.text = placeDetails.place_name;
    NSString *streetName;
    if([placeDetails.street isEqualToString:@""] && [placeDetails.city isEqualToString:@""]&&[placeDetails.state isEqualToString:@""]&&[placeDetails.country isEqualToString:@""]) {
        streetName = @"";
    }else if([placeDetails.street isEqualToString:@""]&&[placeDetails.city isEqualToString:@""]&&[placeDetails.state isEqualToString:@""]) {
        streetName = placeDetails.country;
    } else if([placeDetails.street isEqualToString:@""] && [placeDetails.city isEqualToString:@""]&&[placeDetails.country isEqualToString:@""]) {
        streetName = placeDetails.state;
    } else if([placeDetails.street isEqualToString:@""]&&[placeDetails.state isEqualToString:@""]&&[placeDetails.country isEqualToString:@""]) {
        streetName = placeDetails.city;
    } else if([placeDetails.city isEqualToString:@""]&&[placeDetails.state isEqualToString:@""]&&[placeDetails.country isEqualToString:@""]) {
        streetName = placeDetails.street;
    } else if([placeDetails.street isEqualToString:@""] && [placeDetails.city isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",placeDetails.state,placeDetails.country];
    } else if([placeDetails.street isEqualToString:@""]&&[placeDetails.state isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",placeDetails.city,placeDetails.country];
    }else if([placeDetails.street isEqualToString:@""]&&[placeDetails.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",placeDetails.city,placeDetails.state];
    } else if([placeDetails.city isEqualToString:@""]&&[placeDetails.state isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",placeDetails.street,placeDetails.country];
    }else if([placeDetails.city isEqualToString:@""] && [placeDetails.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",placeDetails.street,placeDetails.state];
    } else if([placeDetails.state isEqualToString:@""] && [placeDetails.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",placeDetails.street,placeDetails.city];
    } else if([placeDetails.street isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",placeDetails.city,placeDetails.state,placeDetails.country];
    } else if([placeDetails.city isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",placeDetails.street,placeDetails.state,placeDetails.country];
    } else if([placeDetails.state isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",placeDetails.street,placeDetails.city,placeDetails.country];
    } else if([placeDetails.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",placeDetails.street,placeDetails.city,placeDetails.state];
    } else {
        streetName = [NSString stringWithFormat:@"%@,%@,%@,%@",placeDetails.street,placeDetails.city,placeDetails.state,placeDetails.country];
    }
    _streetName.text = streetName;
    NSString *lastCheckinDate;
    if(![placeDetails.c_user_last_checked_in isEqualToString:@""]) {
        lastCheckinDate = [NSString stringWithFormat:@"%@ checked in here last:%@",dateDetails.from_first_name,placeDetails.c_user_last_checked_in];
    } else {
        lastCheckinDate = @"";
    }
    
    _lastCheckinDate.text = lastCheckinDate;
    int totalCheckinCnt = placeDetails.c_user_checkin_count+placeDetails.a_user_checkin_count;
    _checkinCount.text = [NSString stringWithFormat:@"%d",totalCheckinCnt];
    [SMUtils makeRoundedImageView:_profileImage withBorderColor:nil];
    [SMUtils makeRoundedImageView:_placeImage withBorderColor:nil];
    //NSLog(@"From User Nameand placeName:%@",dateDetails.from_first_name);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLeftMenuPressed:(id)sender {
    NSString *flag1 = @"LetsMeet";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:flag1 forKey:@"flag"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)counterAction:(id)sender {
    flag=1;
    [_dateTextField becomeFirstResponder];
    [_counterBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [_counterBtn setTitle:@" Change" forState:UIControlStateNormal];
    [_acceptBtn setTitle:@" Meet Up" forState:UIControlStateNormal];
    //[_counterBtn set]
    //_counterBtn.backgroundColor = [UIColor redColor];
}

- (IBAction)letsMeetAction:(id)sender {
    
    [SMUWebServices confirmDateWithAccessToken:fbAccessToken forUserId:fbUserId withSelectedUserId:dateDetails.from_msg_id withPlaceId:placeDetails.place_id withDate:_dateTextField.text withType:dateDetails.checkinType comment:_msgTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *flag1 = @"LetsMeet";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:flag1 forKey:@"flag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        
    }];
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    

    [ self dismissViewAnimation];
    
    [textField resignFirstResponder];
    return YES;
}
/*- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(flag==1){
    if([textField isEqual:_dateTextField]){
        
        
        NSLog(@"coming into dateofBirth");
    }
    }else{
        
        
    }

    
}
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    BOOL status;
    if(flag==1){
        
        [self setDatebirth];
        status=YES;
    }else{
        status=NO;
    }
    
    return status;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
   
    _msgTextView.text = @"";
    
    _msgTextView.textColor = [UIColor blackColor];
    
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = -150;
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {

        [self dismissViewAnimation];
        [_msgTextView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{

   // NSLog(@"coming into textviewdidchange");
    if(_msgTextView.text.length == 0){

        [self dismissViewAnimation];
        [_msgTextView resignFirstResponder];
    }
}

-(void)dismissViewAnimation{
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = 65;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(void)setDatebirth{
    
    _dateTextField.text=@"";
    actionsheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionsheet setActionSheetStyle:UIActionSheetStyleDefault];
    CGRect pickerFrame=CGRectMake(0, 35, 0, 0);
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:pickerFrame];
    
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setMinimumDate:[NSDate date]];
    [actionsheet addSubview:datePicker];
    
    UIToolbar *ctrltoolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, actionsheet.bounds.size.width, 0)];
    
    [ctrltoolbar setBarStyle:UIBarStyleDefault];
    [ctrltoolbar sizeToFit];
    
    UIBarButtonItem *spacebar=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *setButton=[[UIBarButtonItem alloc]initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateSet:)];
    
    UIBarButtonItem *cancelButton  =[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDateSet:)];
    [ctrltoolbar setItems:[NSArray arrayWithObjects:spacebar,setButton,cancelButton, nil]];
    
    [actionsheet addSubview:ctrltoolbar];
    [actionsheet showInView:self.view];
    
    [actionsheet setBounds:CGRectMake(0, 0, 320, 480)];
    
    
}
-(void)dismissDateSet:(id)sender{
    
    // NSLog(@"dismiss");
    NSArray *listofarr=[actionsheet subviews];
    for (UIView *subView in listofarr) {
        if([subView isKindOfClass:[UIDatePicker class]]){
            self.birthdate=[(UIDatePicker *)subView date];
        }
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    

    
    [dateFormatter setDateFormat:@"'@'hh:mm:a 'on' EE MMM','dd'th'"];
    // NSLog(@"%@",self.birthdate);
    

    [_dateTextField setText:[dateFormatter stringFromDate:self.birthdate]];
    _dateTextField.textAlignment=NSTextAlignmentCenter;
    [self dismissViewAnimation];
    [_dateTextField resignFirstResponder];
    
    [dateFormatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    
    dateStr=[dateFormatter stringFromDate:self.birthdate];
   // dateStr=(NSString *)self.birthdate;
    //
    //
    //    NSLog(@"date:%@",dateStr);
    
    
    
    
    [actionsheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)cancelDateSet:(id)sender{
    [actionsheet dismissWithClickedButtonIndex:0 animated:YES];
    [self dismissViewAnimation];
    [_dateTextField resignFirstResponder];
}

- (NSArray *)generateAnnotations:(NSArray *)array withUserImage:(NSString *)imgUrl  {
    annotations = [[NSMutableArray alloc] init];
    SMUPlaceDetails *checkinObj = (SMUPlaceDetails *)[array objectAtIndex:0];
    //NSLog(@"loaded checkin:%@",checkinObj);
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    NSString *profileUrl = imgUrl;
    //NSLog(@"profile url:%@",profileUrl);
    empire.image = profileUrl;
    empire.profileImage = profileUrl;
    empire.title = checkinObj.place_name;
    empire.subtitle = checkinObj.street;
    empire.cntLabel = [NSString stringWithFormat:@"%d",checkinObj.a_user_checkin_count];
    //        NSString *placeURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=80&height=80",[[dic objectForKey:@"Ucheckin"] objectForKey:@"place_id"]];
    empire.placeImage = checkinObj.place_thumb_url;
    empire.coordinate = CLLocationCoordinate2DMake(checkinObj.lattitude,checkinObj.longitude);
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(checkinObj.lattitude,checkinObj.longitude);
    
    empire.disclosureBlock = ^{  };
    [annotations insertObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire] atIndex:[annotations count]];
    [self setCenterCoordinate:_mapView.centerCoordinate zoomLevel:15 animated:YES];
    newAnnotations = annotations;
    //NSLog(@"annotation count:%@",annotations);
    return annotations;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:_mapView centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    
    [_mapView  setRegion:region animated:animated];
}

#pragma mark -
#pragma mark Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

@end
