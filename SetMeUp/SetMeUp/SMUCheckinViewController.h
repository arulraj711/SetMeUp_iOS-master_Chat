//
//  SMUCheckinViewController.h
//  SetMeUp
//
//  Created by ArulRaj on 2/12/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;
@class SPGooglePlacesDefaultSearch;
@interface SMUCheckinViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate,CLLocationManagerDelegate> {
    NSArray *searchResultPlaces,*correctDetailsArray;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    SPGooglePlacesDefaultSearch *defaultSearchQry;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}
@property (strong, nonatomic) IBOutlet UITableView *placeTable;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign) float lattitude;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end
