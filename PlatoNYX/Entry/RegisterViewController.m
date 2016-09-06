//
//  RegisterViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/4/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) IBOutlet UITextField *referCodeTxt;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;
@property (strong, nonatomic) IBOutlet UITextField *usernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *psssTxt;
@property (strong, nonatomic) IBOutlet UITextField *repassTxt;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [commonUtils cropCircleButton:_registerBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    if(self.isLoadingUserBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toSign:(id)sender {
    if(self.isLoadingUserBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRegister:(id)sender {
    
    if(self.isLoadingUserBase) return;
    
    if([commonUtils isFormEmpty:[@[self.referCodeTxt.text, self.emailTxt.text, self.usernameTxt.text, self.psssTxt.text, self.repassTxt.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
    } else if([self.usernameTxt.text length] > 20) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Your first name is too long" duration:1.2];
    } else if([self.referCodeTxt.text length] < 8 || [self.psssTxt.text length] > 8) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Reference code length should be 8." duration:1.2];
    } else if(![commonUtils validateEmail:self.emailTxt.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format." duration:1.2];
    } else if([self.psssTxt.text length] < 6 || [self.psssTxt.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length should be 6 to 10." duration:1.2];
    } else if(![self.psssTxt.text isEqualToString:self.repassTxt.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password confirm does not match." duration:1.2];
    } else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:@"1" forKey:@"signup_mode"];

        [paramDic setObject:self.referCodeTxt.text forKey:@"user_reference"];
        [paramDic setObject:self.emailTxt.text forKey:@"user_email"];
        [paramDic setObject:self.usernameTxt.text forKey:@"user_name"];
        [paramDic setObject:[commonUtils md5:self.psssTxt.text] forKey:@"user_password"];
        
        [self requestAPISignUp:paramDic];
    }
}

#pragma mark - API Request - User Sign Up
- (void)requestAPISignUp:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataSignUp:) toTarget:self withObject:dic];
}
- (void)requestDataSignUp:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];

    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            NSLog(@"current user : %@", appController.currentUser);
            [self performSelector:@selector(requestOverSignup) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status." duration:1.0];
    }
}

- (void)requestOverSignup {
    MySidePanelController* mysideController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
    [self.navigationController pushViewController:mysideController animated:YES];
}

@end
