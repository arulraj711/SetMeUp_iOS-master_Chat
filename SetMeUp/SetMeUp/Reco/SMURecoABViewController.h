//
//  SMURecoIntroduceViewController.h
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHWalkThroughView.h"

@interface SMURecoABViewController : UIViewController<GHWalkThroughViewDataSource>  {
    NSString *fbAccessToken,*fbUserId;
}
@property(nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *recos;
@property(nonatomic,strong) NSMutableArray *nonSmu;
@property (nonatomic,strong) NSArray *nonSmuUserArray;
@property (nonatomic,strong) NSString *checkSelection;
@property (nonatomic, strong) GHWalkThroughView* ghView;
@end
