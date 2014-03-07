//
//  SMUFeedBackViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/28/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUSharedResources.h"
@interface SMUFeedBackViewController : UIViewController
{
        NSString *fbAccessToken,*userId;
}
@property (weak, nonatomic) IBOutlet UITextField *typeText;
@property (weak, nonatomic) IBOutlet UITextView *messageText;


- (IBAction)backButtonClick:(id)sender;




- (IBAction)clearButtonClick:(id)sender;

- (IBAction)sumbitButtonClick:(id)sender;

@end
