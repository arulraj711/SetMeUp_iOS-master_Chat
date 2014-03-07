//
//  SMUCustomAnnotation.m
//  SetMeUp
//
//  Created by ArulRaj on 1/23/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUCustomAnnotation.h"

@implementation SMUCustomAnnotation
-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location {
    self = [super init];
    if(self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

//-(MKAnnotationView *)annotationView {
//    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"SMUCustomAnnotation"];
//    annotationView.enabled = YES;
//    annotationView.canShowCallout = YES;
//    annotationView.image = [UIImage imageNamed:@""];
//    return annotationView;
//}
@end
