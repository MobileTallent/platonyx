//
//  RePassViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/9/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "RePassViewController.h"

@interface RePassViewController ()
@property (strong, nonatomic) IBOutlet UIButton *getPassBtn;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;

@end

@implementation RePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils cropCircleButton:_getPassBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onRetrivePass:(id)sender {
    
    if([commonUtils isFormEmpty:[@[self.emailTxt.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"" body:@"Lütfen e-posta adresinizi girin" duration:1.2];
    } else if(![commonUtils validateEmail:self.emailTxt.text]) {
        [commonUtils showVAlertSimple:@"" body:@"E-posta adresinizde bir takım yanlışlıklar var" duration:1.2];
    } else {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:self.emailTxt.text forKey:@"user_email"];
        [self requestAPI:paramDic];
    }
}

#pragma mark - API Request - User Retrieve Password
- (void)requestAPI:(NSMutableDictionary *)dic {

    [commonUtils showActivityIndicatorThird:self.view];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}
- (void)requestData:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_RETRIEVE_PASSWORD withJSON:(NSMutableDictionary *) params];

    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] >= 1) {
            [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Lütfen formun tamamını doldurunuz";
            [commonUtils showVAlertSimple:@"Hata" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Bağlantı Hatası" body:@"Lütfen internet bağlantınızı kontrol ediniz" duration:1.0];
    }
}
- (void)requestOver {
    [self.emailTxt resignFirstResponder];
    [appController.vAlert doAlert:@"Success"
                             body:@"Yeni şifreniz e-posta adresinize gönderildi"
                         duration:1.5f
                             done:^(DoAlertView *alertView) {
                                 [self.navigationController popViewControllerAnimated:YES];
                                 return;
                             }
     ];
}



@end
