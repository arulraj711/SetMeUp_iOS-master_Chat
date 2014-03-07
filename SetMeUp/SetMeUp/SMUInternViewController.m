//
//  SMUInternViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUInternViewController.h"
#import "SMUSharedResources.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "ITSideMenuContainerViewController.h"
#import "SMUInterns.h"
#import "SMUInternsCell.h"
#import "SMUWebServices.h"
@interface SMUInternViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)saveInterns:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *saveButtonView;

@end

@implementation SMUInternViewController

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
    
  
    
	// Do any additional setup after loading the view.
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    [shRes fetchInternUsers];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithConnUser) name:@"InternDetailsFetched" object:nil];

}
-(void)prepareViewsWithConnUser{
    
    _internsDetailsArray=[[NSMutableArray alloc]init];
     _selectedArray=[[NSMutableArray alloc]init];
     _searchResult=[[NSMutableArray alloc]init];
    _internsDetailsArray=[[SMUSharedResources sharedResourceManager]internDetails];
    
    [_searchResult addObjectsFromArray:_internsDetailsArray];

    [_collectionView reloadData];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftNavButtonClick:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)saveInterns:(id)sender {
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    SMUInterns *interns=(SMUInterns *)[_selectedArray objectAtIndex:0];
    [SMUWebServices saveInternsWithAccessToken:fbAccessToken forUserId:userId withInternId:interns.InternId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
  //  NSLog(@"count :%d",_searchResult.count);
    NSInteger friendsCount=_searchResult.count;
    return friendsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"cming into cellforItem");
    SMUInternsCell *cell =(SMUInternsCell*) [cv dequeueReusableCellWithReuseIdentifier:@"InternsCell" forIndexPath:indexPath];
    SMUInterns *_aFriend=_searchResult[indexPath.row];
    [cell setInterns:_aFriend];
//    if([_selectedArray containsObject:_aFriend]){
//        cell.isSelected=YES;
//    }
//    else{
//        cell.isSelected=NO;
//    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   //  SMUInternsCell *cell=(SMUInternsCell*)[cv cellForItemAtIndexPath:indexPath];
    
    SMUInternsCell *cell=(SMUInternsCell*)[cv cellForItemAtIndexPath:indexPath];
    
   SMUInterns *_aFriend=_searchResult[indexPath.row];

    [_selectedArray addObject:_aFriend];
    

    cell.isSelected=YES;
}

- (void)collectionView:(UICollectionView *)cv didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SMUInternsCell *cell=(SMUInternsCell*)[cv cellForItemAtIndexPath:indexPath];
    
    SMUInterns *_aFriend=_searchResult[indexPath.row];
    
    [_selectedArray removeObject:_aFriend];
     cell.isSelected=NO;
}

- (void)filterData {
    if ([_searchBar.text length]==0) {
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:_internsDetailsArray];
    }
    else{
        
       // NSLog(@"search bar text:%@",_searchBar.text);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.InternName contains[cd] %@", _searchBar.text];
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:[_internsDetailsArray filteredArrayUsingPredicate:predicate]];
    }
    [_collectionView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //NSLog(@"coming into textdidchagne");
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
