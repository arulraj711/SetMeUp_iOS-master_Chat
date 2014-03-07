//
//  SMUCheckinDetailsPage.h
//  SetMeUp
//
//  Created by ArulRaj on 2/12/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GHWalkThroughView.h"

@class SPGooglePlacesPlaceDetailQuery;
@interface SMUCheckinDetailsPage : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,GHWalkThroughViewDataSource> {
    SPGooglePlacesPlaceDetailQuery *placeDetailQuery;
}
@property (strong, nonatomic) IBOutlet UIImageView *checkBoxImage;
- (IBAction)sliderChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *milesLabel;
- (IBAction)checkinBtn:(id)sender;
@property (nonatomic,strong) NSMutableArray *selectedUserArray,*selectedName;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong)NSMutableArray *userDetails;
@property (strong, nonatomic) IBOutlet UITableView *connectedUserTable;
@property (strong, nonatomic) IBOutlet UISlider *milesRadius;
@property (strong, nonatomic) IBOutlet UILabel *streetName;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UIImageView *placeImage;
@property(nonatomic,strong) NSDictionary *selectedDic;
@property(nonatomic,strong) NSDictionary *selectedPlaceDic;
@property (nonatomic,strong) NSString *placeUrlStr;
@property (nonatomic,strong) NSDictionary *photoDic;
@property (nonatomic,strong) GHWalkThroughView *ghView;
@property (nonatomic,strong) NSArray *photoArray;

@end
