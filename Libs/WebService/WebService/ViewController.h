//
//  ViewController.h
//  WebService
//
//  Created by ArulRaj on 12/16/13.
//  Copyright (c) 2013 CapeStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) NSDictionary *matchMakers;
@property (nonatomic,strong) NSDictionary *userC;
@property (nonatomic,strong) NSDictionary *initializeResult;
@property (nonatomic, strong) NSMutableArray *responseArray;
-(IBAction)matchMakerResponse:(id)sender;
-(IBAction)userCResponse:(id)sender;
-(IBAction)loginResponse:(id)sender;
-(IBAction)result:(id)sender;
@end
