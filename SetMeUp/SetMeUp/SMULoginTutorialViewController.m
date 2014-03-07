//
//  SMULoginTutorialViewController.m
//  SetMeUp
//
//  Created by Go on 15/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMULoginTutorialViewController.h"

@interface SMULoginTutorialViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UIImageView *midLineImageView;
@property(nonatomic, strong) IBOutlet UILabel *label1;
@property(nonatomic, strong) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;


@property(nonatomic, strong) IBOutlet UIView *bottomContainer;
@property(nonatomic, strong) IBOutlet UIView *roundsContainer;
@property(nonatomic, strong) IBOutlet UILabel *bottomLabel;
@property(nonatomic, strong) IBOutlet UIButton *fbButton;

-(IBAction)startOverClicked:(id)sender;
-(IBAction)fbLoginClicked:(id)sender;
-(IBAction)aboutClicked:(id)sender;
-(IBAction)careersClicked:(id)sender;
-(IBAction)privacyClicked:(id)sender;
-(IBAction)termsOfServiceClicked:(id)sender;
@end

@implementation SMULoginTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_label1 setFont:[UIFont fontWithName:@"DartangnonITC" size:26]];
    
    attString =
    [[NSMutableAttributedString alloc]
     initWithString: @"WE NEVER POST ANYTHING ON YOUR FACEBOOK"];
    
    
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont boldSystemFontOfSize:14]
                      range: NSMakeRange(3,5)];
    
 //WITH OVER 60 MILLION SEARCHABLE PEOPLE
    
    attString1 =
    [[NSMutableAttributedString alloc]
     initWithString: @"WITH OVER 60 MILLION SEARCHABLE PEOPLE"];
    
    
    
    [attString1 addAttribute: NSFontAttributeName
                      value:  [UIFont boldSystemFontOfSize:14]
                      range: NSMakeRange(10,10)];
    
    [self configureForTutorialPage:_pageIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Helpers

-(void)configureForTutorialPage:(NSInteger)pageIndex
{
    switch (pageIndex) {
        case 0:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"TutorialPage1.png"];
            _midLineImageView.image = [UIImage imageNamed:@"dividerArrow.png"];
          //  MEET  NEW  PEOPLE  IN  YOUR  SOCIAL  CIRCLE Meet
            _label1.text=@"Meet new people in your social circle.";
            _label2.text=@"ASK A FRIEND TO INTRODUCE YOU.";
            _fbButton.hidden=NO;
           // _bottomLabel.text=@"WE DON'T LIKE APPS THAT POST ON YOUR TIMELINE. REALLY, WE HATE THAT!";
            _bottomLabel.attributedText=attString;
            _bottomLabel.hidden=NO;
            _bottomContainer.hidden=YES;
            _roundsContainer.hidden=YES;
            
        }
            break;
        case 1:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"TutorialPage2.png"];
            _midLineImageView.image = [UIImage imageNamed:@"dividerArrow.png"];
            _label1.text=@"Your friends know a lot of people...";
         //   _label1.text=@"YOUR FRIENDS KNOW A LOT OF PEOPLE...";
            _label2.text=@"SEE WHO THEY'RE CONNECTED WITH.";
            _fbButton.hidden=NO;
           // _bottomLabel.text=@"WE DON'T LIKE APPS THAT CONNECT YOU WITH STRANGERS. WE HATE THAT, TOO!";
                      _bottomLabel.attributedText=attString;
            _bottomLabel.hidden=NO;
            _bottomContainer.hidden=YES;
            _roundsContainer.hidden=YES;
        }
            break;
        case 2:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"TutorialPage3.png"];
            _midLineImageView.image = [UIImage imageNamed:@"dividerArrow.png"];
           // _label1.text=@"..AND YOUR FRIENDS KNOW A LOT ABOUT YOU";
            _label1.text=@"..and your friends know a lot about you.";
            _label2.text=@"HAVE THEM INTRODUCE YOU IN A FUN AND QUICK WAY.";
            _fbButton.hidden=NO;
           // _bottomLabel.text=@"WE DON'T LIKE APPS THAT SHARE YOUR INFO. SERIOUSLY CUT IT OUT!";
                      _bottomLabel.attributedText=attString;
            _bottomLabel.hidden=NO;
            _bottomContainer.hidden=YES;
            _roundsContainer.hidden=YES;
        }
            break;
        case 3:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"TutorialPage4.png"];
            _midLineImageView.image = [UIImage imageNamed:@"dividerArrow.png"];
            //_label1.text=@"DON'T TALK TO A SCREEN ALL DAY";
            _label1.text=@"Don't talk to screen all day.";
            _label2.text=@"MEET UP AT A SAFE AND FAMILIAR HANGOUT SPOT.";
            _fbButton.hidden=NO;
          //  _bottomLabel.text=@"WE DON'T LIKE APPS THAT KEEP YOU BEHIND YOUR COMPUTER. WHAT'S THE POINT?";
                      _bottomLabel.attributedText=attString;
            _bottomLabel.hidden=NO;
            _bottomContainer.hidden=YES;
            _roundsContainer.hidden=YES;
        }
            break;
        case 4:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"TutorialPage1.png"];
            _midLineImageView.image = [UIImage imageNamed:@"horizaltal_divider.png"];
           // _label1.text=@"YOU'RE ALL SET! HOPE YOU ENJOY THE PARTY";
            _label1.text=@"You're all set!hope you enjoy the party.";
            _label2.text=@"MEET NEW PEOPLE THROUGH YOUR MUTUAL FRIENDS";
            _fbButton.hidden=NO;
            _bottomLabel.hidden=YES;
            _bottomContainer.hidden=NO;
            _roundsContainer.hidden=YES;
            _label3.attributedText=attString1;
        }
            break;
        default:
            break;
    }
}

-(IBAction)startOverClicked:(id)sender;
{
    if ([_delegate respondsToSelector:@selector(startOverButtonClickedInSMULoginTutorialViewController:)]) {
        [_delegate startOverButtonClickedInSMULoginTutorialViewController:self];
    }
}

-(IBAction)fbLoginClicked:(id)sender;
{


    
    if ([_delegate respondsToSelector:@selector(loginButtonClickedInSMULoginTutorialViewController:)]) {
        [_delegate loginButtonClickedInSMULoginTutorialViewController:self];
    }
}

-(IBAction)aboutClicked:(id)sender;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/SetMeUpapp"]];
}

-(IBAction)careersClicked:(id)sender;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
}

-(IBAction)privacyClicked:(id)sender;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.setmeupapp.com/privacy_policy"]];
}

-(IBAction)termsOfServiceClicked:(id)sender;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.setmeupapp.com/terms_of_service"]];
}

@end



//_pageTitles = @[@"MEET NEW PEOPLE IN YOUR SOCIAL CIRCLE", @"YOUR FRIENDS KNOW A LOT OF PEOPLE..", @"..AND YOUR FRIENDS KNOW A LOT ABOUT YOU", @"..AND YOUR FRIENDS KNOW A LOT ABOUT YOU",@"YOU'RE ALL SET! HOPE YOU ENJOY THE PARTY"];
//_pageSubTitles = @[@"ASK A FRIEND TO INTRODUCE YOU.",@"SEE WHO THEY'RE CONNECTED WITH.",@"HAVE THEM INTRODUCE YOU IN A FUN AND QUICK WAY.",@"HAVE THEM INTRODUCE YOU IN A FUN AND QUICK WAY.",@"MEET NEW PEOPLE THROUGH YOUR MUTUAL FRIENDS"];
//_pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png",@"page5.png"];
