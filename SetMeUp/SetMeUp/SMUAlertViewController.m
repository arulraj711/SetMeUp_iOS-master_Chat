//
//  SMUAlertViewController.m
//  SetMeUp
//
//  Created by Go on 29/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUAlertViewController.h"
#import "SMUAppDelegate.h"
#import "SMUSharedResources.h"

@interface SMUAlertViewController ()
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@property(nonatomic,strong) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong) IBOutlet UITextView *descLabel;
@property(nonatomic,readwrite) __block BOOL isSharedInstancePresented;
-(IBAction)tryAgainButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;

@end

@implementation SMUAlertViewController

+(SMUAlertViewController*)sharedInstance;
{
	static dispatch_once_t p = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&p, ^{
        UIStoryboard *storyBoard=[SMUSharedResources sharedResourceManager].mainStoryBoard;
		_sharedObject = [storyBoard instantiateViewControllerWithIdentifier:@"SMUAlertViewController"];;
    });
	return _sharedObject;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpAlertWithTitle:(NSString*)title withSubTile:(NSString*)subTitle withOperation:(AFHTTPRequestOperation*)failedOperation;
{
    _titleLabel.text=title;
    _descLabel.text=subTitle;
    _operation=failedOperation;
}

-(BOOL)presentModelInRootViewController;
{
    __block BOOL status=NO;
    if (!_isSharedInstancePresented) {
        SMUAppDelegate *appDel=[UIApplication sharedApplication].delegate;
        UIViewController *rootVC=appDel.window.rootViewController;
        _isVisible=YES;
        [rootVC presentViewController:self animated:YES completion:^{
            status=YES;
            _isSharedInstancePresented=YES;
        }];
    }
    return status;
}

-(IBAction)tryAgainButtonClicked:(id)sender;
{
    //this may crash check when you are here
    [[NSOperationQueue mainQueue] addOperation:[_operation copy]];
    _isVisible=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        _isSharedInstancePresented=NO;
    }];
}

-(IBAction)cancelButtonClicked:(id)sender;
{
    _isVisible=NO;
    [self dismissViewControllerAnimated:YES completion:^{
        _isSharedInstancePresented=NO;
    }];
}

@end
