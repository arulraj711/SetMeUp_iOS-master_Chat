//
//  SMURightViewController.m
//  SetMeUp
//
//  Created by In on 03/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMURightViewController.h"

@interface SMURightViewController ()

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UIView *chatView;
@property (strong, nonatomic) IBOutlet UIView *recoListView;
@end

@implementation SMURightViewController

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
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"viewController1" sender:nil];
    });
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0)
        [self performSegueWithIdentifier:@"viewController1" sender:nil];
//        [self switchView:_recoListView view2:_chatView];
    else
//        [self switchView:_chatView view2:_recoListView];
        [self performSegueWithIdentifier:@"viewController2" sender:nil];

}
- (void)switchView:(UIView *)view1 view2:(UIView *)view2
{
    [UIView animateWithDuration:0.1 animations:^{
        view1.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            view2.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
@end
