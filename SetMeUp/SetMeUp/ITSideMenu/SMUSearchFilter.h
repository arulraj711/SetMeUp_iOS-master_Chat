//
//  SMUSearchFilter.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/4/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUSearchFilter : NSObject

@property(nonatomic,strong) NSString *value;
@property(nonatomic,strong) NSString *label;
- (void)setvalueforAutofilldataWithDict:(NSDictionary *)dictionary;

@end
