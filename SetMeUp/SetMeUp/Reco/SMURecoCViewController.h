//
//  SMURecoCViewController.h
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMURecoCUserBCollectionViewLayout;
@class SMURecoCUserACollectionViewLayout;

@interface SMURecoCViewController : UIViewController {
    NSString *fbAccessToken,*fbUserId;
}

@property(nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property(nonatomic,strong )NSMutableArray *recos;
@end
