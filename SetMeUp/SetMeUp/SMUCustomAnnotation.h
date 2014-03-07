//
//  SMUCustomAnnotation.h
//  SetMeUp
//
//  Created by ArulRaj on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface SMUCustomAnnotation : NSObject<MKAnnotation>
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (copy,nonatomic) NSString *title;
@property (nonatomic,strong) NSString *placeImageUrl;
@property (nonatomic,strong) NSString *placeName;


-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
//-(MKAnnotationView *)annotationView;
@end
