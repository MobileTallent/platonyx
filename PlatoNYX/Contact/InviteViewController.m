//
//  InviteViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 9/27/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController () {
    
    IBOutlet UIButton *submitBtn;
    
}

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [commonUtils cropCircleButton:submitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
