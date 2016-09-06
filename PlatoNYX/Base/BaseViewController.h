//
//  WFBaseViewController.h
//  Woof
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingBase;

@property (nonatomic, strong) IBOutlet UIView *topNavBarView, *containerView, *noContentView;

- (IBAction)menuClicked:(id)sender;
- (IBAction)menuBackClicked:(id)sender;
- (IBAction)menuPostBarkClicked:(id)sender;
@end
