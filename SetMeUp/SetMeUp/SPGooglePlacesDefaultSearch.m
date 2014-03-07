//
//  SPGooglePlacesDefaultSearch.m
//  SPGooglePlacesAutocomplete
//
//  Created by ArulRaj on 2/18/14.
//  Copyright (c) 2014 Stephen Poletto. All rights reserved.
//

#import "SPGooglePlacesDefaultSearch.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface SPGooglePlacesDefaultSearch()
@property (nonatomic, copy, readwrite) SPGooglePlacesAutocompleteResultBlock resultBlock;
@end

@implementation SPGooglePlacesDefaultSearch
@synthesize input, sensor, key, offset, location, radius, language, types, resultBlock;

+ (SPGooglePlacesDefaultSearch *)query {
    return [[self alloc] init];
}

- (id)init {
    //  NSLog(@"googleplace one");
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.key = kGoogleAPIKey;
        self.offset = NSNotFound;
        self.location = CLLocationCoordinate2DMake(-1, -1);
        self.radius = NSNotFound;
        self.types = -1;
    }
    return self;
}

- (NSString *)description {
    // NSLog(@"googleplace two");
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}

//- (void)dealloc {
//    [googleConnection release];
//    [responseData release];
//    [input release];
//    [key release];
//    [language release];
//    [super dealloc];
//}

- (NSString *)googleURLString {
    // NSLog(@"googleplace three");
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&sensor=%@&key=%@",
                            location.latitude,location.longitude,
                            SPBooleanStringForBool(sensor), key];
    
   // NSLog(@"default url string:%@",url);
    
    if (offset != NSNotFound) {
        [url appendFormat:@"&offset=%u", offset];
    }
    if (location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", location.latitude, location.longitude];
    }
    if (radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", radius];
    }
    if (language) {
        [url appendFormat:@"&language=%@", language];
    }
    if (types != -1) {
        [url appendFormat:@"&types=%@", SPPlaceTypeStringForPlaceType(types)];
    }
    return url;
}

- (void)cleanup {
    // [googleConnection release];
    // [responseData release];
    googleConnection = nil;
    responseData = nil;
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests {
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchPlaces:(SPGooglePlacesAutocompleteResultBlock)block {
    //NSLog(@"come fetchplaces");
    if (!SPEnsureGoogleAPIKey()) {
        //NSLog(@"one");
        return;
    }
    
    //    if (SPIsEmptyString(self.input)) {
    //        NSLog(@"two");
    //        // Empty input string. Don't even bother hitting Google.
    //        block([NSArray array], nil);
    //        return;
    //    }
    //NSLog(@"after that");
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    googleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
    //NSLog(@"one");
    //NSString *str = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error {
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    for (NSDictionary *place in places) {
        [parsedPlaces addObject:[SPGooglePlacesAutocompletePlace placeFromDictionary:place]];
    }
    if (self.resultBlock != nil) {
        self.resultBlock(parsedPlaces, nil);
    }
    [self cleanup];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == googleConnection) {
        //  NSLog(@"two");
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data {
    if (connnection == googleConnection) {
        // NSLog(@"three");
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == googleConnection) {
        //NSLog(@"four");
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == googleConnection) {
        //NSLog(@"five");
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        //NSLog(@"default response:%@",response);
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:[NSArray array]];
            return;
        }
        //        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
        //            [self succeedWithPlaces:[response objectForKey:@"predictions"]];
        //            return;
        //        }
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            NSString *fcTutorialStatus = @"defaultSearch";
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:fcTutorialStatus forKey:@"functionName"];
            [self succeedWithPlaces:[response objectForKey:@"results"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
        
        [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}
@end
