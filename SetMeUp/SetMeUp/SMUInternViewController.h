//
//  SMUInternViewController.h
//  SetMeUp
//
//  Created by Piramanayagam on 1/30/14.
//  Copyright (c) 2014 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMUInternViewController : UIViewController<UISearchBarDelegate>
{
    NSString *fbAccessToken,*userId;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftNavButton;
- (IBAction)leftNavButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonClick;
- (IBAction)cancelButtonClick:(id)sender;

@property (nonatomic,strong) NSMutableArray *internsDetailsArray;
@property(nonatomic,strong)NSMutableArray *internsNames;
@property(nonatomic,strong)NSMutableArray *internsIDs;


@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (nonatomic,strong) NSMutableArray *searchResult;

@end
