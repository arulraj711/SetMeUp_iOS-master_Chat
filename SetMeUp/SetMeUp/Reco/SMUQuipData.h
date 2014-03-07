//
//  SMUQuipData.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUQuipData : NSObject
@property (nonatomic,strong) NSString *categoryId;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *quipId;
@property (nonatomic, strong) NSMutableArray *questions ;
@property (nonatomic,strong) NSString *question_id_1;
@property (nonatomic,strong) NSString *question_id_2;
@property (nonatomic,strong) NSString *question_text_1;
@property (nonatomic,strong) NSString *question_text_2;

-(void)setQuipDataWithDict:(NSDictionary *)dictionary;
@end
