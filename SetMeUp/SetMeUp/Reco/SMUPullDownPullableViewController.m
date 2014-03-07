//
//  SMUPullDownPullableViewController.m
//  SetMeUp
//
//  Created by In on 01/02/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUPullDownPullableViewController.h"
#import "SMUPullDownViewController.h"
#import "SMUPhotoThumbViewCell.h"
#import "SMUInterestsThumbCell.h"
#import "SMUFriendsThumbCell.h"
#import "SMUFriend.h"
#import "SMUInterest.h"
#import "SMUPhoto.h"
#import "SMUtils.h"
#import "SMUFriendOfFriend.h"
#import "SMUPhoto.h"
#import "SMUInterest.h"
#import "SMUFriend.h"
#import "UIImageView+WebCache.h"
#import "SMUUserBCell.h"
#import "SMUSharedResources.h"
#import "SMUGalleryViewController.h"
#import "SMUSetMeUpViewController.h"

@interface SMUPullDownPullableViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UIView *fakepullUpBar;
@property(nonatomic,strong)IBOutlet UIView *profileInfoView;
@property(nonatomic,strong)IBOutlet UIView *albumInterestView;
@property(nonatomic,strong)IBOutlet UIView *mutualFriendsView;
@property(nonatomic,strong)IBOutlet UIView *matchmakerView;
@property(nonatomic,strong)IBOutlet UIView *notifView;
@property(nonatomic,strong) UICollectionViewController *matchMakerCollectionVC;
@property(nonatomic,strong) UICollectionViewController *albumInterestCollectionVC;
@property(nonatomic,strong) UICollectionViewController *mutualFriendsCollectionVC;
@property(nonatomic,strong) IBOutlet UISegmentedControl *albumInterestSegmentControl;
@property(nonatomic,readwrite) NSUInteger friendOfFriendIndex;
@property(nonatomic,strong) NSMutableArray *currentMatchMakers;
@property(nonatomic,strong) IBOutlet UILabel *userNameLabel;
@property(nonatomic,strong) IBOutlet UILabel *userDetailsLabel1;
@property(nonatomic,strong) IBOutlet UILabel *userDetailsLabel2;
@property(nonatomic,strong) IBOutlet UILabel *userDetailsLabel3;
@property(nonatomic,strong) IBOutlet UILabel *segmentNotifLabel;
@property(nonatomic,strong) IBOutlet UILabel *mutualFriendsCountLabel;
@property(nonatomic,strong) IBOutlet UILabel *mutualFriendsNotifLabel;
@property(nonatomic,strong) IBOutlet UILabel *mutualInterestsNotifLabel;
@property(nonatomic,strong) IBOutlet UIImageView *userDetailsImgView1;
@property(nonatomic,strong) IBOutlet UIImageView *userDetailsImgView2;
@property(nonatomic,strong) IBOutlet UIImageView *userDetailsImgView3;

- (IBAction)didAlbumInterestSegmentChanged:(UISegmentedControl *)sender;

@end

@implementation SMUPullDownPullableViewController

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
    self.view.opaque = NO; // Not really sure if needed
    //    self.view.backgroundColor = [UIColor colorWithRed:0. green:0.39 blue:0.106 alpha:0.];
    //    float color = 0.1;
    //    self.view.backgroundColor = [UIColor colorWithRed:color green:color blue:color alpha:color];
    CGRect windowRect=[[UIApplication sharedApplication] keyWindow].frame;
    _fakepullUpBar=[[UIView alloc] initWithFrame:CGRectMake(0, windowRect.size.height-20-20-44, 320, 20)];
    UIImageView *pullUpImg=[[UIImageView alloc] initWithFrame:CGRectMake(149, 5, 23, 9)];
    _fakepullUpBar.backgroundColor=[UIColor clearColor];
    [pullUpImg setImage:[UIImage imageNamed:@"pullDown_arrowUp"]];
    [_fakepullUpBar addSubview:pullUpImg];
    [self.view addSubview:_fakepullUpBar];
    _fakepullUpBar.alpha=0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter Setters
-(void)setFriendOfFriend:(SMUFriendOfFriend *)friendOfFriend
{
   // NSLog(@"setfriendoffriend:%@",friendOfFriend);
    _friendOfFriend=friendOfFriend;
    [self updateViewWithCurrentData];
}

#pragma mark - IBActions

- (IBAction)didAlbumInterestSegmentChanged:(UISegmentedControl *)sender {
    [_albumInterestCollectionVC.collectionView setContentOffset:CGPointZero animated:YES];
    [_albumInterestCollectionVC.collectionView reloadData];
}

- (IBAction)addMatchmakersClicked:(id)sender
{
    UIViewController *matchmakersVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUMyMatchMakersViewController"];
    UINavigationController * navcontrol = [[UINavigationController alloc] initWithRootViewController: matchmakersVC];
    [navcontrol.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:appBarTextUIColor, NSForegroundColorAttributeName,nil]];
    [navcontrol.navigationBar setBarTintColor:[UIColor colorWithRed:43.0/255.0 green:40.0/255.0 blue:54.0/255.0 alpha:1.0]];
    navcontrol.navigationBar.translucent=NO;
    [self presentViewController:navcontrol animated:YES completion:^{
        
    }];
}

#pragma mark - Helpers

-(void)updateViewWithCurrentData{
    if (_currentMatchMakers==nil) {
        _currentMatchMakers=[[NSMutableArray alloc] init];
    }
    [_currentMatchMakers removeAllObjects];
    if ([SMUSharedResources sharedResourceManager].isManualMatchMaking) {
        [_currentMatchMakers addObjectsFromArray:[[SMUSharedResources sharedResourceManager] matchMakers]];
    }
    else
    {
        //Auto matchmaking on; so show only mutual matchmakers
        NSArray *allMatchmakers=[[SMUSharedResources sharedResourceManager] matchMakers];
        for (int i=0; i<allMatchmakers.count; i++) {
            SMUFriend *aFriend=[allMatchmakers objectAtIndex:i];
            for (SMUFriend *aMF in _friendOfFriend.mutualFriends) {
                if ([aMF.userID isEqualToString:aFriend.userID]) {
                    [_currentMatchMakers addObject:aFriend];
                    break;
                }
            }
        }
    }
    //    if (_friendOfFriend.age) {
    //        _userNameLabel.text=[NSString stringWithFormat:@"About %@,%ld",_friendOfFriend.fullName,(long)_friendOfFriend.age];
    //    }
    //    else
    //    {
    //        _userNameLabel.text=[NSString stringWithFormat:@"About %@",_friendOfFriend.fullName];
    //    }
    _userNameLabel.text=@"About";
    _userDetailsLabel1.text=_friendOfFriend.collegeName;
    _userDetailsLabel2.text=_friendOfFriend.home_town;
    _userDetailsLabel3.text=_friendOfFriend.workPlace;
    if ([_friendOfFriend.collegeName length]==0) {
        _userDetailsImgView1.hidden=YES;
    }
    else{
        _userDetailsImgView1.hidden=NO;
    }
    if ([_friendOfFriend.home_town length]==0) {
        _userDetailsImgView2.hidden=YES;
    }
    else{
        _userDetailsImgView2.hidden=NO;
    }
    if ([_friendOfFriend.workPlace length]==0) {
        _userDetailsImgView3.hidden=YES;
    }
    else{
        _userDetailsImgView3.hidden=NO;
    }
    _albumInterestSegmentControl.selectedSegmentIndex=0;
    NSString *mutualStr;
    if (_friendOfFriend.mutualFriendsCount==0) {
        mutualStr=@"No Mutual Friends";
    }
    else if (_friendOfFriend.mutualFriendsCount==1)
    {
        mutualStr=@"1 Mutual Friend";
    }
    else{
        mutualStr=[NSString stringWithFormat:@"%ld Mutual Friends",(long)_friendOfFriend.mutualFriendsCount];
    }
    _mutualFriendsNotifLabel.text=mutualStr;
    _mutualFriendsCountLabel.text=mutualStr;
    if (_friendOfFriend.mutualInterestCount==0) {
        mutualStr=@"No Mutual Interests";
    }
    else if (_friendOfFriend.mutualInterestCount==1)
    {
        mutualStr=@"1 Mutual Interest";
    }
    else{
        mutualStr=[NSString stringWithFormat:@"%ld Mutual Interests",(long)_friendOfFriend.mutualInterestCount];
    }
    _mutualInterestsNotifLabel.text=mutualStr;
    _albumInterestCollectionVC.collectionView.contentOffset=CGPointZero;
    [_albumInterestCollectionVC.collectionView reloadData];
    [_mutualFriendsCollectionVC.collectionView reloadData];
    [_matchMakerCollectionVC.collectionView reloadData];
}

-(void)hideMatchMakersViewWithPercentage:(CGFloat)percent;
{
    _matchmakerView.alpha=1-(100.0-percent)/100.0;
    _notifView.alpha=1-(100.0-percent)/100.0;
    if (percent/100==0) {
        _fakepullUpBar.alpha=1;
    }
}

-(void)showMatchMakersViewWithPercentage:(CGFloat)percent;
{
    _matchmakerView.alpha=percent/100.0;
    _notifView.alpha=percent/100.0;
    _fakepullUpBar.alpha=0.0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumInteritemSpacing=2.0;
    flowlayout.minimumLineSpacing=2.0;
    UICollectionViewController *aCollectionVC =(UICollectionViewController *)segue.destinationViewController;
    aCollectionVC.collectionView.delegate=self;
    aCollectionVC.collectionView.dataSource=self;
    [aCollectionVC.collectionView setCollectionViewLayout:flowlayout];
    [aCollectionVC.collectionView setShowsHorizontalScrollIndicator:YES];
    [aCollectionVC.collectionView setShowsVerticalScrollIndicator:NO];
    
    if ([segue.identifier isEqualToString:@"PhotosInterestesSegue"]) {
        _albumInterestCollectionVC=aCollectionVC;
    }
    else if ([segue.identifier isEqualToString:@"FOFMutualFriendsSegue"]) {
        _mutualFriendsCollectionVC=aCollectionVC;
    }
    else if ([segue.identifier isEqualToString:@"MatchMakerSegue"]) {
        flowlayout.minimumInteritemSpacing=5.0;
        flowlayout.minimumLineSpacing=2.0;
        _matchMakerCollectionVC=aCollectionVC;
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSUInteger collectionCellsCount;
    if ([_albumInterestCollectionVC.collectionView isEqual:view]) {
        if(_albumInterestSegmentControl.selectedSegmentIndex==0){
            collectionCellsCount = [_friendOfFriend.photos count];
            if (collectionCellsCount==0) {
                _segmentNotifLabel.text=@"No photos found";
                _segmentNotifLabel.hidden=NO;
            }
            else{
                _segmentNotifLabel.hidden=YES;
            }
        }
        else {
            collectionCellsCount = _friendOfFriend.interests.count;
            if (collectionCellsCount==0) {
                _segmentNotifLabel.text=@"No Interests found";
                _segmentNotifLabel.hidden=NO;
            }
            else{
                _segmentNotifLabel.hidden=YES;
            }
        }
    }
    else if ([_mutualFriendsCollectionVC.collectionView isEqual:view]) {
        collectionCellsCount = _friendOfFriend.mutualFriends.count;
    }
    else {
        collectionCellsCount = _currentMatchMakers.count;
    }
    return collectionCellsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if ([_albumInterestCollectionVC.collectionView isEqual:cv]) {
        if(_albumInterestSegmentControl.selectedSegmentIndex==0){
            SMUPhotoThumbViewCell *localCell =(SMUPhotoThumbViewCell*) [cv dequeueReusableCellWithReuseIdentifier:@"SMUPhotoThumbViewCell" forIndexPath:indexPath];
            SMUPhoto *aPhoto=[[_friendOfFriend photos] objectAtIndex:indexPath.row];
            [localCell setAPhoto:aPhoto];
            cell=localCell;
        }
        else if(_albumInterestSegmentControl.selectedSegmentIndex==1){
            SMUInterestsThumbCell *localCell =(SMUInterestsThumbCell*) [cv dequeueReusableCellWithReuseIdentifier:@"SMUInterestsThumbCell" forIndexPath:indexPath];
            SMUInterest *aInterest=_friendOfFriend.interests[indexPath.row];
            [localCell setAInterest:aInterest];
            cell=localCell;
        }
    }
    else if ([_mutualFriendsCollectionVC.collectionView isEqual:cv]) {
        SMUFriendsThumbCell *localCell =(SMUFriendsThumbCell*) [cv dequeueReusableCellWithReuseIdentifier:@"SMUFriendsThumbCell" forIndexPath:indexPath];
        SMUFriend *aFriend=_friendOfFriend.mutualFriends[indexPath.row];
        [localCell setFriendObject:aFriend];
        cell=localCell;
    }
    else if ([_matchMakerCollectionVC.collectionView isEqual:cv]) {
        SMUUserBCell *localCell =(SMUUserBCell*) [cv dequeueReusableCellWithReuseIdentifier:@"SMUUserBCell" forIndexPath:indexPath];
        SMUFriend *aFriend=_currentMatchMakers[indexPath.row];
        [localCell setSmuFriend:aFriend];
        [localCell setIsMutualFriend:NO];
        for (SMUFriend *aMF in _friendOfFriend.mutualFriends) {
            if ([aMF.userID isEqualToString:aFriend.userID]) {
                [localCell setIsMutualFriend:YES];
                break;
            }
        }
        cell=localCell;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_albumInterestCollectionVC.collectionView] && _albumInterestSegmentControl.selectedSegmentIndex==0) {
        if ([self.parentViewController isKindOfClass:[SMUSetMeUpViewController class]])
        {
            SMUSetMeUpViewController *setmeupVC=(SMUSetMeUpViewController*)self.parentViewController;
            [setmeupVC showPictureGalleryFromIndex:indexPath.row];
        }}
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height= collectionView.frame.size.height;
    CGSize cellSize=CGSizeMake(height, height);
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSUInteger dataSourceCount = 0;
    
    if ([_albumInterestCollectionVC.collectionView isEqual:collectionView])
    {
        if(_albumInterestSegmentControl.selectedSegmentIndex==0)
        {
            dataSourceCount = [[_friendOfFriend photos] count];
        }
        else if(_albumInterestSegmentControl.selectedSegmentIndex==1)
        {
            dataSourceCount = _friendOfFriend.interests.count;
        }
    }
    else if ([_mutualFriendsCollectionVC.collectionView isEqual:collectionView])
    {
        dataSourceCount = _friendOfFriend.mutualFriends.count;
    }
    else if ([_matchMakerCollectionVC.collectionView isEqual:collectionView])
    {
        dataSourceCount = _currentMatchMakers.count;
    }
    UICollectionViewFlowLayout *collectionViewFlowLayout = (UICollectionViewFlowLayout*)collectionViewLayout;
    CGFloat height= collectionView.frame.size.height;
    CGSize cellSize= CGSizeMake(height, height);
    
    NSUInteger cellsPerRow = (int) collectionView.frame.size.width/cellSize.width;
    if(cellsPerRow >= dataSourceCount)
    {
        //  Have to center
        float cumulativeCellWidth = dataSourceCount * cellSize.width;
        float cumulativeCellSpacing = (dataSourceCount - 1) * collectionViewFlowLayout.minimumInteritemSpacing;
        float emptySpace = collectionView.frame.size.width - (cumulativeCellWidth + cumulativeCellSpacing);
        float edgeInsetValue = roundf(emptySpace/2);
        return UIEdgeInsetsMake(0.0, edgeInsetValue, 0.0, edgeInsetValue);
        //NSLog(@"Have to center");
    }
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

@end
