//
//  ContactViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/23/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController () <UITextViewDelegate>{
    
    IBOutlet UIButton *submitBtn;
    IBOutlet UILabel *placeholderText;
    IBOutlet UITextField *subjectText;
    IBOutlet UITextView *contentTextView;
}

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [commonUtils cropCircleButton:submitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    placeholderText.hidden = YES;
}

- (IBAction)onSendBtn:(id)sender {
    if([contentTextView.text length] < 550) {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
        [paramDic setObject:subjectText.text forKey:@"subject"];
        [paramDic setObject:contentTextView.text forKey:@"content"];
        
        NSLog(@"paramDic : %@", paramDic);
        
        [self.view endEditing:YES];
    
        [self requestAPIPost:paramDic];
    }else{
        [commonUtils showVAlertSimple:@"Uyarı" body:@"İçerik 550 karakter sınırını geçmemelidir." duration:1.2];
    }
}


#pragma mark - API Request - get Latest Settings Dictionary
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_CONTACT withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            NSLog(@"%@", [result objectForKey:@"msg"]);
            
            [self performSelector:@selector(requestOverPost) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Lütfen formun tamamını doldurunuz";
            [commonUtils showVAlertSimple:@"Hata" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Bağlantı Hatası" body:@"Lütfen internet bağlantınızı kontrol ediniz" duration:1.0];
    }
}

- (void)requestOverPost {
    [commonUtils showVAlertSimple:@"" body:@"Başarıyla gönderildi." duration:1.0];
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
