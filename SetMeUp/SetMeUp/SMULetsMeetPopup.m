//
//  SMULetsMeetPopup.m
//  SetMeUp
//
//  Created by ArulRaj on 1/27/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMULetsMeetPopup.h"
#import "UIImageView+WebCache.h"
#import "SMUSharedResources.h"
#import "SMUCheckin.h"
#import "JPSThumbnailAnnotation.h"
#import "SMUWebServices.h"
#import <QuartzCore/QuartzCore.h>
#import "SMUConstants.h"
#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395
#define GEORGIA_TECH_LATITUDE 38.660547
#define GEORGIA_TECH_LONGITUDE -96.492357
#define ZOOM_LEVEL 15

@interface SMULetsMeetPopup ()
@property (nonatomic,strong) NSMutableArray *letsMeetArray;
@end

@implementation SMULetsMeetPopup

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
    
    NSString *letsmeetFlag = @"no";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:letsmeetFlag forKey:@"letsmeetflag"];
    NSString *checkinFlag = @"no";
    [def setObject:checkinFlag forKey:@"checkinflag"];
    _msgTextView.layer.borderColor=[letmeetBorderUIColor CGColor];
    _msgTextView.layer.borderWidth=1.0f;
    _msgTextView.text = @" Add a message..";
    msgStr= @" Add a message..";
    _dateTextField.layer.borderColor=[letmeetBorderUIColor CGColor];
    _dateTextField.layer.borderWidth=1.0f;
    
    _msgTextView.textColor =[UIColor blackColor];
    //UIColor *color = [UIColor lightTextColor];
     UIColor *color = [UIColor blackColor];
    _dateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Select Date and Time" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self getLetsMeetCheckinDetails];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - getMessage
-(void)getLetsMeetCheckinDetails {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"selectedCheckinDetails"];
    _selectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
   // NSLog(@"selected Dic in letsmeet:%@",_selectedDic);
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
 //   [shRes fetchDateSuggestionDetails:[_selectedDic objectForKey:@"placeId"]];
    //[shRes fetchDateSuggestionDetails:[_selectedDic objectForKey:@"placeId"] withSelectedUserId:[_selectedDic objectForKey:@"userId"]];

    [shRes fetchDateSuggestionDetails:[_selectedDic objectForKey:@"placeId"] withSelectedUserId:[_selectedDic objectForKey:@"userId"] withType:[_selectedDic objectForKey:@"type"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsforLetsMeet) name:@"LetsMeetCheckinRetrieved" object:nil];
    
}


- (void)prepareViewsforLetsMeet;
{
    // NSLog(@"prepareViewsWithConnUser");
    _letsMeetArray = [SMUSharedResources sharedResourceManager].letsMeetCheckin;
    //NSLog(@"connected user array:%d",[_letsMeetArray count]);
    SMUCheckin *selectedCheckin = (SMUCheckin *)[_letsMeetArray objectAtIndex:0];
    
    _mapView.layer.borderWidth=1;
    _mapView.layer.borderColor=[letmeetBorderUIColor CGColor];
    [_mapView addAnnotations:[self generateAnnotations:_letsMeetArray withUserImage:[_selectedDic objectForKey:@"userUrl"]]];
    
    [_profileImage setImageWithURL:[NSURL URLWithString:[_selectedDic objectForKey:@"userUrl"]] placeholderImage:nil];
    _profileImage.contentMode = UIViewContentModeScaleAspectFill;
   // NSLog(@"selected checkin:%@ and %@",selectedCheckin.placeUrl,selectedCheckin.placeName);
    _profileName.text = [_selectedDic objectForKey:@"userName"];
    [_placeImage setImageWithURL:[NSURL URLWithString:selectedCheckin.placeUrl] placeholderImage:nil];
    _placeName.text = selectedCheckin.placeName;
    NSString *streetName;
    if([selectedCheckin.street isEqualToString:@""] && [selectedCheckin.city isEqualToString:@""]&&[selectedCheckin.state isEqualToString:@""]&&[selectedCheckin.country isEqualToString:@""]) {
        streetName = @"";
    }else if([selectedCheckin.street isEqualToString:@""]&&[selectedCheckin.city isEqualToString:@""]&&[selectedCheckin.state isEqualToString:@""]) {
        streetName = selectedCheckin.country;
    } else if([selectedCheckin.street isEqualToString:@""] && [selectedCheckin.city isEqualToString:@""]&&[selectedCheckin.country isEqualToString:@""]) {
        streetName = selectedCheckin.state;
    } else if([selectedCheckin.street isEqualToString:@""]&&[selectedCheckin.state isEqualToString:@""]&&[selectedCheckin.country isEqualToString:@""]) {
        streetName = selectedCheckin.city;
    } else if([selectedCheckin.city isEqualToString:@""]&&[selectedCheckin.state isEqualToString:@""]&&[selectedCheckin.country isEqualToString:@""]) {
        streetName = selectedCheckin.street;
    } else if([selectedCheckin.street isEqualToString:@""] && [selectedCheckin.city isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",selectedCheckin.state,selectedCheckin.country];
    } else if([selectedCheckin.street isEqualToString:@""]&&[selectedCheckin.state isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",selectedCheckin.city,selectedCheckin.country];
    }else if([selectedCheckin.street isEqualToString:@""]&&[selectedCheckin.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",selectedCheckin.city,selectedCheckin.state];
    } else if([selectedCheckin.city isEqualToString:@""]&&[selectedCheckin.state isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",selectedCheckin.street,selectedCheckin.country];
    }else if([selectedCheckin.city isEqualToString:@""] && [selectedCheckin.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",selectedCheckin.street,selectedCheckin.state];
    } else if([selectedCheckin.state isEqualToString:@""] && [selectedCheckin.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@",selectedCheckin.street,selectedCheckin.city];
    } else if([selectedCheckin.street isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",selectedCheckin.city,selectedCheckin.state,selectedCheckin.country];
    } else if([selectedCheckin.city isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",selectedCheckin.street,selectedCheckin.state,selectedCheckin.country];
    } else if([selectedCheckin.state isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",selectedCheckin.street,selectedCheckin.city,selectedCheckin.country];
    } else if([selectedCheckin.country isEqualToString:@""]) {
        streetName = [NSString stringWithFormat:@"%@,%@,%@",selectedCheckin.street,selectedCheckin.city,selectedCheckin.state];
    } else {
        streetName = [NSString stringWithFormat:@"%@,%@,%@,%@",selectedCheckin.street,selectedCheckin.city,selectedCheckin.state,selectedCheckin.country];
    }
    _streetName.text = streetName;
    if([selectedCheckin.user_last_checkedin_by isEqualToString:@"a"]){
        NSString *lastCheckinDate = [NSString stringWithFormat:@"You have checked in here last:%@",selectedCheckin.user_last_checkedin];
        _lastCheckinDate.text = lastCheckinDate;
        
    }else{
        NSString *lastCheckinDate = [NSString stringWithFormat:@"%@ checked in here last:%@",[_selectedDic objectForKey:@"userName"],selectedCheckin.user_last_checkedin];
        _lastCheckinDate.text = lastCheckinDate;
    }
    
    
    int totalCheckinCnt = selectedCheckin.c_user_checkin_count+selectedCheckin.a_user_checkin_count;
    _checkinCount.text = [NSString stringWithFormat:@"%d",totalCheckinCnt];
    
    [SMUtils makeRoundedImageView:_placeImage withBorderColor:nil];
    [SMUtils makeRoundedImageView:_profileImage withBorderColor:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
    
    NSString *letsmeetFlag = @"yes";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:letsmeetFlag forKey:@"backbuttonflag"];
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    
    [ self dismissViewAnimation];
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if([textField isEqual:_dateTextField]){
        
        [self setDatebirth];
        //NSLog(@"coming into dateofBirth");
    }
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = -150;
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([_msgTextView.text isEqualToString:@" Add a message.."]){
        _msgTextView.text = @"";
        msgStr=@"";
    }
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
        if([_msgTextView.text isEqualToString:@""])
            
        {    _msgTextView.textColor = [UIColor blackColor];
            _msgTextView.text=@" Add a message..";
            msgStr=@" Add a message..";
        }
        [self dismissViewAnimation];
        [_msgTextView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    //NSLog(@"coming into textviewdidchange");
    if(_msgTextView.text.length == 0){
        _msgTextView.textColor = [UIColor blackColor];
        _msgTextView.text = @" Add a message..";
        msgStr=@" Add a message..";
        [self dismissViewAnimation];
        [_msgTextView resignFirstResponder];
    }
}

-(void)dismissViewAnimation{
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}


- (NSArray *)generateAnnotations:(NSMutableArray *)array withUserImage:(NSString *)imgUrl  {
    annotations = [[NSMutableArray alloc] init];
        SMUCheckin *checkinObj = (SMUCheckin *)[array objectAtIndex:0];
    //NSLog(@"loaded checkin:%@",checkinObj);
        JPSThumbnail *empire = [[JPSThumbnail alloc] init];
        NSString *profileUrl = imgUrl;
        //NSLog(@"profile url:%@",profileUrl);
        empire.image = profileUrl;
        empire.profileImage = profileUrl;
        empire.title = checkinObj.placeName;
        empire.subtitle = checkinObj.street;
        empire.cntLabel = [NSString stringWithFormat:@"%d",checkinObj.a_user_checkin_count];
        //        NSString *placeURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=80&height=80",[[dic objectForKey:@"Ucheckin"] objectForKey:@"place_id"]];
        empire.placeImage = checkinObj.placeUrl;
        empire.coordinate = CLLocationCoordinate2DMake(checkinObj.lattitude,checkinObj.longitude);
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(checkinObj.lattitude,checkinObj.longitude);
        
        empire.disclosureBlock = ^{  };
        [annotations insertObject:[[JPSThumbnailAnnotation alloc] initWithThumbnail:empire] atIndex:[annotations count]];
        [self setCenterCoordinate:_mapView.centerCoordinate zoomLevel:15 animated:YES];
    newAnnotations = annotations;
    //NSLog(@"annotation count:%@",annotations);
    return annotations;
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
    
   // NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  //  [dateFormatter setTimeZone:gmt];
    // [dateFormatter setDateFormat:@"MM'-'dd'-'yyyy  HH':'mm'"];
    
    [dateFormatter setDateFormat:@"'@'hh:mm:a 'on' EE MMM','dd'th'"];
    // NSLog(@"%@",self.birthdate);
    
    //  dateStr = [NSDateFormatter localizedStringFromDate:self.birthdate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle];;
    [_dateTextField setText:[dateFormatter stringFromDate:self.birthdate]];
    _dateTextField.textAlignment=NSTextAlignmentCenter;
    [self dismissViewAnimation];
    [_dateTextField resignFirstResponder];
    
    
    //dateStr=(NSString *)self.birthdate;
    
    //NSString *str=(NSString *)self.birthdate;
    
    //NSLog(@"string :%@",str);
    
   [dateFormatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    
    dateStr=[dateFormatter stringFromDate:self.birthdate];
//    dateStr = [foo objectAtIndex: 0];
    
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

- (IBAction)letsMeetAction:(id)sender {
    
    
     msgStr=_msgTextView.text;
    if([_msgTextView.text isEqualToString:@" Add a message.."])
    {
       msgStr=@"";
    }
   
    if([_dateTextField.text length]==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SetMeUp" message:@"Please select date and time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag=100;
        [alert show];

        
    }else{
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    NSString *fbAccessToken=[shRes getFbAccessToken];
    //NSLog(@"fbaccessToken:%@ and fbuserid:%@",[shRes getFbAccessToken],[shRes getFbLoggedInUserId]);
    NSString *fbUserId=[shRes getFbLoggedInUserId];
    
    NSString *letsmeetFlag = @"yes";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:letsmeetFlag forKey:@"letsmeetflag"];
    
//    [SMUWebServices confirmDateWithAccessToken:fbAccessToken forUserId:fbUserId withPlaceId:[_selectedDic objectForKey:@"placeId"] withDate:dateStr comment:_msgTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"confirmDate result:%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
        
        
        [SMUWebServices confirmDateWithAccessToken:fbAccessToken forUserId:fbUserId withSelectedUserId:[_selectedDic objectForKey:@"userId"] withPlaceId:[_selectedDic objectForKey:@"placeId"] withDate:dateStr  withType:[_selectedDic objectForKey:@"type"] comment:msgStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"confirmDate result:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [self dismissViewAnimation];
    [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger alertTag=alertView.tag;
    if (alertTag==100) {
        
        [_dateTextField becomeFirstResponder];
        
    }
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
