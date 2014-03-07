//
//  SMURecoQuipsViewController.m
//  SMUReco
//
//  Created by In on 26/12/13.
//  Copyright (c) 2013 Indi. All rights reserved.
//

#import "SMURecoQuipsViewController.h"
#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+screenshot.h"
#import "SMUQuipsCell.h"
#import "SMURecoCell.h"
#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"
#import "SMUQuipData.h"
#import "SMUQuipQuestion.h"
#import "SMURatingData.h"
#import "SMURecoUserA.h"
#import "SMURecoAB.h"
#import "EDStarRating.h"
#import "SMURecoBottomView.h"
#import "SMURecoABViewController.h"
#import "SMUBCReco.h"
#import "SMURecoUserB.h"
#import "SMUBCRecoUserA.h"
#import "SMUBCRecoQuipData.h"
#import "SMUBCRecoRatings.h"
#import "SMUBCRecoQuestions.h"
#import "UIImageView+AFNetworking.h"
@interface SMURecoQuipsViewController()<SMUQuipsCellDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,SMURecoBottomViewDelegate>

@property (nonatomic, strong) IBOutlet     UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *quipsCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) IBOutlet UIImageView  *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint,*heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet SMURecoBottomView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@end
@implementation SMURecoQuipsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureQuipsView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (IBAction)cancel:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recoVCDismissedNotification" object:self.navigationController];
}
#pragma mark - Quips View Configuration
- (void)configureQuipsView
{
    [self configureQuipsBackgroundView];
    [self configureQuipsImageView];
    [self configureQuipsCollectionView];
    [self configureQuipsBottomBar];
    if(_recoQuipsViewType == SMURecoQuipsViewTypeRecoC)
    {
        
        NSString *selectedPageNo=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedPageNo"];
        _currentIndexA = [selectedPageNo intValue];
       // NSLog(@"current quip index:%d and pageno:%@",_currentIndexA,selectedPageNo);
        SMURecoUserB *userB = self.recoBC.userB;
        SMUBCRecoUserA *userA = [userB.userAs objectAtIndex:_currentIndexA];
        [_imageView2 setImageWithURL:[NSURL URLWithString:userB.imageUrl] placeholderImage:nil];
        [_imageView setImageWithURL:[NSURL URLWithString:userA.img_url] placeholderImage:nil];
        
        if([userA.age isKindOfClass:[NSString class]])
            self.title = [NSString stringWithFormat:@"%@, %@",userA.firstname,userA.age] ;
        else
            self.title = userA.firstname ;

    }
    if(_recoQuipsViewType == SMURecoQuipsViewTypeDefault)
    {
        [self showTutorialView];
        [_introButton setTitle:@"     INTRODUCE" forState:UIControlStateNormal];
    }
    
}
- (void)configureQuipsBackgroundView
{
    self.bgImageView.image = _bgImage;
    self.imageView.image = self.recoAB.userA.image;
}
- (void)configureQuipsImageView
{
    if(_recoQuipsViewType == SMURecoQuipsViewTypeDefault)
    {
        _widthConstraint.constant =
        _heightConstraint.constant = (([[UIScreen mainScreen] bounds].size.height > 500)
                                      ? 240 // Four Inch
                                      : 150 // 3.5 Inch
                                      );
        _imageViewTopConstraint.constant = 20;
        _imageView2.hidden = YES;
    }
    else{
        _widthConstraint.constant =
        _heightConstraint.constant = (([[UIScreen mainScreen] bounds].size.height > 500)
                                      ? 180 // Four Inch
                                      : 100 // 3.5 Inch
                                      );
        _imageViewTopConstraint.constant = 10;
        _imageView2.hidden = NO;
    }
    
    [_imageView layoutIfNeeded];
    [SMURecoCell makeRoundedImageView:self.imageView withBorderColor:[UIColor whiteColor]];
    [SMURecoCell makeRoundedImageView:self.imageView2 withBorderColor:[UIColor whiteColor]];
    
    _imageView2.layer.borderWidth=1;
}
- (void)configureQuipsBottomBar
{
    [_bottomView applyBlurEffect:self.view];
    _bottomView.delegate = self;
//
//    UIImage *bottomImage = [_bottomImageView blurredBackgroundImageWithBackgroundView:self.view];
//    bottomImage = [bottomImage applyLightDarkEffect];
//
//    _bottomImageView.image = bottomImage;
}
- (void)configureQuipsCollectionView
{
    _quipsCollectionView.delegate = self;
    _quipsCollectionView.dataSource = self;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setItemSize:CGSizeMake(320.0, _quipsCollectionView.frame.size.height)];
    _flowLayout.minimumLineSpacing = 0.0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_quipsCollectionView setBounces:NO];
    [_quipsCollectionView setCollectionViewLayout:_flowLayout];
    [_quipsCollectionView setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - UICollectionView for UIPageControl

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
	
    SMUQuipsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [self setDataForQuipsCell:cell atIndex:indexPath.row];
    if(_recoQuipsViewType == SMURecoQuipsViewTypeRecoC)
        [cell setViewNonEditable];
    cell.delegate = self;
    return cell;
}
- (void)setDataForQuipsCell:(SMUQuipsCell *)quipCell atIndex:(NSUInteger)index
{
    if(_recoQuipsViewType == SMURecoQuipsViewTypeRecoC)
    {
        [self setRecoCForQuipCell:quipCell atIndex:index];
    }
    else
    {
        [self setRecoABForQuipCell:quipCell atIndex:index];
    }
}
- (void)setRecoCForQuipCell:(SMUQuipsCell *)quipCell atIndex:(NSUInteger)index
{
    //  Name
//    SMUBCReco *recoBC = self.recoBC;
    SMURecoUserB *userB = self.recoBC.userB;
    SMUBCRecoUserA *userA = [userB.userAs objectAtIndex:_currentIndexA];
    
    //quipCell.quipsLabel.text = [[NSString stringWithFormat:@"%@'s Quips",userA.name] uppercaseString];
    
   
       //  Question Button
    SMUBCRecoQuipData *quipData = userA.quipArray[index];
    //NSLog(@"quip data:%@",quipData.categoryName);
    quipCell.quipsLabel.text = [[NSString stringWithFormat:@"%@",quipData.categoryName] uppercaseString];
    [quipCell.button1 setTitle:[[(SMUBCRecoQuestions *)quipData.questionArray[0] questionText] uppercaseString] forState:UIControlStateNormal];
   // quipCell.button1.selected = [[(SMUBCRecoQuestions *)quipData.questionArray[0] questionId] isEqualToString:quipData.answer];
    
    [quipCell.button2 setTitle:[[(SMUBCRecoQuestions *)quipData.questionArray[1] questionText] uppercaseString] forState:UIControlStateNormal];
   // quipCell.button2.selected = [[(SMUBCRecoQuestions *)quipData.questionArray[1] questionId] isEqualToString:quipData.answer];
    
    if([[(SMUBCRecoQuestions *)quipData.questionArray[0] questionId] isEqualToString:quipData.answer]) {
        quipCell.button1.backgroundColor = selectedQuipUIColor;
    } else if([[(SMUBCRecoQuestions *)quipData.questionArray[1] questionId] isEqualToString:quipData.answer]) {
        quipCell.button2.backgroundColor = selectedQuipUIColor;
    }
    
    //  Ratings
    SMUBCRecoRatings *ratings = userA.ratingArray[index];
    quipCell.ratingsTitleLable.text = [ratings.question_text uppercaseString];
    quipCell.starRating.rating = [ratings.answer floatValue];
}

- (void)setRecoABForQuipCell:(SMUQuipsCell *)quipCell atIndex:(NSUInteger)index
{
    
    //  Name
    SMURecoUserA *userA = self.recoAB.userA;

   
    _navItem.title=[[NSString stringWithFormat:@"%@'s Quips",userA.name] uppercaseString];
    
    NSShadow* shadow = [NSShadow new];
   // shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
   // shadow.shadowColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:20.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];

    //quipCell.quipsLabel.text = [[NSString stringWithFormat:@"%@'s Quips",userA.name] uppercaseString];
    _navItem.title=[NSString stringWithFormat:@"Describe %@",userA.firstname];
    


   
    //  Question Button
     _quipSelected = @"No";
    SMUQuipData *quipData = self.recoAB.quipDataArray[index];
     quipCell.quipsLabel.text = [[NSString stringWithFormat:@"%@",quipData.categoryName] uppercaseString];
    [quipCell.button1 setTitle:[[(SMUQuipQuestion *)quipData.questions[0] question_text] uppercaseString] forState:UIControlStateNormal];
    quipCell.button1.selected = [(SMUQuipQuestion *)quipData.questions[0] isSelected];
    
    [quipCell.button2 setTitle:[[(SMUQuipQuestion *)quipData.questions[1] question_text] uppercaseString] forState:UIControlStateNormal];
    quipCell.button2.selected = [(SMUQuipQuestion *)quipData.questions[1] isSelected];
    
    //  Ratings
    _ratingSelected = @"No";
    SMURatingData *ratings = self.recoAB.ratingDataArray[index];
    quipCell.ratingsTitleLable.text = [ratings.ratingText uppercaseString];
    quipCell.starRating.rating = ratings.rating;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}



-(void)showTutorialView {
    
    NSString *recoTutorialStatus=[[NSUserDefaults standardUserDefaults] objectForKey:@"recoAB2TutorialStatus"];
    //NSLog(@"reco tutorial status:%@",recoTutorialStatus);
    if([recoTutorialStatus isEqualToString:@"New"]) {
    NSString *fcTutorialStatus1 = @"Old";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:fcTutorialStatus1 forKey:@"recoAB2TutorialStatus"];
    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.navigationController.view.bounds];
    [_ghView setDataSource:self];
    _ghView.pageControl.hidden = YES;
    _ghView.pageControl1.hidden = YES;
    // [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    self.ghView.floatingHeaderView = nil;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    [self.view addSubview:self.ghView];
    [self.ghView showInView:self.navigationController.view animateDuration:0.3];
    
     }
}

#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 1;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    NSString* imageName =[NSString stringWithFormat:@"reco2"];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}



#pragma mark - UIScrollVewDelegate for UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _quipsCollectionView.frame.size.width;
    float currentPage = _quipsCollectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
        _pageControl.currentPage = currentPage + 1;
    } else {
        _pageControl.currentPage = currentPage;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SMUQuipsCellDelegate
- (void)quipsCell:(SMUQuipsCell *)quipsCell didButtonClicked:(UIButton *)button
{
    //  Question Button
    NSIndexPath *indexPath = [_quipsCollectionView indexPathForCell:quipsCell];
    SMUQuipData *quipData = self.recoAB.quipDataArray[indexPath.row];
   _quipSelected = @"Yes";
    if(quipsCell.button1 == button)
    {
        quipsCell.button2.selected = !button.selected;
       // NSLog(@"first button");
        //  Button1
        [(SMUQuipQuestion *)quipData.questions[0] setIsSelected:button.isSelected];
        [(SMUQuipQuestion *)quipData.questions[1] setIsSelected:!button.isSelected];
    }
    else
    {
       // NSLog(@"second button");
        //  Button2
        quipsCell.button1.selected = !button.selected;
        [(SMUQuipQuestion *)quipData.questions[1] setIsSelected:button.isSelected];
        [(SMUQuipQuestion *)quipData.questions[0] setIsSelected:!button.isSelected];
    }
    
    if(_pageControl.currentPage == 2)
    {
        //NSLog(@"All Quips Loaded");
        return;
    }
    else{
//        _pageControl.currentPage++;
//        CGFloat prevPageX = _quipsCollectionView.frame.size.width * MIN(_pageControl.currentPage, 5);
//        [_quipsCollectionView setContentOffset:CGPointMake(prevPageX, 0) animated:YES];
    }
    
    if([_ratingSelected isEqualToString:@"Yes"] && [_quipSelected isEqualToString:@"Yes"]) {
        _pageControl.currentPage++;
        CGFloat prevPageX = _quipsCollectionView.frame.size.width * MIN(_pageControl.currentPage, 5);
        [_quipsCollectionView setContentOffset:CGPointMake(prevPageX, 0) animated:YES];
    }
}

- (void)quipsCell:(SMUQuipsCell *)quipsCell starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    _ratingSelected = @"Yes";
    NSIndexPath *indexPath = [_quipsCollectionView indexPathForCell:quipsCell];
    SMURatingData *ratings = self.recoAB.ratingDataArray[indexPath.row];
    ratings.rating = rating;
    ratings.isRatingsUpdated = YES;
    if([_ratingSelected isEqualToString:@"Yes"] && [_quipSelected isEqualToString:@"Yes"]) {
        _pageControl.currentPage++;
        CGFloat prevPageX = _quipsCollectionView.frame.size.width * MIN(_pageControl.currentPage, 5);
        [_quipsCollectionView setContentOffset:CGPointMake(prevPageX, 0) animated:YES];
    }
}
#pragma mark - SMURecoBottomView
- (void)didIgnoreButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *controller = self.navigationController.viewControllers[0];
    [(id < SMURecoBottomViewDelegate > )controller didIgnoreButtonClickedSMURecoBottomView:recoBottomView];
}
- (void)didIntroduceButtonClickedSMURecoBottomView:(SMURecoBottomView *)recoBottomView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *controller = self.navigationController.viewControllers[0];
    [(id < SMURecoBottomViewDelegate > )controller didIntroduceButtonClickedSMURecoBottomView:recoBottomView];
}
- (void)navigateToRootViewController:(SMURecoBottomView *)recoBottomView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIViewController *controller = self.navigationController.viewControllers[0];
    [(id < SMURecoBottomViewDelegate > )controller didIgnoreButtonClickedSMURecoBottomView:recoBottomView];
}
- (IBAction)continueButtonPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
