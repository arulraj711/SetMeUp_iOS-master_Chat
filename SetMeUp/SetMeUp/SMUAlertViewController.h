//
//  SMUAlertViewController.h
//  SetMeUp
//
//  Created by Go on 29/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface SMUAlertViewController : UIViewController

@property(nonatomic,readonly)BOOL isVisible;

+(SMUAlertViewController*)sharedInstance;
-(void)setUpAlertWithTitle:(NSString*)title withSubTile:(NSString*)subTitle withOperation:(AFHTTPRequestOperation*)failedOperation;
-(BOOL)presentModelInRootViewController;
@end
