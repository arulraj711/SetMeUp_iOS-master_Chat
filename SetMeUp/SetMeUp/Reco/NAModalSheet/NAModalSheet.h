//
//  NAModalSheet.h
//  Note All
//
//  Created by Ken Worley on 11/17/13.
//
//

#import <Foundation/Foundation.h>
#define kBlurParameter 0.6
#define kViewAnimationDuration 0.4

typedef NS_ENUM(NSUInteger, NAModalSheetPresentationStyle) {
  NAModalSheetPresentationStyleSlideInFromBottom,
  NAModalSheetPresentationStyleSlideInFromTop,
  NAModalSheetPresentationStyleFadeInCentered
};

@class NAModalSheet;

@protocol NAModalSheetDelegate <NSObject>

-(void)modalSheetTouchedOutsideContent:(NAModalSheet*)sheet;

@end

@interface NAModalSheet : UIViewController

@property (nonatomic, weak) id<NAModalSheetDelegate> delegate;
@property (nonatomic, assign) CGFloat slideInset;
@property (nonatomic, assign) CGFloat cornerRadiusWhenCentered;

- (instancetype)initWithViewController:(UIViewController *)vc
                     presentationStyle:(NAModalSheetPresentationStyle)style;

-(void)presentWithCompletion:(void (^)(void))completion;
-(void)dismissWithCompletion:(void (^)(void))completion;

@end
