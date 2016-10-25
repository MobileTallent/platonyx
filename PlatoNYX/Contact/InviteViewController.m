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
    IBOutlet UITextField *emailInputTxt;
    IBOutlet UILabel *invitelimitTxt;
}

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [commonUtils cropCircleButton:submitBtn];
    if([[appController.currentUser objectForKey:@"user_invite_limit"] intValue] < 1)
    {
        [commonUtils showVAlertSimple:@"" body:@"Bu ayki kotanız doldu." duration:1.0];
    }
}

- (void)initData {
    invitelimitTxt.text = [[NSString alloc] initWithFormat:@"Bu ay içinde kalan davet hakkınız: %@", [appController.currentUser objectForKey:@"user_invite_limit"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendBtn:(id)sender {
    if([[appController.currentUser objectForKey:@"user_invite_limit"] intValue] < 1)
    {
        [commonUtils showVAlertSimple:@"" body:@"Bu ayki kotanız doldu." duration:1.0];
    }else{
        if([emailInputTxt.text isEqualToString:@""]){
            [commonUtils showVAlertSimple:@"" body:@"Lütfen formun tamamını doldurunuz." duration:1.0];
        }else{
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
            [paramDic setObject:emailInputTxt.text forKey:@"to_email"];
            
            NSLog(@"paramDic : %@", paramDic);
            [self.view endEditing:YES];
            [self requestAPIPost:paramDic];
        }
    }
}


#pragma mark - API Request - get Latest Settings Dictionary
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_INVITE withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [[result objectForKey:@"current_user"] mutableCopy];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            NSLog(@"%@", [result objectForKey:@"msg"]);
            
            [self performSelector:@selector(requestOverPost) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        }else if([status intValue] == 2){
            [commonUtils showVAlertSimple:@"Hata" body:@"Bu e-posta adresine zaten bir davet gitmiş." duration:1.0];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Lütfen formun tamamını doldurunuz.";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Bağlantı Hatası" body:@"Lütfen internet bağlantınızı kontrol ediniz" duration:1.0];
    }
}

- (void)requestOverPost {
    [commonUtils showVAlertSimple:@"" body:@"Başarıyla gönderildi." duration:1.0];
    [self initData];
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
