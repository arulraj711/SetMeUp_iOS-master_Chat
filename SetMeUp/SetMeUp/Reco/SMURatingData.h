//
//  SMURatingData.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMURatingData : NSObject
@property (nonatomic,strong) NSString *ratingId;
@property (nonatomic,strong) NSString *ratingText;
@property (nonatomic,readwrite) float rating;
@property (nonatomic,readwrite) BOOL isRatingsUpdated;
-(void)setRatingDataWithDict:(NSDictionary *)dictionary;
@end
