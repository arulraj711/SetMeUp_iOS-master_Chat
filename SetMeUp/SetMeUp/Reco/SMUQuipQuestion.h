//
//  SMUQuipQuestion.h
//  SetMeUp
//
//  Created by In on 26/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUQuipQuestion : NSObject
@property (nonatomic, strong) NSString *question_id,*question_text;
@property (nonatomic, readwrite) BOOL isSelected;
- (void)setDictionary:(NSDictionary *)dictionary;
@end
