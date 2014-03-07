//
//  SMUSearchToolViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 2/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface SMUSearchToolViewController : UIViewController{
    NSString *fbAccessToken,*userId,*gender,*educationString,*locationString,*workplaceString;
    int minage,maxage,textTag;
    
}
- (IBAction)closeButtonPressed:(id)sender;

@property(nonatomic,strong)NSMutableArray *suggestionArr;
@property(nonatomic,strong)NSDictionary *searchDetails;
@property(nonatomic,readwrite)NSInteger searchFlag;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCtrl;
- (IBAction)saveButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *ageSliderBg;

@property (weak, nonatomic) IBOutlet NMRangeSlider *ageSlider;
- (IBAction)ageValueChanged:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *ageChangelbl;
- (IBAction)segmentChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *educationText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;

@property (weak, nonatomic) IBOutlet UITextField *workPlaceText;

@property (weak, nonatomic) IBOutlet UIView *workPlaceView;

@property (weak, nonatomic) IBOutlet UIView *locationView;

- (IBAction)resetButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *educationView;
@property (nonatomic, strong) NSTimer *timer;



@end
