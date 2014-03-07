//
//  SMUBroadCastViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/8/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SMUBroadCastViewController : UIViewController<CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UISlider *sliderForMiles;
@property(nonatomic,strong)NSMutableArray *userDetails;
@property (nonatomic,strong) NSMutableArray *selectedUserArray;
- (IBAction)slideValueChanged:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *mileLabel;
- (IBAction)broadcastPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *connectedUsertbl;


@end
