//
//  SMUGalleryViewController.m
//  SetMeUp
//
//  Created by Fx on 09/01/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUGalleryViewController.h"
#import "UIImageView+WebCache.h"
#import "SMUGalleryViewCell.h"
#import "SMUPhoto.h"
#import "SMUFriendOfFriend.h"
#import "ITSideMenu.h"

@interface SMUGalleryViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic, strong) IBOutlet UICollectionView *mainImageCollection;
@end

@implementation SMUGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.menuContainerViewController setPanMode:ITSideMenuPanModeSideMenu];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.title=[NSString stringWithFormat:@"Photos 1/%lu",(unsigned long)[_aFOF.photos count]];
    if (_activeIndex) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_activeIndex inSection:0];
        [_mainImageCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.title=[NSString stringWithFormat:@"Photos %d/%lu",_activeIndex+1,(unsigned long)[_aFOF.photos count]];
    }
    else
    {
        [self updateTitle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Helpers 

-(void)updateTitle;
{
    for (UICollectionViewCell *cell in [self.mainImageCollection visibleCells]) {
        NSIndexPath *indexPath = [self.mainImageCollection indexPathForCell:cell];
        //        self.title=[NSString stringWithFormat:@"%@ %d/%d",_aFOF.fullName,indexPath.row+1,[_aFOF.photos count]];
        NSLog(@"update indexpath:%d",indexPath.row);
        self.title=[NSString stringWithFormat:@"Photos %d/%lu",indexPath.row+1,(unsigned long)[_aFOF.photos count]];
        _activeIndex=indexPath.row;
    }
}

#pragma mark- Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_aFOF.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell indexpath:%d",indexPath.row);
    
    SMUGalleryViewCell *cell =(SMUGalleryViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryViewCell" forIndexPath:indexPath];
    SMUPhoto *userPhoto = [_aFOF.photos objectAtIndex:indexPath.row];
    NSURL *url=[NSURL URLWithString:userPhoto.photoURLstring];
    [cell.profileImageView setImageWithURL:url placeholderImage:nil];
    cell.profileImageView.contentMode=UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width= collectionView.frame.size.width;
    CGFloat height= collectionView.frame.size.height;
    CGSize cellSize=CGSizeMake(width, height);
    return cellSize;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.x;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // NSLog(@"x position:%f",scrollView.contentOffset.x);
    
    
    if (_lastContentOffset < (int)scrollView.contentOffset.x) {
        // moved right
        NSLog(@"move right");
        [self updateTitle];
    }
    else if (_lastContentOffset > (int)scrollView.contentOffset.x) {
        // moved left
        NSLog(@"move left");
        [self updateTitle];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updateTitle];
    }
}

@end
