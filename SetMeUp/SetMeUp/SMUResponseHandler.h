//
//  SMUResponseHandler.h
//  SetMeUp
//
//  Created by In on 21/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUResponseHandler : NSObject
+ (void)parseMatchMakersResponse:(id)responseObject
                       onSuccess:(void (^)( id object))success;

@end
