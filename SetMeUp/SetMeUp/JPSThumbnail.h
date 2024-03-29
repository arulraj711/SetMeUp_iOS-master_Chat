//
//  JPSThumbnail.h
//  JPSThumbnailAnnotation
//
//  Created by Jean-Pierre Simard on 4/22/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^ActionBlock)();

@interface JPSThumbnail : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) ActionBlock disclosureBlock;
@property (nonatomic,strong) NSString *placeImage;
@property (nonatomic,strong) NSString *profileImage;
@property (nonatomic,strong)NSString *cntLabel;

@end
