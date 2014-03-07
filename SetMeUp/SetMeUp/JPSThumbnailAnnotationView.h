//
//  JPSThumbnailAnnotationView.h
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JPSThumbnail.h"
@protocol JPSThumbnailAnnotationViewProtocol;
typedef enum {
    JPSThumbnailAnnotationViewAnimationDirectionGrow,
    JPSThumbnailAnnotationViewAnimationDirectionShrink,
} JPSThumbnailAnnotationViewAnimationDirection;

typedef enum {
    JPSThumbnailAnnotationViewStateCollapsed,
    JPSThumbnailAnnotationViewStateExpanded,
    JPSThumbnailAnnotationViewStateAnimating,
} JPSThumbnailAnnotationViewState;

@protocol JPSThumbnailAnnotationViewProtocol <NSObject>

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;


@end

@interface JPSThumbnailAnnotationView : MKAnnotationView <JPSThumbnailAnnotationViewProtocol> {
    CAShapeLayer *_shapeLayer;
    CAShapeLayer *_strokeAndShadowLayer;
    UIButton *_disclosureButton;
    JPSThumbnailAnnotationViewState _state;
}
@property (nonatomic,weak ) id<JPSThumbnailAnnotationViewProtocol> delegate;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) ActionBlock disclosureBlock;
@property (nonatomic,strong) UIImageView *placeImg;
@property (nonatomic,strong) UIImageView *profileImg;

@property (nonatomic,strong) UILabel *cntLabel;
@property (nonatomic,strong) UIImageView *pinImage;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;

@end
