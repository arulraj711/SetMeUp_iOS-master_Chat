//
//  SMUSearchToolViewController.m
//  SetMeUp
//
//  Created by Piramanayagam on 2/3/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import "SMUSearchToolViewController.h"
#import "SMUWebServices.h"
#import "SMUSharedResources.h"
#import "SMUSearchFilter.h"
#import "UIViewController+ITSideMenuAdditions.h"
#import "SMULoggedInUserMenuViewController.h"
#import "ITSideMenuContainerViewController.h"
@interface SMUSearchToolViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *autofillView;
}
@end

@implementation SMUSearchToolViewController
SMUSharedResources *shRes;
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
    _suggestionArr=[[NSMutableArray alloc]init];
    fbAccessToken=[[SMUSharedResources sharedResourceManager] getFbAccessToken];
    userId=[[SMUSharedResources sharedResourceManager] getFbLoggedInUserId];
    
    educationString=@"";
    locationString=@"";
    workplaceString=@"";
    
    _searchDetails=[[NSUserDefaults standardUserDefaults] objectForKey:@"searchDetails"];
    
    //NSLog(@"_searchdetails:%@",_searchDetails);
    if(_searchDetails){
        // NSLog(@"searchDetails:%@",_searchDetails);
        _educationText.text=[_searchDetails objectForKey:@"education"];
        _locationText.text=[_searchDetails objectForKey:@"location"];
        _workPlaceText.text=[_searchDetails objectForKey:@"workplace"];
        
        if([[_searchDetails objectForKey:@"gender"]isEqualToString:@"Male"]){
            [_segmentCtrl setSelectedSegmentIndex:0];
        }else{
            [_segmentCtrl setSelectedSegmentIndex:1];
        }
    }
    [self configureSlider];
    
    shRes=[SMUSharedResources sharedResourceManager];
    
    
}

-(void)prepareViewsWithConnUser{
    
    _suggestionArr = [SMUSharedResources sharedResourceManager].searchResult;
    
    if([_suggestionArr count]==0){
        autofillView.hidden=YES;
    }
    [autofillView reloadData];
    
    
}
-(void)configureSlider{
    
    autofillView=[[UITableView alloc]initWithFrame:CGRectMake(_educationView.frame.origin.x+92, _educationView.frame.size.height+_educationView.frame.origin.y+66, _educationView.frame.size.width-100, 100)];
    [self.view addSubview:autofillView];
    [self.view bringSubviewToFront:autofillView];
    autofillView.dataSource = self;
    autofillView.delegate = self;
    autofillView.rowHeight=30.0f;
    autofillView.hidden=YES;
    //
    self.ageSlider.minimumValue = 0;
    self.ageSlider.maximumValue = 17;
    
    self.ageSlider.lowerValue = 0;
    self.ageSlider.upperValue = 17;
    
    self.ageSlider.minimumRange = 0;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    
    [ self dismissViewAnimation];
    autofillView.hidden=YES;
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = -215;
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    autofillView.hidden=YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    if([substring length]==0){
        autofillView.hidden=YES;
        [_suggestionArr removeAllObjects];
        [autofillView reloadData];
    }else{
        autofillView.hidden=NO;
    }
    
    [self callWebService:substring fortextField:textField];
    
    
    return YES;
}

-(void)callWebService:(NSString *)substring fortextField:(UITextField *)textfield {
    
    autofillView.hidden=YES;
    if(substring.length>2&&substring.length<7){
        autofillView.hidden=NO;
        if([textfield isEqual:_educationText]){
            
            textTag=_educationText.tag;
            CGRect frame=CGRectMake(_educationView.frame.origin.x+93, _educationView.frame.size.height+_educationView.frame.origin.y+66, _educationView.frame.size.width-100, 100);
            
            
            [autofillView setFrame:frame];
            [_suggestionArr removeAllObjects];
            [autofillView reloadData];
            
            [shRes fetchSearchResult:substring withType:@"suggestEducation"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithConnUser) name:@"SearchResultFetched" object:nil];
            
        }
        if([textfield isEqual:_locationText]){
            textTag=_locationText.tag;
            [_suggestionArr removeAllObjects];
            [autofillView reloadData];
            
            CGRect frame=CGRectMake(_locationView.frame.origin.x+93, _locationView.frame.size.height+_locationView.frame.origin.y+66, _locationView.frame.size.width-100, 100);
            
            [autofillView setFrame:frame];
            [_suggestionArr removeAllObjects];
            [autofillView reloadData];
            
            [shRes fetchSearchResult:substring withType:@"suggestLocation"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithConnUser) name:@"SearchResultFetched" object:nil];
            
        }
        if([textfield isEqual:_workPlaceText]){
            
            textTag=_workPlaceText.tag;
            [_suggestionArr removeAllObjects];
            [autofillView reloadData];
            
            CGRect frame=CGRectMake(_workPlaceView.frame.origin.x+93, _workPlaceView.frame.size.height+_workPlaceView.frame.origin.y+66, _workPlaceView.frame.size.width-100, 100);
            
            [autofillView setFrame:frame];
            [_suggestionArr removeAllObjects];
            [autofillView reloadData];
            
            [shRes fetchSearchResult:substring withType:@"suggestWorplace"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsWithConnUser) name:@"SearchResultFetched" object:nil];
        }
        
    }
}
-(void)dismissViewAnimation{
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (IBAction)closeButtonPressed:(id)sender {
    //    [self dismissViewControllerAnimated:YES completion:^{
    //
    //
    //    }];
    
    
    
    _searchFlag=1;
    
    if( gender.length == 0 ){
        gender=@"Male";
    }
    if(minage==0&&maxage==0){
        minage=18;
        maxage=35;
    }
    [self makeDictionaryWithDetails];
    
}
- (IBAction)saveButtonPressed:(id)sender {
    
    //    NSLog(@"gender:%@",gender);
    //    NSLog(@"mingage:%d",minage);
    //    NSLog(@"maxage:%d",maxage);
    //    NSLog(@"education:%@",educationString);
    //    NSLog(@"location:%@",locationString);
    //    NSLog(@"workplace:%@",workplaceString);
    
    
    _searchFlag=1;
    
    if( gender.length == 0 ){
        gender=@"Male";
    }
    if(minage==0&&maxage==0){
        minage=18;
        maxage=35;
    }
    
    [self makeDictionaryWithDetails];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(indicator:) userInfo:nil repeats:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
}

-(void)indicator:(BOOL)animated{
    [autofillView flashScrollIndicators];
    
}
-(void)makeDictionaryWithDetails{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSString *startage=[NSString stringWithFormat:@"%d",minage];
    NSString *endage=[NSString stringWithFormat:@"%d",maxage];
    NSString *searchFlag=[NSString stringWithFormat:@"%d",_searchFlag];
    //    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:picUrl];
    //    [def setObject:data1 forKey:@"pictureUrl"];
    
    [dict setObject:educationString forKey:@"education"];
    [dict setObject:locationString forKey:@"location"];
    [dict setObject:startage forKey:@"minage"];
    [dict setObject:endage forKey:@"maxage"];
    [dict setObject:gender forKey:@"gender"];
    [dict setObject:workplaceString forKey:@"workplace"];
    [dict setObject:searchFlag forKey:@"searchFlag"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:dict forKey:@"searchDetails"];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchCriteriaRetrived" object:nil userInfo:nil];
        
    }];
    
}
- (IBAction)ageValueChanged:(NMRangeSlider *)sender {
    
    [ self updateSliderLabels];
}
-(void)updateSliderLabels{
    
    minage=(int)self.ageSlider.lowerValue+18;
    maxage=(int)self.ageSlider.upperValue+18;
    
    self.ageChangelbl.text=[NSString stringWithFormat:@"%d-%d",minage,maxage];
}
- (IBAction)segmentChanged:(id)sender {
    
    if(_segmentCtrl.selectedSegmentIndex==1){
        
        gender=@"Female";
    }else{
        gender=@"Male";
    }
    //NSLog(@"gender in segment:%@",gender);
}
#pragma tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"suggest count:%d",[_suggestionArr count]);
    return [_suggestionArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    SMUSearchFilter *filterObj = (SMUSearchFilter *)[_suggestionArr objectAtIndex:indexPath.row];
    cell.textLabel.text=filterObj.value;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *settingCell = [[UITableViewCell alloc] init];
    settingCell = (UITableViewCell *) [autofillView cellForRowAtIndexPath:indexPath];
    
    if(textTag==0){
        _educationText.text=settingCell.textLabel.text;
        educationString=settingCell.textLabel.text;
    }if (textTag==1) {
        _locationText.text=settingCell.textLabel.text;
        locationString=settingCell.textLabel.text;
    }if(textTag==2){
        _workPlaceText.text=settingCell.textLabel.text;
        workplaceString=settingCell.textLabel.text;
    }
    autofillView.hidden=YES;
    [_suggestionArr removeAllObjects];
    [self dismissViewAnimation];
    //NSLog(@"texttag:%d",textTag);
    [self.view endEditing:YES];
}

- (IBAction)resetButtonPressed:(id)sender {
    
    
    autofillView.hidden=YES;
    _educationText.text=@"";
    _locationText.text=@"";
    _workPlaceText.text=@"";
    
    self.ageSlider.minimumValue = 0;
    self.ageSlider.maximumValue = 17;
    
    self.ageSlider.lowerValue = 0;
    self.ageSlider.upperValue = 17;
    
    self.ageSlider.minimumRange = 0;
    self.ageChangelbl.text=[NSString stringWithFormat:@"%d-%d",18,35];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchDetails"];
}
@end
