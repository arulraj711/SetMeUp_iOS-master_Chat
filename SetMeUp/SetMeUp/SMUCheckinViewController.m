//
//  SMUCheckinViewController.m
//  SetMeUp
//
//  Created by ArulRaj on 2/12/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCheckinViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SMUCheckinDetailsPage.h"
#import "SPGooglePlacesDefaultSearch.h"
#import <QuartzCore/QuartzCore.h>
@interface SMUCheckinViewController ()

@end

@implementation SMUCheckinViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
       
    }
    return self;
}
//-(void)viewWillLayoutSubviews{
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.view.clipsToBounds = YES;
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        CGFloat screenHeight = screenRect.size.height;
//        self.view.frame =  CGRectMake(0, 20, self.view.frame.size.width,screenHeight-20);
//        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//}
- (void)viewDidLoad {
    // NSLog(@"first thing");
    
    
    NSString *letsmeetFlag = @"no";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:letsmeetFlag forKey:@"checkinflag"];
    self.title = @"SEARCH PLACES";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100.0;
    shouldBeginEditing = YES;
    defaultSearchQry = [[SPGooglePlacesDefaultSearch alloc]init];
    self.searchDisplayController.searchBar.placeholder = @"Search or Address";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    [self showDefaultPlaces];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setPlaceTable:nil];
    [super viewDidUnload];
}

//- (void)dealloc {
//    [selectedPlaceAnnotation release];
//    [mapView release];
//    [searchQuery release];
//    [super dealloc];
//}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)showDefaultPlaces {
    defaultSearchQry.location = self.locationManager.location.coordinate;
    //NSLog(@"self lattitude:%f",self.locationManager.location.coordinate.latitude);
    //NSLog(@"handle search location:%f and longitude:%f",searchQuery.location.latitude,searchQuery.location.longitude);
    // searchQuery.input = searchString;
    [defaultSearchQry fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
            [self.locationManager stopUpdatingLocation];
            // [searchResultPlaces release];
           // NSLog(@"place array:%@",places);
           // [searchResultPlaces removeAllObjects];
            searchResultPlaces = [[NSMutableArray alloc]initWithArray:places];
            //  searchResultPlaces = places;
            [self.placeTable reloadData];
        }
    }];
}

- (IBAction)recenterMapToUserLocation:(id)sender {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = self.mapView.userLocation.coordinate;
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"row count:%d",[searchResultPlaces count]);
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
  //  NSLog(@"search results cellfor before:%@",searchResultPlaces);
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    SPGooglePlacesAutocompletePlace *obj = [searchResultPlaces objectAtIndex:indexPath.row];
    //NSLog(@"name order:%@",obj.name);
    correctDetailsArray = [[NSMutableArray alloc]initWithArray:searchResultPlaces];
    cell.textLabel.text = obj.name;
   // NSLog(@"search results cellfor after:%@",searchResultPlaces);
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = placemark.location.coordinate;
    
    [self.mapView setRegion:region];
}

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address {
    [self.mapView removeAnnotation:selectedPlaceAnnotation];
    //[selectedPlaceAnnotation release];
    
    selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    selectedPlaceAnnotation.title = address;
    [self.mapView addAnnotation:selectedPlaceAnnotation];
}

- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    

    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
//    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
//        if (error) {
//            SPPresentAlertViewWithErrorAndTitle(error, @"Could not map selected Place");
//        } else if (placemark) {
            //[self addPlacemarkAnnotationToMap:placemark addressString:addressString];
            //[self recenterMapToPlacemark:placemark];
            NSDictionary *dic = [correctDetailsArray objectAtIndex:indexPath.row];
            //NSLog(@"selected dic:%@",dic);
          //  [self dismissSearchControllerWhileStayingActive];
           // [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
            SMUCheckinDetailsPage *letsMeetPage=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUCheckinDetailsPage"];
            letsMeetPage.selectedDic = dic;
            //[[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.navigationController pushViewController:letsMeetPage animated:YES];
//        }
//    }];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    searchQuery.location = self.mapView.userLocation.coordinate;
    //NSLog(@"handle search location:%f",searchQuery.location.latitude);
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
        } else {
           // NSLog(@"place array:%@",places);
          //  [searchResultPlaces removeAllObjects];
           // NSLog(@"search place array count:%d",[places count]);
            //[searchResultPlaces removeAllObjects];
            searchResultPlaces =[[NSMutableArray alloc]initWithArray:places];
           // NSLog(@"search results array count:%d",[searchResultPlaces count]);
           // [searchResultPlaces release];
            //searchResultPlaces = [places retain];
           // [self.placeTable reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
        [self.mapView removeAnnotation:selectedPlaceAnnotation];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
   // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    searchBar.tintColor=[UIColor blackColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.1;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 1.0;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self showDefaultPlaces];
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
        // [[UIApplication sharedApplication] setStatusBarHidden:NO];
    return YES;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
}
#pragma mark -
#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapViewIn viewForAnnotation:(id <MKAnnotation>)annotation {
    if (mapViewIn != self.mapView || [annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *annotationIdentifier = @"SPGooglePlacesAutocompleteAnnotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    }
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [detailButton addTarget:self action:@selector(annotationDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = detailButton;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // Whenever we've dropped a pin on the map, immediately select it to present its callout bubble.
    [self.mapView selectAnnotation:selectedPlaceAnnotation animated:YES];
}

- (void)annotationDetailButtonPressed:(id)sender {
    // Detail view controller application logic here.
}


@end
