//
//  ServiceEngine.m
//  MMServiceLayer
//
//  Created by ArulRaj on 12/13/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import "ServiceEngine.h"

@implementation ServiceEngine

+(void)getResultsForFunctionName:(NSString *)funName postStringValue:(NSString *)postString success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSString *postURL = [NSString stringWithFormat:@"http://connectme.capestart.com/SMURC/restapis/%@/",funName];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:postURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"100000295066984" forHTTPHeaderField:@"id"];
    [req setValue:@"CAAG2W8yoB9ABAD45Y7HSjBZCaAeWiJy4jIrN1rFqwnE8u7A0LZAEfg6WPBD1m98I5WOEybDfqssclsLM4WTKNyeumKUI9uwNEYCsvhvFQa5uuZB9PZBTLfOZC6g9nTFkK4korLCfj4TWHAM2CWo2FYFdJJcTsuXeZAE2ZBZCOMV8Y8xZB0vpOWVrQXavo5FJqS3IZD" forHTTPHeaderField:@"extendedAccessToken"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         success(operation, JSON);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if(error.code != -999)
             failure(operation, error);
     }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}
@end
