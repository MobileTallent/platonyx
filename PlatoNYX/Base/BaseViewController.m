//
//  WFBaseViewController.m
//  Woof
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "BaseViewController.h"
#import "NotiListViewController.h"
//#import "CustomCameraViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(![commonUtils checkKeyInDic:@"user_id" inDic:appController.currentUser] || ![commonUtils checkKeyInDic:@"user_photo_url" inDic:appController.currentUser] || ![commonUtils checkKeyInDic:@"user_name" inDic:appController.currentUser]) {
        if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
            appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.isLoadingBase = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"ReceiveNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

# pragma Top Menu Events
- (IBAction)menuClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self.sidePanelController showLeftPanelAnimated: YES];
}
- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuNotiClicked:(id)sender {
    if(self.isLoadingBase) return;
    
    NotiListViewController *mainViewController;
    UINavigationController *navController;
    
    mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"notiListVC"];
    navController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
    self.sidePanelController.centerPanel = navController;
}

//- (IBAction)menuPostBarkClicked:(id)sender {
//    if(self.isLoadingBase) return;
//    
//    CustomCameraViewController *customCamera = nil;
//    customCamera = [[CustomCameraViewController alloc] initWithNibName:@"CustomCameraViewController" bundle:nil];
//    UINavigationController *navView = [[UINavigationController alloc] initWithRootViewController:customCamera];
//    navView.navigationBarHidden = YES;
//    [self presentViewController:navView animated:YES completion:nil];
//    
//}

//- (void) receivedNotification:(NSNotification *) notification {
//    NSDictionary *dic = notification.userInfo;
//}
//
@end
