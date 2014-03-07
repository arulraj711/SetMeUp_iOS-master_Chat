//
//  SMUUserAEditViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 1/21/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SMUUserAEditViewController.h"
#import "SMUUserAPicture.h"
#import "SMUProfilePictureCell.h"
#import "SMUUserProfile.h"
#import "SMUWebServices.h"
#import "SMUUserProfile.h"

@interface SMUUserAEditViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIActionSheetDelegate>
- (IBAction)backButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userAName;

@property(nonatomic,strong) UICollectionViewController *profilePitureAlbumCollectionVC;
@end

@implementation SMUUserAEditViewController

SMUUserProfile *userProfileObj;


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
    [self getDetailsToLoadView];
    
    
	// Do any additional setup after loading the view.
}

-(void)getDetailsToLoadView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaults objectForKey:@"selectedProfilePicture"];
    selectedURL = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    
    SMUSharedResources *shRes=[SMUSharedResources sharedResourceManager];
    
    [shRes fetchUserProfilePictures];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadProfilePictures) name:@"ProfilePicturesRetrieved" object:nil];
    
    
    
    _userProfile=[userProfileObj loadCustomObjectWithKey:@"UserInfo"];
    _isSelectedUser = NO;
    [self setBorderColorforTextfield];
    [self updateViewWithUserProfile:_userProfile];
    _selectedPicture=[[NSMutableArray alloc]init];
    

}
-(void)loadProfilePictures{
    
    _profilePictureAlbum=[[SMUSharedResources sharedResourceManager]profilPictureAlbum];
    [_profilePitureAlbumCollectionVC.collectionView reloadData];
}

-(void)setBorderColorforTextfield{
    
    _dateOfBirthText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _dateOfBirthText.layer.borderWidth=1.0f;
    
    _educationText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _educationText.layer.borderWidth=1.0f;
    
    _locationText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _locationText.layer.borderWidth=1.0f;
    
    _occupationText.layer.borderColor=[[UIColor whiteColor] CGColor];
    _occupationText.layer.borderWidth=1.0f;
}
-(void)updateViewWithUserProfile:(SMUUserProfile *)userProfile{
    
   // _userAName.text=userProfile.firstName;
    _educationText.text=userProfile.education;
    _locationText.text=userProfile.location;
    _occupationText.text=userProfile.workplace;
    _dateOfBirthText.text=userProfile.dateOfBirth;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    
    [ self dismissViewAnimation];
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = -215;
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
    if([textField isEqual:_dateOfBirthText]){
        
        
        
        [self setDatebirth];
    }
    
}
-(void)dismissViewAnimation{
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(void)setDatebirth{
    
    actionsheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionsheet setActionSheetStyle:UIActionSheetStyleDefault];
    CGRect pickerFrame=CGRectMake(0, 35, 0, 0);
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:pickerFrame];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate:[NSDate date]];
    [actionsheet addSubview:datePicker];
    UIToolbar *ctrltoolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, actionsheet.bounds.size.width, 0)];
    [ctrltoolbar setBarStyle:UIBarStyleDefault];
    [ctrltoolbar sizeToFit];
    UIBarButtonItem *spacebar=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *setButton=[[UIBarButtonItem alloc]initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateSet:)];
    UIBarButtonItem *cancelButton  =[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDateSet:)];
    [ctrltoolbar setItems:[NSArray arrayWithObjects:spacebar,setButton,cancelButton, nil]];
    [actionsheet addSubview:ctrltoolbar];
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
   // [actionsheet showInView:self.view];
    [actionsheet setBounds:CGRectMake(0, 0, 320, 480)];
}

-(void)dismissDateSet:(id)sender{
    NSArray *listofarr=[actionsheet subviews];
    for (UIView *subView in listofarr) {
        if([subView isKindOfClass:[UIDatePicker class]]){
            self.birthdate=[(UIDatePicker *)subView date];
        }
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd', 'yyyy "];
    //NSLog(@"%@",self.birthdate);
    [_dateOfBirthText setText:[dateFormatter stringFromDate:self.birthdate]];
    [ self dismissViewAnimation];
    [_dateOfBirthText resignFirstResponder];
    [actionsheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)cancelDateSet:(id)sender{
    [actionsheet dismissWithClickedButtonIndex:0 animated:YES];
    [ self dismissViewAnimation];
    [_dateOfBirthText resignFirstResponder];
    
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
    if ([segue.identifier isEqualToString:@"ProfilePictureSegue"]) {
        _profilePitureAlbumCollectionVC=aCollectionVC;
    }
}
#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSUInteger collectionCellsCount;
    
    collectionCellsCount = _profilePictureAlbum.count;
    return collectionCellsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if ([_profilePitureAlbumCollectionVC.collectionView isEqual:cv]) {
        
        SMUProfilePictureCell *localCell =(SMUProfilePictureCell*) [cv dequeueReusableCellWithReuseIdentifier:@"SMUProfilePictureCell" forIndexPath:indexPath];
        
        SMUUserAPicture *profileObj=[_profilePictureAlbum objectAtIndex:indexPath.row];
        [localCell setProfilePicture:profileObj];
        if(!_isSelectedUser) {
            [_selectedPicture removeAllObjects];
            [_selectedPicture addObject:selectedURL];
        }
        NSString *imgURL = profileObj.picUrl;
        if([_selectedPicture containsObject:imgURL]){
            localCell.isSelectedImage=YES;
        }else{
            localCell.isSelectedImage=NO;
        }
        
        cell=localCell;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   // NSLog(@"didselect");
    SMUProfilePictureCell *cell=(SMUProfilePictureCell*)[collectionView cellForItemAtIndexPath:indexPath];
    SMUUserAPicture *profileObj=[_profilePictureAlbum objectAtIndex:indexPath.row];
    [_selectedPicture removeAllObjects];
    selectedURL = profileObj.picUrl;
    [_selectedPicture addObject:profileObj.picUrl];
    cell.isSelectedImage=YES;
    _isSelectedUser = YES;
    [_profilePitureAlbumCollectionVC.collectionView reloadData];
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SMUProfilePictureCell *cell=(SMUProfilePictureCell*)[collectionView cellForItemAtIndexPath:indexPath];
    SMUUserAPicture *profileObj=[_profilePictureAlbum objectAtIndex:indexPath.row];
    [_selectedPicture removeObject:profileObj.picUrl];
    cell.isSelectedImage=NO;
    
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
    
    dataSourceCount = _profilePictureAlbum.count;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)fbSyncBtn:(id)sender {
    
    [[SMUSharedResources sharedResourceManager] showProgressHUDForView];
    
    
    [SMUWebServices faceBookSyncProcessWithAccessToken:fbAccessToken forUserId:userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SMUUserProfile *profile=(SMUUserProfile *)responseObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileInformationRetrieved" object:nil userInfo:@{@"UserProfile": profile}];
        [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (IBAction)saveBtn:(id)sender {
    
    [self createJSON];
   // NSLog(@"json string:%@",jsonString);
    [[SMUSharedResources sharedResourceManager] showProgressHUDForView];
    [SMUWebServices saveProfileInfoWithAccessToken:fbAccessToken forUserId:userId withProfileString:jsonString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SMUUserProfile *profile=(SMUUserProfile *)responseObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileInformationRetrieved" object:nil userInfo:@{@"UserProfile": profile}];
        [[SMUSharedResources sharedResourceManager] hideProgressHUDForView];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(NSString *)addslashSingleQuoteForString:(NSString *)str{
   
    NSString *newString=[str stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
   
    return newString;
}
-(void)createJSON {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *education=_educationText.text;
    NSString *location=_locationText.text;
    NSString *occupation=_occupationText.text;
    NSString *dob=_dateOfBirthText.text;
    NSString *picUrl=selectedURL;
    
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:picUrl];
//    [def setObject:data1 forKey:@"pictureUrl"];
    
    [dict setObject:picUrl forKey:@"pic_id"];
    [dict setObject:location forKey:@"location"];
    [dict setObject:dob forKey:@"birthday"];
    [dict setObject:education forKey:@"school"];
    [dict setObject:occupation forKey:@"workplace"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                    error:&error];
    if (! jsonData){
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
}

- (IBAction)previewBtn:(id)sender {
    
    if(![_selectedPicture count]==0){
        _profilePicture=(SMUUserAPicture *)[_selectedPicture objectAtIndex:0];
    }
    else{
        _profilePicture=(SMUUserAPicture *)[_profilePictureAlbum objectAtIndex:0];
    }
    
    
    NSString *picUrl=_profilePicture.picUrl;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:picUrl];
    [def setObject:data1 forKey:@"pictureUrl"];
    
    UINavigationController  *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SMUPreviewViewController"];
    [self presentViewController:navigationController animated:YES completion:nil];
    //    SMUPreviewViewController *previewPage=[self.storyboard instantiateViewControllerWithIdentifier:@"SMUPreviewViewController"];
    //    [self.navigationController pushViewController:previewPage animated:YES];
    
}
@end
