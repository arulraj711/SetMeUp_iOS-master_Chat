//
//  SMULetsMeet.m
//  SetMeUp
//
//  Created by ArulRaj on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMULetsMeet.h"
#import "SMUDateDetails.h"
#import "SMUPlaceDetails.h"

@implementation SMULetsMeet
-(void)setLetsMeetWithDict:(NSDictionary *)dictionary {
 
    NSMutableArray *calArray =[NSMutableArray array];
    NSDictionary *dic = [dictionary objectForKey:@"CalendarDate"];
    SMUDateDetails *date = [[SMUDateDetails alloc]init];
    [date setDateDetailsWithDict:dic];
    [calArray addObject:date];
    _calendarDateArray = [NSArray arrayWithArray:calArray];
   
    
    
    NSMutableArray *placeArray =[NSMutableArray array];
    NSDictionary *placeDic = [dictionary objectForKey:@"PlaceDetails"];
    SMUPlaceDetails *place = [[SMUPlaceDetails alloc]init];
    [place setPlaceDetailsWithDict:placeDic];
    [placeArray addObject:place];
    _placeDetailsArray = [NSArray arrayWithArray:placeArray];
//    _placeDetailsArray=[NSMutableArray array];
//    NSArray *placeArray = [dictionary objectForKey:@"PlaceDetails"];
//    if([placeArray isKindOfClass:[NSArray class]])
//    {
//        for (NSDictionary *dic in placeArray) {
//            SMUPlaceDetails *place = [[SMUPlaceDetails alloc]init];
//            [place setPlaceDetailsWithDict:dic];
//            [_placeDetailsArray addObject:place];
//        }
//    }
}
@end
