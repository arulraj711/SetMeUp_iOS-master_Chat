//
//  SMUMyMatchMakersViewController.m
//  SetMeUp
//
//  Created by In on 22/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import "SMUMyMatchMakersViewController.h"
#import "SMUMyMatchMakerCell.h"
#import "SMUSharedResources.h"
#import "SMUFriend.h"

@interface SMUMyMatchMakersViewController () <UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *selectedFriends;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *bottomBar;
@property (nonatomic, strong) IBOutlet UIButton *findMatchButton;

- (IBAction)cancelMyMatchMakers:(id)sender;
- (IBAction)doneMyMatchMakers:(id)sender;

- (void)filterData;
- (void)updateTitle;

@end

@implementation SMUMyMatchMakersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchResults=[[NSMutableArray alloc] init];
    _selectedFriends=[[NSMutableArray alloc] init];
    _friends = [[SMUSharedResources sharedResourceManager] friends];
    [_searchResults addObjectsFromArray:_friends];
    [_selectedFriends addObjectsFromArray:[[SMUSharedResources sharedResourceManager] matchMakers]];
    [self resetSelectedMM];
    NSString *emptyResults =[[NSUserDefaults standardUserDefaults] objectForKey:@"emptyResults"];
    if([emptyResults isEqualToString:@"YES"]) {
        [_selectedFriends removeAllObjects];
        [_collectionView reloadData];
        NSString *noUserC = [NSString stringWithFormat:@"NO"];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:noUserC forKey:@"emptyResults"];
    }
}

-(void)resetSelectedMM {
    //NSLog(@"before searchresult count:%d",[_searchResults count]);
    for(int i=0;i<[_selectedFriends count];i++) {
        SMUFriend *_aFriend = [_selectedFriends objectAtIndex:i];
        [_searchResults removeObject:_aFriend];
    }
    //NSLog(@"intermediate searchresult count:%d",[_searchResults count]);
    for(int i=0;i<[_selectedFriends count];i++) {
        SMUFriend *_aFriend = [_selectedFriends objectAtIndex:i];
        [_searchResults insertObject:_aFriend atIndex:i];
    }
    //NSLog(@"after searchresult count:%d",[_searchResults count]);
    [_collectionView reloadData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTitle];
    _searchBar.tintColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction methods

- (IBAction)cancelMyMatchMakers:(id)sender{
    
//    NSString *emptyResults =[[NSUserDefaults standardUserDefaults] objectForKey:@"emptyResults"];
//    if([emptyResults isEqualToString:@"YES"]) {
//        [_selectedFriends removeAllObjects];
//        [_collectionView reloadData];
//        NSString *noUserC = [NSString stringWithFormat:@"NO"];
//        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//        [def setObject:noUserC forKey:@"emptyResults"];
//    }
    
//    NSString *noUserCFlag =[[NSUserDefaults standardUserDefaults] objectForKey:@"noUserC"];
//    if([_selectedFriends count] == 0 && [noUserCFlag isEqualToString:@"YES"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select one matchmakers" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    //}
}

- (IBAction)doneMyMatchMakers:(id)sender{
    SMUSharedResources *smuMngr = [SMUSharedResources sharedResourceManager];
    SMUSharedResources * __weak weakMngr = smuMngr;
    BOOL isMatchMakersModified=NO;
    if ([[smuMngr matchMakers] count]==[_selectedFriends count]) {
        //count is same check every element
        NSArray *allMatchmakers=[smuMngr matchMakers];
        for (int i=0; i<_selectedFriends.count; i++) {
            SMUFriend *aFriend=[_selectedFriends objectAtIndex:i];
            BOOL isFriendFound=NO;
            for (SMUFriend *aMatchMaker in allMatchmakers) {
                if ([aMatchMaker.userID isEqualToString:aFriend.userID]) {
                    isFriendFound=YES;
                    break;
                }
            }
            if (isFriendFound==NO) {
                isMatchMakersModified=YES;
                break;
            }
        }
    }
    else
    {
        isMatchMakersModified=YES;
    }
    
    
    
    
    
    //NSString *noUserCFlag =[[NSUserDefaults standardUserDefaults] objectForKey:@"noUserC"];
    if([_selectedFriends count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select one matchmakers" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            if (isMatchMakersModified) {
                [weakMngr showProgressHUDForViewWithTitle:nil withDetail:@"Studies show that remembering bits of information about a person and working them into conversations not only is highly flattering but also shows interest."];
                [weakMngr setMatchMakers:_selectedFriends];
                [weakMngr fetchInitialFOFList];
            }

        }];
    }
    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        if (isMatchMakersModified) {
//            [weakMngr showProgressHUDForViewWithTitle:nil withDetail:@"Studies show that remembering bits of information about a person and working them into conversations not only is highly flattering but also shows interest."];
//            [weakMngr setMatchMakers:_selectedFriends];
//            [weakMngr fetchInitialFOFList];
//        }
//    }];
}

#pragma mark - Helper methods
- (void)filterData {
    if ([_searchBar.text length]==0) {
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:_friends];
    }
    else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", _searchBar.text];
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:[_friends filteredArrayUsingPredicate:predicate]];
    }
    [self resetSelectedMM];
   // [_collectionView reloadData];
}

- (void)updateTitle
{
    if ([_selectedFriends count]) {
        self.title=[NSString stringWithFormat:@"My Matchmakers (%lu)",(unsigned long)[_selectedFriends count]];
    }
    else
    {
        self.title=@"My Matchmakers";
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger friendsCount=_searchResults.count;
    return friendsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMUMyMatchMakerCell *cell =(SMUMyMatchMakerCell*) [cv dequeueReusableCellWithReuseIdentifier:@"MyMatchMakerCell" forIndexPath:indexPath];
    SMUFriend *_aFriend=_searchResults[indexPath.row];
    [cell setSmuFriend:_aFriend];
    if ([_selectedFriends containsObject:_aFriend])
        cell.isActiveMatchmaker=YES;
    else
        cell.isActiveMatchmaker=NO;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMUFriend *_aFriend=_searchResults[indexPath.row];
    if ([_selectedFriends containsObject:_aFriend]){
        [_selectedFriends removeObject:_searchResults[indexPath.row]];
        SMUMyMatchMakerCell *cell=(SMUMyMatchMakerCell*)[cv cellForItemAtIndexPath:indexPath];
        cell.isActiveMatchmaker=NO;
    }
    else{
        [_selectedFriends addObject:_searchResults[indexPath.row]];
        SMUMyMatchMakerCell *cell=(SMUMyMatchMakerCell*)[cv cellForItemAtIndexPath:indexPath];
        cell.isActiveMatchmaker=YES;
    }
    [self updateTitle];
    [self resetSelectedMM];
}

- (void)collectionView:(UICollectionView *)cv didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchBar.showsCancelButton = NO;
    [self filterData];
}

@end