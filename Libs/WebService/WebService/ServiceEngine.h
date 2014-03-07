//
//  ServiceEngine.h
//  MMServiceLayer
//
//  Created by ArulRaj on 12/13/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ServiceEngine : NSObject

+ (void)getResultsForFunctionName:(NSString *)funName
                  postStringValue:(NSString *)postString
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
