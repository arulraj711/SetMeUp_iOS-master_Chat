//
//  SMUUpdateUserLocation.h
//  SetMeUp
//
//  Created by ArulRaj on 2/9/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SMUUpdateUserLocation : NSObject<CLLocationManagerDelegate> {
    BOOL isDismissInPregress;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *presentedViewControllers;
+ (SMUUpdateUserLocation *)updateLocation;
@end
