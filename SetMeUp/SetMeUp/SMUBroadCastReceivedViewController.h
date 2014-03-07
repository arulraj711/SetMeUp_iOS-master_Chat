//
//  SMUBroadCastReceivedViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/10/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMUBroadCastReceivedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
- (IBAction)closeButtonPressed:(id)sender;

- (IBAction)startChatting:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *startChattingPressed;

@end
