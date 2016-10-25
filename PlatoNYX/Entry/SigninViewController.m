//
//  SigninViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/4/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "SigninViewController.h"
#import "RegisterViewController.h"
#import "RePassViewController.h"

@interface SigninViewController () <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    UITextField *currentTextField;
}

@property (nonatomic, strong) IBOutlet UIScrollView *containerScrollView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;
@property (strong, nonatomic) IBOutlet UITextField *passTxt;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils cropCircleButton:_loginBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
//    if(![commonUtils validateEmail:self.emailTxt.text]) {
//        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format" duration:1.2];
//    } else
//    if([commonUtils getUserDefault:@"currentLatitude"] != nil && [commonUtils getUserDefault:@"currentLongitude"] != nil) {
        if([self.passTxt.text length] < 6 || [self.passTxt.text length] > 10) {
            [commonUtils showVAlertSimple:@"" body:@"Şifre uzunluğu 6 ile 10 karakter arasında olmalı" duration:1.2];
        } else {
            
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [paramDic setObject:self.emailTxt.text forKey:@"user_email"];
            [paramDic setObject:[commonUtils md5:self.passTxt.text] forKey:@"user_password"];
            
//            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_long"];
//            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_lati"];
            
//            if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
//                [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
//                
//                NSLog(@"apns_id = %@", [commonUtils getUserDefault:@"user_apns_id"]);
//            } else {
//                [appController.vAlert doAlert:@"" body:@"Donanım anahtarınız (Device Token) alınamadı. Bu yüzden yeni etkinlikler için uyarı alamayacaksınız." duration:2.0f done:^(DoAlertView *alertView) {
//                }];
//            }
            [self requestAPILogin:paramDic];
        }
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"İçeriği keşfetmeniz ve paylaşmanız için lokasyon bilginiz gerekli."
//                                                        message:@"\"PlatoNYX\" uygulamasının lokasyon bilginizi almasına izin vermeniz gerekiyor."
//                                                       delegate:self
//                                              cancelButtonTitle:@"Go to Settings"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
}

#pragma mark - API Request - User Login
- (void)requestAPILogin:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataLogin:) toTarget:self withObject:dic];
}
- (void)requestDataLogin:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGIN withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            NSLog(@"currentUser :%@", appController.currentUser);

            appController.currentUserSettings = [result objectForKey:@"user_settings"];
            NSLog(@"currentUserSettings : %@", appController.currentUserSettings);
            
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            [commonUtils setUserDefaultDic:@"currentUserSettings" withDic:appController.currentUserSettings];
            
            [self performSelector:@selector(requestOverLogin) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            msg = @"E-posta adresiniz ile şifreniz birbirini tutmuyor";
            [commonUtils showVAlertSimple:@"Hata" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Bağlantı Hatası" body:@"Lütfen internet bağlantınızı kontrol ediniz" duration:1.0];
    }
}

- (void)requestOverLogin {
    MySidePanelController* mysideController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
//    [self presentViewController:mysideController animated:YES completion:nil];
    [self.navigationController pushViewController:mysideController animated:YES];
}

- (IBAction)toSignUp:(id)sender {
//    RegisterViewController * myController = [self.storyboard instantiateViewControllerWithIdentifier:@"registerPanel"];
//    [self presentViewController:myController animated:YES completion:nil];
//    [self.navigationController pushViewController:myController animated:YES];
    [self performSegueWithIdentifier:@"toSignupSegue" sender:nil];
}

- (IBAction)onRetrievePass:(id)sender {
//    RePassViewController * myController = [self.storyboard instantiateViewControllerWithIdentifier:@"RePassViewController"];
//    [self presentViewController:myController animated:YES completion:nil];
//    [self.navigationController pushViewController:myController animated:YES];
    [self performSegueWithIdentifier:@"toPassSegue" sender:nil];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(self.isLoadingUserBase) return NO;
    currentTextField = textField;
    float offset = 0;
    if(currentTextField == self.emailTxt) {
        offset = 60;
    } else if(currentTextField == self.passTxt) {
        offset = 120;
    }
    [self.containerScrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.isLoadingUserBase) return NO;
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return [textField resignFirstResponder];
}

#pragma mark - ScrollView Tap
- (void) onTappedScreen {
    [currentTextField resignFirstResponder];
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


@end
