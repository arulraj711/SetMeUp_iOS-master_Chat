//
//  SMUInviteUserCViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/7/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUInviteUserCViewController.h"
#import "SMUUserCInvite.h"
#import "SMUFriendsThumbCell.h"
#import "SMUInterestsThumbCell.h"
#import "UIImageView+WebCache.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
@interface SMUInviteUserCViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation SMUInviteUserCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //NSLog(@"coming inside prepareSegue");
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumInteritemSpacing=3.0;
    flowlayout.minimumLineSpacing=2.0;
    UICollectionViewController *aCollectionVC =(UICollectionViewController *)segue.destinationViewController;
    aCollectionVC.collectionView.delegate=self;
    aCollectionVC.collectionView.dataSource=self;
    [aCollectionVC.collectionView setCollectionViewLayout:flowlayout];
    [aCollectionVC.collectionView setShowsHorizontalScrollIndicator:YES];
    [aCollectionVC.collectionView setShowsVerticalScrollIndicator:NO];
    if ([segue.identifier isEqualToString:@"InviteUserCSegue"]) {
        _inviteUserCCollectionView=aCollectionVC;
    }
}
#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSUInteger collectionCellsCount;
    
    collectionCellsCount =_inviteCUserDetails.count;
    return collectionCellsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if ([_inviteUserCCollectionView.collectionView isEqual:cv]) {
        
        SMUInterestsThumbCell *localCell =(SMUInterestsThumbCell*) [cv dequeueReusableCellWithReuseIdentifier:@"SMUInterestsThumbCell" forIndexPath:indexPath];
        
        SMUUserCInvite *userCinvite=(SMUUserCInvite *)[_inviteCUserDetails objectAtIndex:indexPath.row];
        
        [localCell setUserCObject:userCinvite];
   
        cell=localCell;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSLog(@"didselect");
    
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
    
    dataSourceCount = _inviteCUserDetails.count;
    
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
    }
    return UIEdgeInsetsMake(0, 5, 0, 0); // top, left, bottom, right
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setViewWithDetails];
    
    
}
-(void)setViewWithDetails{
    
    //NSLog(@"userCDetails:%@",_inviteCUserDetails);
    
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    
    
    SMUUserCInvite * userDetails=(SMUUserCInvite *)[_inviteCUserDetails objectAtIndex:0];
    _userAName.text=userDetails.a_user_name;
    
    NSURL *url1=[NSURL URLWithString:userDetails.a_user_imgurl];
    
    [_userAImageView setImageWithURL:url1 placeholderImage:nil];
    _userAImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [SMUtils makeRoundedImageView:_userAImageView withBorderColor:appDefaultUserUIColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inviteButtonPressed:(id)sender {
    [self createJSON];
        [self dismissViewControllerAnimated:YES completion:nil];
    [SMUWebServices inviteNonSmuUserWithAccessToken:fbAccessToken forUserId:userId toUserIds:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)createJSON{
    
    NSMutableDictionary *userArray=[[NSMutableDictionary alloc]init];
    
    for(int i=0;i<[_inviteCUserDetails count];i++){
        
        SMUUserCInvite *inviteObj=(SMUUserCInvite *)[_inviteCUserDetails objectAtIndex:i];
        NSMutableDictionary *userDict=[[NSMutableDictionary alloc]init];
        
        [userDict setObject:inviteObj.messageTemplate forKey:inviteObj.c_user_id];
        
        [userArray addEntriesFromDictionary:userDict];
    }
    
  //  [dict setObject:_inviteDetails.messageTemplate forKey:_inviteDetails.b_user_id];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData){
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    
}

- (IBAction)keepPlayingPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
