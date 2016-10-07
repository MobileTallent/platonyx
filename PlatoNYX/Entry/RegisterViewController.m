//
//  RegisterViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/4/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "RegisterViewController.h"
#import "EntryWebViewController.h"

@interface RegisterViewController ()

@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) IBOutlet UITextField *referCodeTxt;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;
@property (strong, nonatomic) IBOutlet UITextField *usernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *psssTxt;
@property (strong, nonatomic) IBOutlet UITextField *repassTxt;

@property (strong, nonatomic) IBOutlet UILabel *pp_label;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [commonUtils cropCircleButton:_registerBtn];

//    [self buildAgreeTextViewFromString:@"Kayıt Ol tuşuna basarak #<ts>Kullanıcı Sözleşmesi# ve #<pp>Gizlilik Sözleşmesi#’ni kabul etmiş olursunuz."];

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"Kayıt Ol tuşuna basarak Kullanıcı Sözleşmesi ve Gizlilik Sözleşmesi’ni kabul etmiş olursunuz."];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[appController appMainColor] range:NSMakeRange(24,21)];
    
    
    [string addAttribute:NSForegroundColorAttributeName value:[appController appMainColor] range:NSMakeRange(48,20)];
    _pp_label.attributedText = string;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toSign:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRegister:(id)sender {
    if([commonUtils getUserDefault:@"currentLatitude"] != nil && [commonUtils getUserDefault:@"currentLongitude"] != nil) {
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
            
            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_long"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_lati"];
            
            if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
                [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
                
                NSLog(@"apns_id = %@", [commonUtils getUserDefault:@"user_apns_id"]);
            } else {
                [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
                }];
            }
            
            [self requestAPISignUp:paramDic];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location is required to share and discover content"
                                                        message:@"You must allow \"PlatoNYX\" to access your location to use this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Go to Settings"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - API Request - User Sign Up
- (void)requestAPISignUp:(NSMutableDictionary *)dic {

    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataSignUp:) toTarget:self withObject:dic];
}
- (void)requestDataSignUp:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    [commonUtils hideActivityIndicator];

    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            NSLog(@"current user : %@", appController.currentUser);
            
            appController.currentUserSettings = [result objectForKey:@"user_settings"];
            
            NSLog(@"currentUserSettings : %@", appController.currentUserSettings);

            [commonUtils setUserDefaultDic:@"currentUserSettings" withDic:appController.currentUserSettings];
            
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

- (IBAction)onTerms:(id)sender {
    EntryWebViewController* myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EntryWebViewController"];
    myController.UrlString = @"http://www.platonyx.com/kullanici-sozlesmesi/";
    [self.navigationController pushViewController:myController animated:YES];
}

- (IBAction)onPolicy:(id)sender {
    EntryWebViewController* myController = [self.storyboard instantiateViewControllerWithIdentifier:@"EntryWebViewController"];
    myController.UrlString =@"http://www.platonyx.com/gizlilik-sozlesmesi/";
    [self.navigationController pushViewController:myController animated:YES];
}

@end
