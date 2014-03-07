//
//  SMUSetMeUpViewController.h
//  SetMeUp
//
//  Created by Indi on 12/19/13.
//  Copyright (c) 2013 Indi Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHWalkThroughView.h"
#define kTopBarHeight 0
#define kMatchMakerBarVisibleHeight 75

typedef enum {
    ScrollDirectionNull=0,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionLeft,
    ScrollDirectionRight
}ScrollDirection;

@interface SMUSetMeUpViewController : UIViewController<GHWalkThroughViewDataSource,GHWalkThroughViewDelegate>{
    UIView *useLessView;
    int rightCnt,leftCnt;
}
@property (strong, nonatomic) IBOutlet UIView *approveTutorialView;
@property (nonatomic, strong) GHWalkThroughView* ghView;
@property (strong, nonatomic) IBOutlet UIView *setmeupTutorialView;
@property (nonatomic, strong) GHWalkThroughView* ghView1;
@property (nonatomic,strong) NSString *buttonFlag;
- (IBAction)noButtonClick:(id)sender;
- (IBAction)yesButtonClick:(id)sender;
@property (nonatomic,strong) NSString *pageName;
-(void)showPictureGalleryFromIndex:(NSInteger)index;
-(void)showMyMatchMakers;
-(void)showUserC;
-(void)showUserCTutorial;
-(void)hideUseLessView;
@end
