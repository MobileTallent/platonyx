//
//  WFUserBaseViewController.m
//  Woof
//
//  Created by Mac on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "UserBaseViewController.h"

@interface UserBaseViewController ()

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
        appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
//        [self.navigationController presentViewController:panelController animated:NO completion: nil];
        [self.navigationController pushViewController:panelController animated:NO]; //:panelController animated:NO completion: nil];
        
        return;
        
    }
    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
        [commonUtils removeUserDefault:@"logged_out"];
//        [[FBSession activeSession] closeAndClearTokenInformation];
//        [FBSession setActiveSession:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    self.isLoadingUserBase = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

#pragma mark - Nagivate Events
- (void) navToMainView {
    appController.currentMenuTag = @"1";
    MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
    [self.navigationController presentViewController:panelController animated:YES completion: nil];
}

@end
