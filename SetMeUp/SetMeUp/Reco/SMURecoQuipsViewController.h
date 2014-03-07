//
//  SMURecoQuipsViewController.h
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHWalkThroughView.h"
typedef enum
{
    SMURecoQuipsViewTypeDefault,
    SMURecoQuipsViewTypeRecoC
}SMURecoQuipsViewType;

@class SMUBCReco;
@class SMURecoAB;

@interface SMURecoQuipsViewController : UIViewController<GHWalkThroughViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
- (IBAction)continueButtonPressed:(id)sender;

@property(nonatomic,strong)UIImage *bgImage;
@property(nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property(nonatomic, readwrite)SMURecoQuipsViewType recoQuipsViewType;
@property(nonatomic, strong) SMURecoAB *recoAB;
@property(nonatomic, strong) SMUBCReco *recoBC;
@property(nonatomic,strong) GHWalkThroughView *ghView;
@property(nonatomic,readwrite) NSUInteger currentIndexA;
@property (nonatomic,strong) NSString *quipSelected;
@property (nonatomic,strong) NSString *ratingSelected;
@property (weak, nonatomic) IBOutlet UIButton *introButton;

@end
