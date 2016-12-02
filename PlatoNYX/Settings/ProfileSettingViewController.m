//
//  ProfileSettingViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 9/8/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ProfileSettingViewController.h"
#import "ActivitySettingViewController.h"
#import "PreferenceViewController.h"

@interface ProfileSettingViewController () <UIActionSheetDelegate> {
    
    // UI
    IBOutlet UIView *activitySettingView;
    IBOutlet UIView *preferenceView;
    IBOutlet UIScrollView *profileSettingView;
    
    IBOutlet UIButton *tab1Btn;
    IBOutlet UIButton *tab2Btn;
    IBOutlet UIButton *tab3Btn;
    
    IBOutlet UIButton *birthDateBtn;
    IBOutlet UIButton *genderBtn;
    IBOutlet UIButton *cityBtn;
    IBOutlet UIButton *educationBtn;
    
    IBOutlet UIButton *incomeBtn;
    IBOutlet UIButton *sexOrientBtn;
    
    IBOutlet UILabel *birthDatelbl;
    IBOutlet UILabel *genderlbl;
    IBOutlet UILabel *citylbl;
    IBOutlet UILabel *educationlbl;
    IBOutlet UILabel *incomelbl;
    IBOutlet UILabel *sexOrienlbl;
    
    IBOutlet UITextField *oldPassTxt;
    IBOutlet UITextField *newPassTxt;
    IBOutlet UITextField *confirmPassTxt;
    
    IBOutlet UIButton *saveBtn;
    
    // Data
    NSArray *genderArray;
    NSArray *cityArray;
    NSArray *educationArray;
    NSArray *incomeArray;
    NSArray *sexOrientationArray;
    
    NSString *dateString;
    
    NSDateFormatter *dateFormatter;
    
    NSMutableDictionary *actSettingsDic;
    
    IBOutlet UITextView *aboutTxtView;
    
}
@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    activitySettingView.hidden = YES;
    preferenceView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    
    genderArray = [[NSMutableArray alloc] init];
    genderArray = [@[
                     [@{@"tag" : @"1", @"text" : @"Kadın"} mutableCopy],
                     [@{@"tag" : @"2", @"text" : @"Erkek"} mutableCopy]
                     ] mutableCopy];
    cityArray = [[NSMutableArray alloc] init];
    cityArray = [@[
                   [@{@"tag" : @"1", @"text" : @"İstanbul"} mutableCopy],
                   [@{@"tag" : @"2", @"text" : @"Ankara"} mutableCopy],
                   [@{@"tag" : @"3", @"text" : @"İzmir"} mutableCopy]
                   ] mutableCopy];
    educationArray = [[NSMutableArray alloc] init];
    educationArray = [@[
                    [@{@"tag" : @"1", @"text" : @"Lise Mezunu"} mutableCopy],
                    [@{@"tag" : @"2", @"text" : @"Üniv. Mezunu"} mutableCopy],
                    [@{@"tag" : @"3", @"text" : @"Y. Lisans"} mutableCopy],
                    [@{@"tag" : @"4", @"text" : @"Doktora"} mutableCopy]                    ] mutableCopy];
    incomeArray = [[NSMutableArray alloc] init];
    incomeArray = [@[
                     [@{@"tag" : @"1", @"text" : @"0-2.000 TL"} mutableCopy],
                     [@{@"tag" : @"2", @"text" : @"2.000-6.000 TL"} mutableCopy],
                     [@{@"tag" : @"3", @"text" : @"6.000-10.000 TL"} mutableCopy],
                     [@{@"tag" : @"4", @"text" : @"+10,000 TL"} mutableCopy]
                     ] mutableCopy];
    sexOrientationArray = [[NSMutableArray alloc] init];
    sexOrientationArray = [@[
                             [@{@"tag" : @"1", @"text" : @"Heteroseksüel"} mutableCopy],
                             [@{@"tag" : @"2", @"text" : @"Gay"} mutableCopy]
                             ] mutableCopy];
    actSettingsDic = [[NSMutableDictionary alloc] init];
//    actSettingsDic = [appController.currentUserSettings mutableCopy];
}

- (void)initUI {
    
    CGRect itemRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivitySettingViewController *itemView1 = (ActivitySettingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ActSettingVC"];
    [self addChildViewController:itemView1];
    UIView *view1 = [[UIView alloc] initWithFrame:itemRect];
    [view1 addSubview:itemView1.view];
    [activitySettingView addSubview:view1];
    
    PreferenceViewController *itemView2 = (PreferenceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PreSettingVC"];
    [self addChildViewController:itemView2];
    UIView *view2 = [[UIView alloc] initWithFrame:itemRect];
    [view2 addSubview:itemView2.view];
    [preferenceView addSubview:view2];
    
    [commonUtils setCircleBorderButton:birthDateBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:genderBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:cityBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:educationBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:incomeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:sexOrientBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    
    [commonUtils setTextFieldBorder:oldPassTxt withColor:[appController appMainColor] withBorderWidth:1.0f withCornerRadius:oldPassTxt.bounds.size.height / 2];
    [commonUtils setTextFieldBorder:newPassTxt withColor:[appController appMainColor] withBorderWidth:1.0f withCornerRadius:oldPassTxt.bounds.size.height / 2];
    [commonUtils setTextFieldBorder:confirmPassTxt withColor:[appController appMainColor] withBorderWidth:1.0f withCornerRadius:oldPassTxt.bounds.size.height / 2];
    
    [commonUtils cropCircleButton:saveBtn];
    
    int settings_user_gender = [[appController.currentUserSettings objectForKey:@"settings_user_gender"] intValue];
    int settings_user_city = [[appController.currentUserSettings objectForKey:@"settings_user_city"] intValue];
    int settings_user_education = [[appController.currentUserSettings objectForKey:@"settings_user_education"] intValue];
    int settings_user_income = [[appController.currentUserSettings objectForKey:@"settings_user_income"] intValue];
    int settings_user_orientation = [[appController.currentUserSettings objectForKey:@"settings_user_orientation"] intValue];
    
    [actSettingsDic setValue:[appController.currentUserSettings objectForKey:@"settings_user_gender"] forKey:@"settings_user_gender"];
    [actSettingsDic setValue:[appController.currentUserSettings objectForKey:@"settings_user_city"] forKey:@"settings_user_city"];
    [actSettingsDic setValue:[appController.currentUserSettings objectForKey:@"settings_user_education"] forKey:@"settings_user_education"];
    [actSettingsDic setValue:[appController.currentUserSettings objectForKey:@"settings_user_income"] forKey:@"settings_user_income"];
    [actSettingsDic setValue:[appController.currentUserSettings objectForKey:@"settings_user_orientation"] forKey:@"settings_user_orientation"];
    
    
    birthDatelbl.text = [appController.currentUserSettings objectForKey:@"settings_user_birth"];
    genderlbl.text = [[genderArray objectAtIndex:settings_user_gender] objectForKey:@"text"];
    citylbl.text = [[cityArray objectAtIndex:settings_user_city] objectForKey:@"text"];
    educationlbl.text = [[educationArray objectAtIndex:settings_user_education] objectForKey:@"text"];
    incomelbl.text = [[incomeArray objectAtIndex:settings_user_income] objectForKey:@"text"];
    sexOrienlbl.text = [[sexOrientationArray objectAtIndex:settings_user_orientation] objectForKey:@"text"];
    
    aboutTxtView.text = [appController.currentUser objectForKey:@"user_about"];
}

- (IBAction)upTab1Btn:(id)sender {
    appController.currentUserSettings = [commonUtils getUserDefaultDicByKey:@"currentUserSettings"];
    [tab1Btn setBackgroundColor:RGBA(28, 36, 51, 1.0f)];
    [tab2Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    [tab3Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    activitySettingView.hidden = YES;
    preferenceView.hidden = YES;
    profileSettingView.hidden = NO;
}
- (IBAction)upTab2Btn:(id)sender {
    appController.currentUserSettings = [commonUtils getUserDefaultDicByKey:@"currentUserSettings"];
    [tab2Btn setBackgroundColor:RGBA(28, 36, 51, 1.0f)];
    [tab1Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    [tab3Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    activitySettingView.hidden = NO;
    preferenceView.hidden = YES;
    profileSettingView.hidden = YES;
}

- (IBAction)upTab3Btn:(id)sender {
    appController.currentUserSettings = [commonUtils getUserDefaultDicByKey:@"currentUserSettings"];
    [tab3Btn setBackgroundColor:RGBA(28, 36, 51, 1.0f)];
    [tab2Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    [tab1Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    activitySettingView.hidden = YES;
    preferenceView.hidden = NO;
    profileSettingView.hidden = YES;
}

- (IBAction)onClickBirthBtn:(id)sender {
    _dateView.hidden = NO;
}

- (IBAction)onClickGenderBtn:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in genderArray){
        [actionSheet addButtonWithTitle:[gender objectForKey:@"text"]];
        i++;
    }
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)onClickCityBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in cityArray){
        [actionSheet addButtonWithTitle:[gender objectForKey:@"text"]];
        i++;
    }
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}

- (IBAction)onClickEduBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in educationArray){
        [actionSheet addButtonWithTitle:[gender objectForKey:@"text"]];
        i++;
    }
    actionSheet.tag = 3;
    [actionSheet showInView:self.view];
}

- (IBAction)onClickIncomeBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in incomeArray){
        [actionSheet addButtonWithTitle:[gender objectForKey:@"text"]];
        i++;
    }
    actionSheet.tag = 4;
    [actionSheet showInView:self.view];
}

- (IBAction)onClickSexBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in sexOrientationArray){
        [actionSheet addButtonWithTitle:[gender objectForKey:@"text"]];
        i++;
    }
    actionSheet.tag = 5;
    [actionSheet showInView:self.view];
}

#pragma mark - ActiohSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Button Index %d",(int)buttonIndex);
    NSString *indexStr = [NSString stringWithFormat:@"%d",(int)buttonIndex];
    
    if (actionSheet.tag == 1){
        genderlbl.text = [[genderArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_user_gender"];
    }else if (actionSheet.tag == 2){
        citylbl.text = [[cityArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_user_city"];
    }else if (actionSheet.tag == 3){
        educationlbl.text = [[educationArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_user_education"];
    }else if (actionSheet.tag == 4){
        incomelbl.text = [[incomeArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_user_income"];
    }else if (actionSheet.tag == 5){
        sexOrienlbl.text = [[sexOrientationArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_user_orientation"];
    }
}

- (IBAction)onSave:(id)sender {
    if(![aboutTxtView.text isEqualToString:@""]){
        [actSettingsDic setValue:aboutTxtView.text forKey:@"user_about"];
    }
    if(![oldPassTxt.text isEqualToString:@""]){
        if([newPassTxt.text isEqualToString:confirmPassTxt.text] && ![newPassTxt.text isEqualToString:@""]){
            if([newPassTxt.text length] < 6 || [newPassTxt.text length] > 10) {
                [commonUtils showVAlertSimple:@"" body:@"Şifre uzunluğu 6 ile 10 karakter arasında olmalı" duration:1.2];
                return;
            }else{
                [actSettingsDic setValue:[commonUtils md5:oldPassTxt.text] forKey:@"old_password"];
                [actSettingsDic setValue:[commonUtils md5:newPassTxt.text] forKey:@"new_password"];
            }
        }else{
            NSString *msg = @"Yeni şifreler eşleşmiyor";
            [commonUtils showVAlertSimple:@"Hata" body:msg duration:1.4];
            return;
        }
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:actSettingsDic forKey:@"user_settings"];
    
    NSLog(@"paramDic : %@", paramDic);
    
    [self.view endEditing:YES];
    
    [self requestAPIPost:paramDic];
}


#pragma mark - API Request - get Latest Settings Dictionary
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_UDATE_SETTING withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [[result objectForKey:@"current_user"] mutableCopy];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            appController.currentUserSettings = [[result objectForKey:@"user_settings"] mutableCopy];
            [commonUtils setUserDefaultDic:@"currentUserSettings" withDic:appController.currentUserSettings];            
            
            NSLog(@"%@", [result objectForKey:@"msg"]);
            
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            [commonUtils showVAlertSimple:@"Hata" body:msg duration:1.4];
            
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
    
}

- (IBAction)changeDate:(id)sender {
    dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [dateFormatter stringFromDate:_datePicker.date];
}

- (IBAction)onDateCancel:(id)sender {
    _dateView.hidden = YES;
}

- (IBAction)onDateDone:(id)sender {
    birthDatelbl.text = dateString;
    [actSettingsDic setValue:dateString forKey:@"settings_user_birth"];
    _dateView.hidden = YES;
}

@end
