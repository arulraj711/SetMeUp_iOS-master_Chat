//
//  SMUBCRecoQuipData.h
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUBCRecoQuipData : NSObject

@property (nonatomic,strong) NSString *categoryId;
@property (nonatomic,strong) NSString *quipId;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *answer;
@property(nonatomic,strong)NSMutableArray *questionArray;
-(void)setQuipDataDetailsWithDict:(NSDictionary *)dictionary;

@end
