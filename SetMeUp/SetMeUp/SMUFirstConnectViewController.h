//
//  SMUFirstConnectViewController.h
//  SetMeUp
//
//  Created by ArulRaj on 1/20/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GHWalkThroughView.h"

@interface SMUFirstConnectViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate,GHWalkThroughViewDataSource> {
    int dragCnt;
    //UISearchBar *searchBar;
    //UISearchDisplayController *searchDisplayController;
    NSMutableArray *annotations,*newAnnotations;
    NSString *fbAccessToken,*fbUserId;
    int checkinButtonFlag,flag,leftmenuFlag;
}

- (IBAction)checkinsBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *letsMeetLbl;

- (IBAction)segmentChanged:(id)sender;
- (IBAction)letsMeetBtn:(id)sender;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)IBOutlet UITableView *checkinTable;
@property (strong, nonatomic) IBOutlet UILabel *infolabel;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segmentCtrl;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSMutableArray *recentCheckinArray;
@property (nonatomic,strong) NSMutableArray *mostCheckinArray;
@property (nonatomic,strong) NSMutableArray *filteredArray;
@property (nonatomic, readwrite) NSInteger selectedIndex;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (nonatomic,strong) NSString *selectedUserId;
@property (nonatomic,strong) NSString *selectedUserUrl;
@property (nonatomic,strong) NSString *selectedUserName;
@property (nonatomic,strong) NSString *selectedPlaceId;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (nonatomic, strong) GHWalkThroughView* ghView;
@property (nonatomic,strong) NSString *selectedName;
@property (nonatomic,strong) NSMutableArray *chatListArray;
@property (weak, nonatomic) IBOutlet UIButton *dragButton;

- (IBAction)showLeftMenuPressed:(id)sender;
- (IBAction)showRightMenuPressed:(id)sender;
- (IBAction)dragMethod:(id)sender;
- (IBAction)broadcastButtonPressed:(id)sender;


@end
