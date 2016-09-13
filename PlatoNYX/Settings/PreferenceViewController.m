//
//  PreferenceViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 9/8/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "PreferenceViewController.h"

@interface PreferenceViewController () <UIActionSheetDelegate> {
    
    IBOutlet UILabel *ageRangelbl;
    IBOutlet UILabel *citylbl;
    IBOutlet UILabel *educationlbl;
    IBOutlet UILabel *incomelbl;
    
    IBOutlet UIButton *ageRangeBtn;
    IBOutlet UIButton *cityBtn;
    IBOutlet UIButton *educationBtn;
    IBOutlet UIButton *incomeBtn;
    
    IBOutlet UIButton *saveBtn;
    
    // Data
    NSArray *ageRangeArray;
    NSArray *cityArray;
    NSArray *educationArray;
    NSArray *incomeArray;
    
    NSMutableDictionary *actSettingsDic;
}

@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

- (void) initData {
    ageRangeArray = [[NSMutableArray alloc] init];
    ageRangeArray = [@[
                     [@{@"tag" : @"1", @"text" : @"18 - 24"} mutableCopy],
                     [@{@"tag" : @"2", @"text" : @"25 - 34"} mutableCopy],
                     [@{@"tag" : @"3", @"text" : @"35 - 44"} mutableCopy],
                     [@{@"tag" : @"4", @"text" : @"45 - 54"} mutableCopy],
                     [@{@"tag" : @"5", @"text" : @"Farketmez"} mutableCopy]
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
                        [@{@"tag" : @"2", @"text" : @"Üniversite Mezunu"} mutableCopy],
                        [@{@"tag" : @"3", @"text" : @"Yüksek Lisans"} mutableCopy],
                        [@{@"tag" : @"4", @"text" : @"Doktora"} mutableCopy],
                        [@{@"tag" : @"5", @"text" : @"Farketmez"} mutableCopy]
                        ] mutableCopy];
    incomeArray = [[NSMutableArray alloc] init];
    incomeArray = [@[
                     [@{@"tag" : @"1", @"text" : @"0-2.000 TL"} mutableCopy],
                     [@{@"tag" : @"2", @"text" : @"2.000-6.000 TL"} mutableCopy],
                     [@{@"tag" : @"3", @"text" : @"6.000-10.000 TL"} mutableCopy],
                     [@{@"tag" : @"4", @"text" : @"10,000 TL"} mutableCopy],
                     [@{@"tag" : @"5", @"text" : @"Farketmez"} mutableCopy]
                     ] mutableCopy];
    
    actSettingsDic = [[NSMutableDictionary alloc] init];
    actSettingsDic = [appController.currentUserSettings mutableCopy];
    
}

- (void)initUI {
    [commonUtils setCircleBorderButton:ageRangeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:cityBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:educationBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:incomeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    
    [commonUtils cropCircleButton:saveBtn];
    
    int settings_pre_agerange = [[actSettingsDic objectForKey:@"settings_pre_agerange"] intValue];
    int settings_pre_city = [[actSettingsDic objectForKey:@"settings_pre_city"] intValue];
    int settings_pre_education = [[actSettingsDic objectForKey:@"settings_pre_education"] intValue];
    int settings_pre_income = [[actSettingsDic objectForKey:@"settings_pre_income"] intValue];
    
    ageRangelbl.text = [[ageRangeArray objectAtIndex:settings_pre_agerange] objectForKey:@"text"];
    citylbl.text = [[cityArray objectAtIndex:settings_pre_city] objectForKey:@"text"];
    educationlbl.text = [[educationArray objectAtIndex:settings_pre_education] objectForKey:@"text"];
    incomelbl.text = [[incomeArray objectAtIndex:settings_pre_income] objectForKey:@"text"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickAgeBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in ageRangeArray){
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

- (IBAction)onIncomeBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil  otherButtonTitles:nil, nil];
    int i = 0;
    for (NSDictionary *gender in incomeArray){
        [actionSheet addButtonWithTitle:[gender objectForKey:@"text"]];
        i++;
    }
    actionSheet.tag = 4;
    [actionSheet showInView:self.view];
}


#pragma mark - ActiohSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Button Index %d",(int)buttonIndex);
    NSString *indexStr = [NSString stringWithFormat:@"%d",(int)buttonIndex];
    
    if (actionSheet.tag == 1){
        ageRangelbl.text = [[ageRangeArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_pre_agerange"];
    }else if (actionSheet.tag == 2){
        citylbl.text = [[cityArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_pre_city"];
    }else if (actionSheet.tag == 3){
        educationlbl.text = [[educationArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_pre_education"];
    }else if (actionSheet.tag == 4){
        incomelbl.text = [[incomeArray objectAtIndex:buttonIndex] objectForKey:@"text"];
        [actSettingsDic setValue:indexStr forKey:@"settings_pre_income"];
    }
}

- (IBAction)onSave:(id)sender {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:actSettingsDic forKey:@"user_settings"];
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
            actSettingsDic = [result objectForKey:@"user_settings"];
            
            appController.currentUser = [[result objectForKey:@"current_user"] mutableCopy];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            appController.currentUserSettings = [actSettingsDic mutableCopy];
            [commonUtils setUserDefaultDic:@"currentUserSettings" withDic:appController.currentUserSettings];
            
            [self performSelector:@selector(requestOverPost) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (void)requestOverPost {
    
}

@end
