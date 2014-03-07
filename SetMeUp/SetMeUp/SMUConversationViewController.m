//
//  SMUConversationViewController.m
//  SetMeUp
//
//  Created by ArulRaj on 1/10/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUConversationViewController.h"
#import "ITSideMenu.h"
#import "SMUWebServices.h"
#import "SMUGetMessage.h"
#import "SMUMessage.h"
#import "SMUSharedResources.h"
#import "AFNetworking/UIImageView+AFNetworking.h"
#import "SMUConnectedUser.h"
#import "SPHChatData.h"
#import "SPHBubbleCellOther.h"
#import "SPHBubbleCell.h"
#import "AsyncImageView.h"
#import "MHFacebookImageViewer.h"
#import "SPHBubbleCellImage.h"
#import "SPHBubbleCellImageOther.h"
#define messageWidth 260
@interface SMUConversationViewController ()

@end

@implementation SMUConversationViewController

@synthesize pullToRefreshManager = pullToRefreshManager_;
@synthesize reloads = reloads_;
@synthesize Uploadedimage;
SPHChatData *feed_data;
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
    //    _bubbleData = [[NSMutableArray alloc]init];
    //
    //    _overlayView.hidden=YES;
    //    //self.navBar.tintColor = [UIColor blueColor];
    //    [self loadMessage];
    _overlayView.hidden=YES;
    sphBubbledata=[[NSMutableArray alloc]init];
    
    [self setUpTextFieldforIphone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    pullToRefreshManager_ = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                   tableView:self.sphChatTable
                                                                                  withClient:self];
    [self setUpDummyMessages];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(loadNewMessages) userInfo:nil repeats:YES];
    
}
//-(void)checkRecoStatus{
//    [self loadMessage];
//}
- (void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpDummyMessages
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    // NSString *rowNumber=[NSString stringWithFormat:@"%d",sphBubbledata.count];
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"selectedUser"];
    selectedUser = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    //
    NSData *data2 = [defaults objectForKey:@"selectedName"];
    selectedName = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    _currentPageNo = 0;
    NSArray *array = [selectedName componentsSeparatedByString:@" "];
    UIView *msgTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 45)];
    msgTitleView.backgroundColor = [UIColor clearColor];
    UIImageView *msgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 40, 40)];
    NSString *connectedUserUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",selectedUser];
    [msgImageView setImageWithURL:[NSURL URLWithString:connectedUserUrl]];
    msgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [SMUtils makeRoundedImageView:msgImageView withBorderColor:appOfflineUserUIColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
    nameLabel.text =[array objectAtIndex:0];
    nameLabel.textColor = [UIColor whiteColor];
    [msgTitleView addSubview:nameLabel];
    [msgTitleView addSubview:msgImageView];
    self.navItem.titleView = msgTitleView;
    
    [SMUWebServices homeMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"getMessages" fromUserId:selectedUser pageNo:_currentPageNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [SMUWebServices changeMessageStatusWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"changeReadStatus" user_id1:fbUserId user_id2:selectedUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
        _totalPageNo = [[responseObject objectForKey:@"total_page"] intValue];
        SMUGetMessage *msgObj = [[SMUGetMessage alloc]init];
        [msgObj setTotalMessageWithDict:responseObject];
        
        if([msgObj.messageArray count]==0){
            [self overLayView];
        }
        //SMUGetMessage *msgObj = (SMUGetMessage *)responseObject;
        for(int i=0;i<[msgObj.messageArray count];i++) {
            SMUMessage *msgModels = (SMUMessage *)[msgObj.messageArray objectAtIndex:i];
            if([msgModels.from_user_id isEqualToString:fbUserId]) {
                [self adddBubbledata:@"textByme" mtext:msgModels.message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sent"];
            } else {
                [self adddBubbledata:@"textbyother" mtext:msgModels.message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sent"];
            }
            
        }
        _totalPageNo--;
        _currentPageNo++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //                //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        //
    }];
    
    
    
    [self.sphChatTable reloadData];
}

-(void)overLayView{
    
    
    _overlayView.hidden=NO;
    
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"connectedDetails"];
    
    //NSLog(@"dict in overlay:%@",dict);
    // NSLog(@"busername:%@",[dict objectForKey:@"bUserId"]);
    
    NSString *buserName=[dict objectForKey:@"bUserName"];
    // NSString *buserId=[dict objectForKey:@"bUserId"];
    NSString *connectedDate=[dict objectForKey:@"connectedDate"];
    NSString *imgUrl=[dict objectForKey:@"bUserImageUrl"];
    
    
    [SMUtils makeRoundedImageView:_userCImageView withBorderColor:[UIColor clearColor]];
    [SMUtils makeRoundedImageView:_overlayUserBView withBorderColor:[UIColor clearColor]];
    
    if([buserName isEqualToString:@""]){
        
        _overlayUserBView.hidden=YES;
        _userBNameLabel.hidden=YES;
        _introLabel.text=[NSString stringWithFormat:@"Matched with %@",selectedName];
        
        
    }
    else{
        _overlayUserBView.hidden=NO;
        NSURL *url=[NSURL URLWithString:imgUrl];
        [_overlayUserBView setImageWithURL:url placeholderImage:nil];
        _overlayUserBView.contentMode=UIViewContentModeScaleAspectFill;
        NSString *lbl=[NSString stringWithFormat:@"Introduced by %@",buserName];
        _introLabel.text=lbl;
        _userBNameLabel.text=buserName;
        
    }
    
    _dataLabel.text=[NSString stringWithFormat:@"on %@",connectedDate];
    NSString *connectedUserUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",selectedUser];
    NSURL *url=[NSURL URLWithString:connectedUserUrl];
    [_userCImageView setImageWithURL:url placeholderImage:nil];
    _userCImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    
}


-(void)loadNewMessages {
    NSLog(@"Load new messages");
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    // NSString *rowNumber=[NSString stringWithFormat:@"%d",sphBubbledata.count];
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    fbAccessToken=[shRes getFbAccessToken];
    fbUserId=[shRes getFbLoggedInUserId];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"selectedUser"];
    selectedUser = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    //
    NSData *data2 = [defaults objectForKey:@"selectedName"];
    selectedName = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    //_currentPageNo = 0;
    [SMUWebServices homeMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"getMessages" fromUserId:selectedUser pageNo:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        //        //_totalPageNo = [[responseObject objectForKey:@"total_page"] intValue];
        SMUGetMessage *msgObj = [[SMUGetMessage alloc]init];
        [msgObj setTotalMessageWithDict:responseObject];
        //        //SMUGetMessage *msgObj = (SMUGetMessage *)responseObject;
        for(int i=0;i<[msgObj.messageArray count];i++) {
            SMUMessage *msgModels = (SMUMessage *)[msgObj.messageArray objectAtIndex:i];
            if([msgModels.status isEqualToString:@"New"]) {
                
                [SMUWebServices changeMessageStatusWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"changeReadStatus" user_id1:fbUserId user_id2:selectedUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
                
                if([msgModels.from_user_id isEqualToString:fbUserId]) {
                    
                    //                [self adddBubbledata:@"textByme" mtext:msgModels.message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sent"];
                    //                SPHChatData *feed_data = [sphBubbledata objectAtIndex:[sphBubbledata count]-1];
                    //                [sphBubbledata  removeObjectAtIndex:[sphBubbledata count]-1];
                    //                [sphBubbledata insertObject:feed_data atIndex:[sphBubbledata count]];
                    //                _msgCount++;
                }
                else {
                    
                    [self adddBubbledata:@"textbyother" mtext:msgModels.message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sent"];
                    SPHChatData *feed_data = [sphBubbledata objectAtIndex:[sphBubbledata count]-1];
                    [sphBubbledata  removeObjectAtIndex:[sphBubbledata count]-1];
                    [sphBubbledata insertObject:feed_data atIndex:[sphBubbledata count]];
                    _msgCount++;
                    [self.sphChatTable reloadData];
                    [self goToBottom];
                }
                
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        //                //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        //        //
    }];
    
    
    //for(int i=0;i<7;i++) {
    //int index = i+7*_currentPageNo;
    
    // }
    
    
}



#pragma mark MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshManager_ tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >=360.0f)
    {
    }
    else
        [pullToRefreshManager_ tableViewReleased];
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager
{
    reloads_++;
    [self performSelector:@selector(getEarlierMessages) withObject:nil afterDelay:0.0f];
}

-(void)getEarlierMessages
{
    NSLog(@"get Earlir Messages And Appand to Array");
    [self performSelector:@selector(loadfinished) withObject:nil afterDelay:1];
}

-(void)loadfinished
{
    //NSLog(@"remaining page no:%d",_totalPageNo);
    
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"selectedUser"];
    selectedUser = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    //
    NSData *data2 = [defaults objectForKey:@"selectedName"];
    selectedName = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    if(_totalPageNo > 0) {
        [SMUWebServices homeMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"getMessages" fromUserId:selectedUser pageNo:_currentPageNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //SMUGetMessage *msgObj = (SMUGetMessage *)responseObject;
            SMUGetMessage *msgObj = [[SMUGetMessage alloc]init];
            [msgObj setTotalMessageWithDict:responseObject];
            for(int i=0;i<[msgObj.messageArray count];i++) {
                SMUMessage *msgModels = (SMUMessage *)[msgObj.messageArray objectAtIndex:i];
                if([msgModels.from_user_id isEqualToString:fbUserId]) {
                    [self adddBubbledata:@"textByme" mtext:msgModels.message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sent"];
                } else {
                    [self adddBubbledata:@"textbyother" mtext:msgModels.message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sent"];
                }
                
            }
            //NSLog(@"total array count:%d",[sphBubbledata count]);
            for(int i=0;i<7;i++) {
                int index = (i+7*_currentPageNo)+_msgCount;
                //NSLog(@"index:%d",index);
                SPHChatData *feed_data = [sphBubbledata objectAtIndex:index];
                //NSLog(@"feed data object:%@ and %@",feed_data,feed_data.messageText);
                [sphBubbledata  removeObjectAtIndex:index];
                [sphBubbledata insertObject:feed_data atIndex:i];
            }
            _totalPageNo--;
            _currentPageNo++;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //                //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
            //
        }];
        [self.sphChatTable reloadData];
        //[_timer invalidate];
    }
}





-(IBAction)messageSent:(id)sender
{
    
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:[sender intValue]];
    feed_data.messagestatus=@"Sent";
    [sphBubbledata  removeObjectAtIndex:[sender intValue]];
    [sphBubbledata insertObject:feed_data atIndex:[sender intValue]];
    [self.sphChatTable reloadData];
    
    if([sphBubbledata count] > 1) {
        [self createJsonForSendReplyMessage:msgTextField.text fromUserId:fbUserId toUserId:selectedUser];
        //       // [self createJsonForSendNewMessage:_textField.text toUserId:selectedUser];
        [SMUWebServices sendReplyWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"sendReply" messageString:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
            //
        }];
    } else {
        [self createJsonForSendNewMessage:msgTextField.text toUserId:selectedUser];
        //       // [self createJsonForSendReplyMessage:_textField.text fromUserId:fbUserId toUserId:selectedUser];
        [SMUWebServices sendNewMessageWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"sendNewMessage" messageString:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
            //
        }];
    }
    
    msgTextField.text = @"";
    
}

-(void)setUpTextFieldforIphone
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-40, 320, 40)];
    //    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 3, 206, 40)];
    //    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    //
    //	textView.minNumberOfLines = 1;
    //	textView.maxNumberOfLines = 6;
    //	textView.returnKeyType = UIReturnKeyDefault; //just as an example
    //	textView.font = [UIFont systemFontOfSize:15.0f];
    //	textView.delegate = self;
    //    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    //    textView.backgroundColor = [UIColor whiteColor];
    
    msgTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 236, 30)];
    msgTextField.backgroundColor = [UIColor whiteColor];
    //msgTextField.borderStyle = UITextBorderStyleBezel;
    msgTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    msgTextField.delegate = self;
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(10, 0,240, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:msgTextField];
    // [containerView addSubview:entryImageView];
    
    // UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    //  UIImage *camBtnBackground = [[UIImage imageNamed:@"cam.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    
    // UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"send" forState:UIControlStateNormal];
    
    //[doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    // doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    //  doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    // [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    //  [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    
    
    
    //    UIButton *doneBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //	doneBtn2.frame = CGRectMake(containerView.frame.origin.x+1,2, 35,40);
    //    doneBtn2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    //	[doneBtn2 setTitle:@"" forState:UIControlStateNormal];
    //
    //    [doneBtn2 setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    //    doneBtn2.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    //    doneBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    //
    //    [doneBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //	[doneBtn2 addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    //    [doneBtn2 setBackgroundImage:camBtnBackground forState:UIControlStateNormal];
    
    //[doneBtn2 setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    
	//[containerView addSubview:doneBtn2];
    
    
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
}

-(void)scrollTableview
{
    [self.sphChatTable reloadData];
    int lastSection=[self.sphChatTable numberOfSections]-1;
    int lastRowNumber = [self.sphChatTable numberOfRowsInSection:lastSection]-1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:lastSection];
    [self.sphChatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _overlayView.hidden=YES;
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if([sphBubbledata count]==0){
        _overlayView.hidden=NO;
    }
    else{
        _overlayView.hidden=YES;
    }
    [ self dismissViewAnimation];
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissViewAnimation{
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    if (sphBubbledata.count>2) {
        
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    CGRect tableviewframe=self.sphChatTable.frame;
    tableviewframe.size.height-=200;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	containerView.frame = containerFrame;
    self.sphChatTable.frame=tableviewframe;
    
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    CGRect tableviewframe=self.sphChatTable.frame;
    tableviewframe.size.height+=200;
    
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	// set views with new info
    self.sphChatTable.frame=tableviewframe;
	containerView.frame = containerFrame;
	// commit animations
	[UIView commitAnimations];
}

-(void)resignTextView{
    if ([msgTextField.text length]<1) {
        
    }
    else
    {
        NSString *chat_Message=msgTextField.text;
        // textView.text=@"";
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"hh:mm a"];
        
        NSString *rowNumber=[NSString stringWithFormat:@"%d",sphBubbledata.count];
        
        //if (sphBubbledata.count%2==0) {
        [self adddBubbledata:@"textByme" mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sending"];
        //        }else{
        //            [self adddBubbledata:@"textbyother" mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:@"Sending"];
        //
        //        }
        
        _msgCount++;
        [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:2.0];
    }
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
}

-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    
    [self.sphChatTable scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.sphChatTable numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.sphChatTable numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

-(IBAction)uploadImage:(id)sender
{
    [self goToBottom];
    // [self.sphChatTable setContentOffset:CGPointMake(0, [sphBubbledata count]*10)];
    //    if ([UIImagePickerController isSourceTypeAvailable:
    //         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    //    {
    //        UIImagePickerController *imagePicker =
    //        [[UIImagePickerController alloc] init];
    //        imagePicker.delegate = self;
    //        imagePicker.sourceType =
    //        UIImagePickerControllerSourceTypePhotoLibrary;
    //        imgPicker.mediaTypes = [NSArray arrayWithObjects:
    //                                (NSString *) kUTTypeImage,
    //                                nil];
    //        imagePicker.allowsEditing = NO;
    //        [self presentViewController:imagePicker animated:YES completion:nil];
    //        newMedia = NO;
    //    }
}



-(void)adddBubbledata:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    feed_data=[[SPHChatData alloc]init];
    feed_data.messageText=messagetext;
    //feed_data.messageImageURL=messagetext;
    //feed_data.messageImage=messageImage;
    //feed_data.messageTime=messageTime;
    feed_data.messageType=messageType;
    // feed_data.messagestatus=status;
    [sphBubbledata addObject:feed_data];
    [self.sphChatTable reloadData];
    
    //[self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sphBubbledata.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.messageType isEqualToString:@"textByme"]||[feed_data.messageType isEqualToString:@"textbyother"])
    {
        float cellHeight;
        // text
        NSString *messageText = feed_data.messageText;
        //
        CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
        CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:14]
                                      constrainedToSize:boundingSize
                                          lineBreakMode:NSLineBreakByWordWrapping];
        
        // plain text
        cellHeight = itemTextSize.height;
        
        if (cellHeight<25) {
            
            cellHeight=25;
        }
        return cellHeight+30;
    }
    else{
        return 140;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sphChatTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    NSString *messageText = feed_data.messageText;
    
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    static NSString *CellIdentifier4 = @"Cell4";
    
    CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
    CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:14]
                                  constrainedToSize:boundingSize
                                      lineBreakMode:NSLineBreakByWordWrapping];
    float textHeight = itemTextSize.height+7;
    int x=0;
    if (textHeight>200)
    {
        x=65;
    }else
        if (textHeight>150)
        {
            x=50;
        }
        else if (textHeight>80)
        {
            x=30;
        }else
            if (textHeight>50)
            {
                x=20;
            }else
                if (textHeight>30) {
                    x=8;
                }
    
    // Types= ImageByme  , imageByOther  textByme  ,textbyother
    
    if ([feed_data.messageType isEqualToString:@"textByme"]) {
        
        
        
        SPHBubbleCellOther  *cell = (SPHBubbleCellOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellOther" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        else{
            
        }
        
        
        UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubbleMine"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        bubbleImage.tag=55;
        [cell.contentView addSubview:bubbleImage];
        [bubbleImage setFrame:CGRectMake(300-itemTextSize.width,5,itemTextSize.width+14,textHeight+4)];
        
        
        UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(295 - itemTextSize.width+5,2,itemTextSize.width+10, textHeight-2)];
        [cell.contentView addSubview:messageTextview];
        messageTextview.editable=NO;
        messageTextview.text = messageText;
        messageTextview.dataDetectorTypes=UIDataDetectorTypeAll;
        messageTextview.textAlignment=NSTextAlignmentJustified;
        messageTextview.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
        messageTextview.backgroundColor=[UIColor clearColor];
        messageTextview.textColor = [UIColor whiteColor];
        messageTextview.tag=indexPath.row;
        cell.Avatar_Image.image=[UIImage imageNamed:@"Customer_icon"];
        
        
        
        cell.time_Label.text=feed_data.messageTime;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        messageTextview.scrollEnabled=NO;
        
        [cell.Avatar_Image setupImageViewer];
        if ([feed_data.messagestatus isEqualToString:@"Sent"]) {
            
            cell.statusindicator.alpha=0.0;
            [cell.statusindicator stopAnimating];
            cell.statusImage.alpha=1.0;
            [cell.statusImage setImage:[UIImage imageNamed:@"success"]];
            
        }else  if ([feed_data.messagestatus isEqualToString:@"Sending"])
        {
            cell.statusImage.alpha=0.0;
            cell.statusindicator.alpha=1.0;
            [cell.statusindicator startAnimating];
            
        }
        else
        {
            cell.statusindicator.alpha=0.0;
            [cell.statusindicator stopAnimating];
            cell.statusImage.alpha=1.0;
            [cell.statusImage setImage:[UIImage imageNamed:@"failed"]];
            
        }
        
        cell.Avatar_Image.layer.cornerRadius = 20.0;
        cell.Avatar_Image.layer.masksToBounds = YES;
        cell.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.Avatar_Image.layer.borderWidth = 2.0;
        
        
        //        UITapGestureRecognizer *singleFingerTap =
        //        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        //        [messageTextview addGestureRecognizer:singleFingerTap];
        //        singleFingerTap.delegate = self;
        
        return cell;
    }
    else
        if ([feed_data.messageType isEqualToString:@"textbyother"]) {
            
            
            SPHBubbleCell  *cell = (SPHBubbleCell *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier2];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            else{
                
            }
            //[bubbleImage setFrame:CGRectMake(265-itemTextSize.width,5,itemTextSize.width+14,textHeight+4)];
            UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubbleSomeone"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
            [cell.contentView addSubview:bubbleImage];
            [bubbleImage setFrame:CGRectMake(10,5, itemTextSize.width+18, textHeight+4)];
            bubbleImage.tag=56;
            //CGRectMake(260 - itemTextSize.width+5,2,itemTextSize.width+10, textHeight-2)];
            UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(20,2,itemTextSize.width+10, textHeight-2)];
            [cell.contentView addSubview:messageTextview];
            messageTextview.editable=NO;
            messageTextview.text = messageText;
            messageTextview.dataDetectorTypes=UIDataDetectorTypeAll;
            messageTextview.textAlignment=NSTextAlignmentJustified;
            messageTextview.backgroundColor=[UIColor clearColor];
            messageTextview.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
            messageTextview.scrollEnabled=NO;
            messageTextview.tag=indexPath.row;
            messageTextview.textColor=[UIColor blackColor];
            cell.Avatar_Image.layer.cornerRadius = 20.0;
            cell.Avatar_Image.layer.masksToBounds = YES;
            cell.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.Avatar_Image.layer.borderWidth = 2.0;
            [cell.Avatar_Image setupImageViewer];
            
            cell.Avatar_Image.image=[UIImage imageNamed:@"my_icon"];
            cell.time_Label.text=feed_data.messageTime;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            //            UITapGestureRecognizer *singleFingerTap =
            //            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
            //            [messageTextview addGestureRecognizer:singleFingerTap];
            //            singleFingerTap.delegate = self;
            
            return cell;
        }
        else
            if ([feed_data.messageType isEqualToString:@"ImageByme"])
            {
                SPHBubbleCellImage  *cell = (SPHBubbleCellImage *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier3];
                if (cell == nil)
                {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImage" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                else
                {
                }
                if ([feed_data.messagestatus isEqualToString:@"Sent"])
                {
                    cell.statusindicator.alpha=0.0;
                    [cell.statusindicator stopAnimating];
                    cell.statusImage.alpha=1.0;
                    [cell.statusImage setImage:[UIImage imageNamed:@"success"]];
                    // cell.message_Image.imageURL=[NSURL URLWithString:feed_data.messageImageURL];
                    
                }
                else
                    if ([feed_data.messagestatus isEqualToString:@"Sending"])
                    {
                        cell.message_Image.image=[UIImage imageNamed:@""];
                        //cell.message_Image.imageURL=[NSURL URLWithString:feed_data.messageImageURL];
                        cell.statusImage.alpha=0.0;
                        cell.statusindicator.alpha=1.0;
                        [cell.statusindicator startAnimating];
                    }
                    else
                    {
                        cell.statusindicator.alpha=0.0;
                        [cell.statusindicator stopAnimating];
                        cell.statusImage.alpha=1.0;
                        [cell.statusImage setImage:[UIImage imageNamed:@"failed"]];
                    }
                cell.message_Image.image=Uploadedimage.image;
                cell.Avatar_Image.layer.cornerRadius = 20.0;
                cell.Avatar_Image.layer.masksToBounds = YES;
                cell.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
                cell.Avatar_Image.layer.borderWidth = 2.0;
                [cell.Avatar_Image setupImageViewer];
                //  cell.Buble_image.image= [[UIImage imageNamed:@"Bubbletyperight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
                [cell.message_Image setupImageViewer];
                cell.Avatar_Image.image=[UIImage imageNamed:@"Customer_icon"];
                cell.time_Label.text=feed_data.messageTime;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }else{
                
                
                SPHBubbleCellImageOther  *cell = (SPHBubbleCellImageOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier4];
                if (cell == nil)
                {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImageOther" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                else{
                    
                }
                
                [cell.message_Image setupImageViewer];
                // cell.Buble_image.image= [[UIImage imageNamed:@"Bubbletypeleft"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
                cell.message_Image.imageURL=[NSURL URLWithString:@"http://www.binarytribune.com/wp-content/uploads/2013/06/india_binary_options-274x300.png"];
                
                cell.Avatar_Image.layer.cornerRadius = 20.0;
                cell.Avatar_Image.layer.masksToBounds = YES;
                cell.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
                cell.Avatar_Image.layer.borderWidth = 2.0;
                [cell.Avatar_Image setupImageViewer];
                
                cell.Avatar_Image.image=[UIImage imageNamed:@"my_icon"];
                cell.time_Label.text=feed_data.messageTime;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
    
    
}




- (IBAction)showLeftMenuPressed:(id)sender {
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
        [shRes fetchChatList];
    }];
}
//#pragma mark - UIBubbleTableViewDataSource implementation
//
//- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
//{
//    return [_bubbleData count];
//}
//
//- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
//{
//    return [_bubbleData objectAtIndex:row];
//}
//
//-(void)loadMessage {
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *data1 = [defaults objectForKey:@"selectedUser"];
//    selectedUser = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//
//    NSData *data2 = [defaults objectForKey:@"selectedName"];
//    selectedName = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
//
//    NSArray *array = [selectedName componentsSeparatedByString:@" "];
//
//    UIView *msgTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 45)];
//    msgTitleView.backgroundColor = [UIColor clearColor];
//
//    UIImageView *msgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 40, 40)];
//    // msgImageView.image = [UIImage imageNamed:@"mess.png"];
//
//    NSString *connectedUserUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",selectedUser];
//
//    [msgImageView setImageWithURL:[NSURL URLWithString:connectedUserUrl]];
//    msgImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [SMUtils makeRoundedImageView:msgImageView withBorderColor:appOfflineUserUIColor];
//
//
//
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
//    nameLabel.text =[array objectAtIndex:0];
//    nameLabel.textColor = [UIColor whiteColor];
//    [msgTitleView addSubview:nameLabel];
//    [msgTitleView addSubview:msgImageView];
//
//    //self.navItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mess.png"]];
//    // NSLog(@"selected userid:%@",selectedUser);
//    self.navItem.titleView = msgTitleView;
//    //self.navItem.titleView.backgroundColor = [UIColor redColor];
//    //self.navBar.tintColor = [UIColor redColor];
//    //self.navigationItem.titleView = msgTitleView;
//
//    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
//    fbAccessToken=[shRes getFbAccessToken];
//    // NSLog(@"fbaccessToken:%@ and fbuserid:%@",[shRes getFbAccessToken],[shRes getFbLoggedInUserId]);
//    fbUserId=[shRes getFbLoggedInUserId];
//
////
////    [SMUWebServices changeMessageStatusWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"changeReadStatus" user_id1:fbUserId user_id2:selectedUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
////
////    }];
//
//
////    [SMUWebServices homeMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"getMessages" fromUserId:selectedUser pageNo:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
////
////        SMUGetMessage *msgObj = (SMUGetMessage *)responseObject;
//       // NSLog(@"total pageNo:%d",msgObj.total_page);
//
//
//       // for(int j=msgObj.total_page-1;j>=0;j--) {
//            [SMUWebServices homeMessageDetailsWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"getMessages" fromUserId:selectedUser pageNo:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//                SMUGetMessage *msgObj = (SMUGetMessage *)responseObject;
//                if([msgObj.messageArray count]==0){
//                    [self overLayView];
//                }
//
//                for(int i=0;i<[msgObj.messageArray count];i++) {
//                    SMUMessage *msgModels = (SMUMessage *)[msgObj.messageArray objectAtIndex:i];
//                    NSBubbleData *replyBubble;
//                    if([msgModels.from_user_id isEqualToString:fbUserId]) {
//                       // NSLog(@"from user msg");
//                        replyBubble = [NSBubbleData dataWithText:msgModels.message date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
//                    } else {
//                      //  NSLog(@"to user msg");
//                        replyBubble = [NSBubbleData dataWithText:msgModels.message date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeSomeoneElse];
//                    }
//
//                    [_bubbleData insertObject:replyBubble atIndex:i];
//                }
//
//                _bubbleTable.bubbleDataSource = self;
//                _bubbleTable.snapInterval = 30;
//                _bubbleTable.showAvatars = YES;
//                [_bubbleTable reloadData];
//                //NSLog(@"bubble content size:%f and bubble table size:%f",_bubbleTable.contentSize.height,_bubbleTable.frame.size.height);
//                CGRect screenBounds = [[UIScreen mainScreen] bounds];
//                if(screenBounds.size.height == 568) {
//                    [_bubbleTable setContentOffset:CGPointMake(0,_bubbleTable.contentSize.height-420) animated:NO];
//                } else {
//                    [_bubbleTable setContentOffset:CGPointMake(0,_bubbleTable.contentSize.height-350) animated:NO];
//                }
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
//
//            }];
//
//       // }
//        // NSLog(@"bubble data count:%d",[_bubbleData count]);
//
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
//        //MessageModels *msgModels = (MessageModels *)[msgObj.messageArray objectAtIndex:0];
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
////
////    }];
//
//
//}
//
//-(void)overLayView{
//
//
//    _overlayView.hidden=NO;
//
//    NSDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"connectedDetails"];
//
//    //NSLog(@"dict in overlay:%@",dict);
//   // NSLog(@"busername:%@",[dict objectForKey:@"bUserId"]);
//
//    NSString *buserName=[dict objectForKey:@"bUserName"];
//   // NSString *buserId=[dict objectForKey:@"bUserId"];
//    NSString *connectedDate=[dict objectForKey:@"connectedDate"];
//    NSString *imgUrl=[dict objectForKey:@"bUserImageUrl"];
//
//
//    [SMUtils makeRoundedImageView:_userCImageView withBorderColor:[UIColor clearColor]];
//    [SMUtils makeRoundedImageView:_overlayUserBView withBorderColor:[UIColor clearColor]];
//
//    if([buserName isEqualToString:@""]){
//
//        _overlayUserBView.hidden=YES;
//        _userBNameLabel.hidden=YES;
//        _introLabel.text=[NSString stringWithFormat:@"Matched with %@",selectedName];
//
//
//    }
//    else{
//        _overlayUserBView.hidden=NO;
//        NSURL *url=[NSURL URLWithString:imgUrl];
//        [_overlayUserBView setImageWithURL:url placeholderImage:nil];
//        _overlayUserBView.contentMode=UIViewContentModeScaleAspectFill;
//        NSString *lbl=[NSString stringWithFormat:@"Introduced by %@",buserName];
//        _introLabel.text=lbl;
//        _userBNameLabel.text=buserName;
//
//    }
//
//    _dataLabel.text=[NSString stringWithFormat:@"on %@",connectedDate];
//    NSString *connectedUserUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=300&height=300",selectedUser];
//    NSURL *url=[NSURL URLWithString:connectedUserUrl];
//    [_userCImageView setImageWithURL:url placeholderImage:nil];
//    _userCImageView.contentMode=UIViewContentModeScaleAspectFill;
//
//
//}
//-(BOOL) textFieldShouldReturn: (UITextField *) textField {
//
//    if([_bubbleData count]==0){
//        _overlayView.hidden=NO;
//    }
//    else{
//        _overlayView.hidden=YES;
//    }
//    [ self dismissViewAnimation];
//
//    [textField resignFirstResponder];
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    _overlayView.hidden=YES;
//    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
//    CGRect frame = self.view.frame;
//    frame.origin.y = -151;
//    [self.view setFrame:frame];
//    [UIView commitAnimations];
//
//}
//-(void)dismissViewAnimation{
//    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
//    CGRect frame = self.view.frame;
//    frame.origin.y = 64;
//    [self.view setFrame:frame];
//    [UIView commitAnimations];
//}
-(void)createJsonForSendReplyMessage:(NSString *)message
                          fromUserId:(NSString *)from_id
                            toUserId:(NSString *)to_id {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:message forKey:@"message"];
    [dict setObject:from_id forKey:@"user_id1"];
    [dict setObject:to_id forKey:@"user_id2"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // NSLog(@"json string:%@",jsonString);
    }
}
//
-(void)createJsonForSendNewMessage:(NSString *)message
                          toUserId:(NSString *)to_id {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:message forKey:@"message"];
    [dict setObject:to_id forKey:@"to_user_id"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"json string:%@",jsonString);
    }
}
//
//
//- (IBAction)sendBtn:(id)sender {
//
//    NSBubbleData *sayBubble = [NSBubbleData dataWithText:_textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
//    if([_textField.text length]!=0){
//        [_bubbleData insertObject:sayBubble atIndex:[_bubbleData count]];
//    }
//    [_bubbleTable reloadData];
//                    //NSLog(@"bubble content size:%f and bubble table size in sendbtn:%f",_bubbleTable.contentSize.height,_bubbleTable.frame.size.height);
//    [_bubbleTable setContentOffset:CGPointMake(0,_bubbleTable.contentSize.height-420) animated:NO];
//   // [ self dismissViewAnimation];
//    //NSLog(@"bubble data count:%d",[_bubbleData count]);
//    if([_bubbleData count] != 0) {
//        [self createJsonForSendReplyMessage:_textField.text fromUserId:fbUserId toUserId:selectedUser];
//       // [self createJsonForSendNewMessage:_textField.text toUserId:selectedUser];
//        [SMUWebServices sendReplyWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"sendReply" messageString:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
//
//        }];
//    } else {
//        [self createJsonForSendNewMessage:_textField.text toUserId:selectedUser];
//       // [self createJsonForSendReplyMessage:_textField.text fromUserId:fbUserId toUserId:selectedUser];
//        [SMUWebServices sendNewMessageWithAccessToken:fbAccessToken forUserId:fbUserId withMessageType:@"sendNewMessage" messageString:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //[[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
//            
//        }];
//    }
//    _textField.text = @"";
//   // [_textField resignFirstResponder];
//    
//}






@end
