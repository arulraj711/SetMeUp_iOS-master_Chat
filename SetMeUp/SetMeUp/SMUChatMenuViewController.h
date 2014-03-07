//
//  SMUChatMenuViewController.h
//  SetMeUp
//
//  Created by Go on 12/12/13.
//  Copyright (c) 2013 IndiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMUChatMenuViewController : UIViewController<UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    UISearchBar *connSearchBar;
    UIView * comboView;
    UIPanGestureRecognizer *tap;
}
@property (nonatomic,strong) NSMutableArray *savedArray;
@property (nonatomic,strong) NSMutableArray *connUserArray;
@property (nonatomic,strong) NSMutableArray *chatListArray;
@property (assign) BOOL isSearched;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic,strong) IBOutlet UISearchBar *connUserSearch;
@end
