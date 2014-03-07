//
//  SMUViewController.m
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMUViewController.h"
#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"

@interface SMUViewController ()

- (IBAction)loadRecoC:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation SMUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        UIImage *snapshot = [UIImage imageNamed:@"RecoImage.png"];
        NSData *imageData = UIImageJPEGRepresentation(snapshot, 0.01);
        UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:0.5];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            self.bgImageView.image = blurredSnapshot;
        });
    });

//    double delayInSeconds = 0.3;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////        [self loadRecoC:nil];
//        [self loadReco];
//    });
}
- (IBAction)loadReco
{
    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoABNVC"];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadRecoC:(UIButton *)sender {
    //RecoCIntroductionNVC
    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoCNVC"];
    [self presentViewController:navigationController animated:YES completion:nil];
}
@end
