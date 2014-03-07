//
//  SMURecoPullDownViewController.h
//  SMUReco
//
//  Created by In on 29/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMUBCReco;

@interface SMURecoPullDownViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong )NSMutableArray *recos;
@property(nonatomic, strong) SMUBCReco *recoBC;
@property(nonatomic,strong)UIImage *bgImage;
@property(nonatomic,readwrite) NSUInteger currentIndexA;

-(void)showPictureGalleryFromIndex:(NSInteger)index;
-(void)showMyMatchMakers;

@end
