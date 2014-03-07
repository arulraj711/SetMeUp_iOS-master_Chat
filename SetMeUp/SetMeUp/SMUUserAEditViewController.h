//
//  SMUUserAEditViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/21/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMUSharedResources.h"
#import "SMUWebServices.h"
#import "SMUUserProfile.h"
#import "SMUUserAPicture.h"
#import "SMUPreviewViewController.h"
@interface SMUUserAEditViewController : UIViewController
{
    int scroll_value;
    NSString *jsonString,*fbAccessToken,*userId;
      UIActionSheet *actionsheet;
    NSString *selectedURL;
}
@property (nonatomic,strong)NSMutableArray *profilePictureAlbum;
@property (nonatomic,strong)NSMutableArray *selectedPicture;
@property(nonatomic,strong)SMUUserProfile *userProfile;
@property(nonatomic,strong)SMUUserAPicture *profilePicture;
@property(assign) int defaultUrl;
@property (weak, nonatomic) NSDate *birthdate;
- (IBAction)fbSyncBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *educationText;

@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthText;
@property(nonatomic, readwrite) BOOL isSelectedUser;
@property (weak, nonatomic) IBOutlet UITextField *occupationText;
- (IBAction)saveBtn:(id)sender;
- (IBAction)previewBtn:(id)sender;


-(void)setDatebirth;
-(void)dismissDateSet:(id)sender;
-(void)cancelDateSet:(id)sender;


@end
