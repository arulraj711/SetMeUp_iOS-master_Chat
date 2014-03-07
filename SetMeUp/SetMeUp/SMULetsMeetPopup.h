//
//  SMULetsMeetPopup.h
//  SetMeUp
//
//  Created by ArulRaj on 1/27/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SMULetsMeetPopup : UIViewController<UITextFieldDelegate,UITextViewDelegate,MKMapViewDelegate,UIActionSheetDelegate> {
    NSMutableArray *annotations,*newAnnotations;
    UIActionSheet *actionsheet;
    NSString *dateStr,*msgStr;
}
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UILabel *streetName;
@property (strong, nonatomic) IBOutlet UIImageView *placeImage;
@property (strong, nonatomic) IBOutlet UILabel *lastCheckinDate;
@property (strong, nonatomic) IBOutlet UILabel *checkinCount;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextView *msgTextView;
@property (nonatomic,strong) NSDictionary *selectedDic;
- (IBAction)letsMeetAction:(id)sender;
@property (weak, nonatomic) NSDate *birthdate;
@end
