//
//  SMUFeedBackViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/28/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUFeedBackViewController.h"
#import "SMUWebServices.h"
@interface SMUFeedBackViewController ()<UIAlertViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSString * messageFromSettingPage;
@end

@implementation SMUFeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setBorderColorforTextfield];
}
-(void)setBorderColorforTextfield{
    
    _messageText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _messageText.layer.borderWidth=1.0f;
    _messageText.text=@"Leave a feedback..";
     _messageText.textColor = [UIColor lightGrayColor];
    
    _typeText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _typeText.layer.borderWidth=1.0f;
    
    UIColor *color = [UIColor lightTextColor];

        _typeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Subject" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clearButtonClick:(id)sender {
    _typeText.text=@"";
    _messageText.textColor = [UIColor lightGrayColor];
    _messageText.text = @"Leave a feedback..";
    
    [self dismissViewAnimation];
    [_messageText resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_typeText resignFirstResponder];
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    [[UITextView appearance] setTintColor:[UIColor blackColor]];
    if([_messageText.text isEqualToString:@"Leave a feedback.."]){
        _messageText.text = @"";
    }
    _messageText.textColor = [UIColor whiteColor];
    
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = -210;
    [self.view setFrame:frame];
    [UIView commitAnimations];

    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        if([_messageText.text isEqualToString:@""])
            
        {    _messageText.textColor = [UIColor lightGrayColor];
            _messageText.text=@"Leave a feedback..";
        }
        [self dismissViewAnimation];
        [_messageText resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    //NSLog(@"coming into textviewdidchange");
    if(_messageText.text.length == 0){
        _messageText.textColor = [UIColor lightGrayColor];
        _messageText.text = @"Leave a feedback..";
         [self dismissViewAnimation];
        [_messageText resignFirstResponder];
    }
}

-(void)dismissViewAnimation{
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (IBAction)sumbitButtonClick:(id)sender {
    
    if(![_messageText.text isEqualToString:@""]&&![_messageText.text isEqualToString:@"Leave a feedback.."]){
        
         [self dismissViewControllerAnimated:YES completion:nil];
        fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
        userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
        [SMUWebServices sendFeedbackWithAccessToken:fbAccessToken forUserId:userId withFeedbackSubject:_typeText.text feedbackMessage:_messageText.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"SetMeUp" message:@"Please give your feedback" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag=100;
        [alert show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag=[alertView tag];
    if (tag==100&&buttonIndex==0) {
        
        
        [_messageText becomeFirstResponder];
    }
}
@end
