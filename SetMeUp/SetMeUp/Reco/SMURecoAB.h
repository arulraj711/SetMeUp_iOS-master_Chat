//
//  SMUSingleReco.h
//  RecoWebService
//
//  Created by ArulRaj on 12/31/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMURecoUserA;
@class SMUPhraseQuestion;
@interface SMURecoAB : NSObject

//@property (nonatomic,strong) NSString *firstname;
//@property (nonatomic,strong) NSString *userId;
//@property (nonatomic,strong) NSString *lastname;
//@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) SMURecoUserA *userA;
@property (nonatomic,strong) NSMutableArray *cUserArray;
@property (nonatomic,strong) SMUPhraseQuestion *phraseQuestion;
@property (nonatomic,strong) NSMutableArray *quipDataArray;
@property (nonatomic,strong) NSMutableArray *ratingDataArray;
@property (nonatomic,strong) NSMutableArray *allAUserArray;

-(void)setSingleRecoDetailsWithDict:(NSDictionary *)dictionary;

@end
