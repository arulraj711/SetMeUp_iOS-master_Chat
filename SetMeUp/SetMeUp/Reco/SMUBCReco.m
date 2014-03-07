//
//  SMUBCReco.m
//  RecoWebService
//
//  Created by Piramanayagam on 1/20/14.
//  Copyright (c) 2014 CapeStart. All rights reserved.
//

#import "SMUBCReco.h"
#import "SMUBCRecoUserA.h"
#import "SMUBCRecoUserB.h"
#import "SMURecoUserB.h"
#import "SMUBCRecoQuipData.h"
#import "SMUBCRecoRatings.h"
#import "SMUBCRecoQuestions.h"
@implementation SMUBCReco


-(void)setBCRecoDetailsWithDict:(NSDictionary *)dictionary{
    
    self.userB = [[SMURecoUserB alloc] init];
    [self.userB setUserBDetailsWithDict:[dictionary objectForKey:@"b_user"]];
    self.userB.userAs = [NSMutableArray array];
    
    
    NSArray *recoAs = [dictionary objectForKey:@"a_user"];
    for (NSDictionary *recoA in recoAs) {
        SMUBCRecoUserA *user_a = [[SMUBCRecoUserA alloc]init];
        [user_a setUserADetailWithDict:recoA];
        [self.userB.userAs addObject:user_a];
    }

    

}
+(NSMutableArray *)mock
{
    NSMutableArray *recos = [NSMutableArray array];
    
    for (int recoIndex = 0; recoIndex < 3; recoIndex++) {
        SMUBCReco *recoBC = [[SMUBCReco alloc] init];
        recoBC.userB = [[SMURecoUserB alloc] init];
        recoBC.userB.name = @"Arumugam Sri";
        recoBC.userB.imageUrl = @"http://s3.amazonaws.com/setmeup/pics/profiles/100001513177021_c.jpg";
        
        recoBC.userB.userAs = [NSMutableArray array];
        
        for (int index = 0; index < 3 + recoIndex; index++) {
            SMUBCRecoUserA *user_a = [[SMUBCRecoUserA alloc]init];
            user_a.name = @"Piramanayagam Km";
            user_a.img_url = @"http://s3.amazonaws.com/setmeup/pics/profiles/100000317004576_c.jpg";
            
            //  Quips
            user_a.quipArray = [NSMutableArray array];
            //  1
            SMUBCRecoQuipData *quipData = [[SMUBCRecoQuipData alloc]init];
            quipData.answer = @"0";
            SMUBCRecoQuestions *bcRecoQuestion1 = [[SMUBCRecoQuestions alloc]init];
            bcRecoQuestion1.questionId = @"17";
            bcRecoQuestion1.questionText = @"Slides Into First";
            SMUBCRecoQuestions *bcRecoQuestion2 = [[SMUBCRecoQuestions alloc]init];
            bcRecoQuestion2.questionId = @"18";
            bcRecoQuestion2.questionText = @"Bases Loaded";
            quipData.questionArray = [NSMutableArray array];
            [quipData.questionArray addObject:bcRecoQuestion1];
            [quipData.questionArray addObject:bcRecoQuestion2];
            [user_a.quipArray addObject:quipData];
            //  2
            quipData = [[SMUBCRecoQuipData alloc]init];
            quipData.answer = @"17";
            bcRecoQuestion1 = [[SMUBCRecoQuestions alloc]init];
            bcRecoQuestion1.questionId = @"17";
            bcRecoQuestion1.questionText = @"Take Your Time";
            bcRecoQuestion2 = [[SMUBCRecoQuestions alloc]init];
            bcRecoQuestion2.questionId = @"18";
            bcRecoQuestion2.questionText = @"On The Dime?";
            quipData.questionArray = [NSMutableArray array];
            [quipData.questionArray addObject:bcRecoQuestion1];
            [quipData.questionArray addObject:bcRecoQuestion2];
            [user_a.quipArray addObject:quipData];
            //  3
            quipData = [[SMUBCRecoQuipData alloc]init];
            quipData.answer = @"18";
            bcRecoQuestion1 = [[SMUBCRecoQuestions alloc]init];
            bcRecoQuestion1.questionId = @"17";
            bcRecoQuestion1.questionText = @"Driving Miss Daisy?";
            bcRecoQuestion2 = [[SMUBCRecoQuestions alloc]init];
            bcRecoQuestion2.questionId = @"18";
            bcRecoQuestion2.questionText = @"Daytona 500?";
            quipData.questionArray = [NSMutableArray array];
            [quipData.questionArray addObject:bcRecoQuestion1];
            [quipData.questionArray addObject:bcRecoQuestion2];
            [user_a.quipArray addObject:quipData];
            
            //  Ratings
            user_a.ratingArray = [NSMutableArray array];
            //  1
            SMUBCRecoRatings *rating = [[SMUBCRecoRatings alloc] init];
            rating.category_name = @"General";
            rating.question_text = @"Charisma";
            rating.answer = @"0";
            [user_a.ratingArray addObject:rating];
            //  2
            rating = [[SMUBCRecoRatings alloc] init];
            rating.category_name = @"General";
            rating.question_text = @"Stubborness";
            rating.answer = @"3.0";
            [user_a.ratingArray addObject:rating];
            //  3
            rating = [[SMUBCRecoRatings alloc] init];
            rating.category_name = @"General";
            rating.question_text = @"Color Coordination";
            rating.answer = @"4.0";
            [user_a.ratingArray addObject:rating];
            
            [recoBC.userB.userAs addObject:user_a];
            
        }
        [recos addObject:recoBC];
    }
    return recos;
}

@end
