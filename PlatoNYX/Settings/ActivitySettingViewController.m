//
//  ActivitySettingViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 9/8/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ActivitySettingViewController.h"

@interface ActivitySettingViewController (){
    
    // when do you want to attend to activities?
    
//    Only on weekends
//    On working days after the working hours
//    On working days during the day
//    Does not matter
    
    IBOutlet UIImageView *weekendMarkImg;
    IBOutlet UIImageView *afterworkingMarkImg;
    IBOutlet UIImageView *duringdayMarkImg;
    IBOutlet UIImageView *nomatterMarkImg;
    
    // which type of activities would you like to attend?
    
//    Gourmand
//    Adrenalin
//    Nature
//    Creative
//    Voyager
    
    IBOutlet UIImageView *gourmandMarkImg;
    IBOutlet UIImageView *adrenalinMarkImg;
    IBOutlet UIImageView *natureMarkImg;
    IBOutlet UIImageView *creativeMarkImg;
    IBOutlet UIImageView *voyagerMarkImg;
    
    // Price range
    
    IBOutlet UIImageView *smallMarkImg;
    IBOutlet UIImageView *mediumMarkImg;
    IBOutlet UIImageView *highMarkImg;
    IBOutlet UIImageView *muchMarkImg;
    
    IBOutlet UIButton *saveBtn;
    
    NSMutableDictionary* actSettingsDic;
}

@end

@implementation ActivitySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
    [commonUtils cropCircleButton:saveBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    if([[actSettingsDic objectForKey:@"settings_act_onWeekend"] intValue]) {
        [weekendMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [weekendMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onAfterWorking"] intValue]) {
        [afterworkingMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [afterworkingMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onDuringDay"] intValue]) {
        [duringdayMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [duringdayMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onNoMatter"] intValue]) {
        [nomatterMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [nomatterMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onGourmand"] intValue]) {
        [gourmandMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [gourmandMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onAdrenalin"] intValue]) {
        [adrenalinMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [adrenalinMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onNature"] intValue]) {
        [natureMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [natureMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onCreative"] intValue]) {
        [creativeMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [creativeMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onVoyager"] intValue]) {
        [voyagerMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [voyagerMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onSmall"] intValue]) {
        [smallMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [smallMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onMedium"] intValue]) {
        [mediumMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [mediumMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onHigh"] intValue]) {
        [highMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [highMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
    
    if([[actSettingsDic objectForKey:@"settings_act_onMuch"] intValue]) {
        [muchMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }else {
        [muchMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    }
}

- (void)initData {
    actSettingsDic = [[NSMutableDictionary alloc] init];
    actSettingsDic = appController.currentUserSettings;
//    actSettingsDic = [[commonUtils getUserDefault:@"currentUserSettings"] mutableCopy];

//    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
//    [paramDic setObject:actSettingsDic forKey:@"user_settings"];
//    [self requestAPIPost:paramDic];
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

- (BOOL) checkWhenOptions {
    
    if (([[actSettingsDic objectForKey:@"settings_act_onWeekend"] intValue] +  [[actSettingsDic objectForKey:@"settings_act_onAfterWorking"] intValue] +  [[actSettingsDic objectForKey:@"settings_act_onDuringDay"] intValue] + [[actSettingsDic objectForKey:@"settings_act_onNoMatter"] intValue]) > 0)
        return true;
    else {
        return false;
    }
}

- (BOOL) checkTypeOptions {
    if (([[actSettingsDic objectForKey:@"settings_act_onGourmand"] intValue] +  [[actSettingsDic objectForKey:@"settings_act_onAdrenalin"] intValue] +  [[actSettingsDic objectForKey:@"settings_act_onNature"] intValue] + [[actSettingsDic objectForKey:@"settings_act_onCreative"] intValue] + [[actSettingsDic objectForKey:@"settings_act_onVoyager"] intValue]) > 0)
        return true;
    else {
        return false;
    }
}

- (BOOL) checkPriceOptions {
    if (([[actSettingsDic objectForKey:@"settings_act_onSmall"] intValue] +  [[actSettingsDic objectForKey:@"settings_act_onMedium"] intValue] +  [[actSettingsDic objectForKey:@"settings_act_onHigh"] intValue] + [[actSettingsDic objectForKey:@"settings_act_onMuch"] intValue]) > 0)
        return true;
    else {
        return false;
    }
}

- (IBAction)onWeekend:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onWeekend"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onWeekend"];
        
        if([self checkWhenOptions])
            [weekendMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onWeekend"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onWeekend"];
        [weekendMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onAfterWorking:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onAfterWorking"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onAfterWorking"];
        
        if([self checkWhenOptions])
            [afterworkingMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onAfterWorking"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onAfterWorking"];
        [afterworkingMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onDuringDay:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onDuringDay"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onDuringDay"];
        
        if([self checkWhenOptions])
            [duringdayMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onDuringDay"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onDuringDay"];
        [duringdayMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onNoMatter:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onNoMatter"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onNoMatter"];
        
        if([self checkWhenOptions])
            [nomatterMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onNoMatter"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onNoMatter"];
        [nomatterMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}


- (IBAction)onGourmand:(id)sender {
    if([[actSettingsDic objectForKey:@"settings_act_onGourmand"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onGourmand"];
        
        if([self checkTypeOptions])
            [gourmandMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onGourmand"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onGourmand"];
        [gourmandMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onAdrenalin:(id)sender {
    if([[actSettingsDic objectForKey:@"settings_act_onAdrenalin"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onAdrenalin"];
        
        if([self checkTypeOptions])
            [adrenalinMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onAdrenalin"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onAdrenalin"];
        [adrenalinMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onNature:(id)sender {
    if([[actSettingsDic objectForKey:@"settings_act_onNature"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onNature"];
        if([self checkTypeOptions])
            [natureMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onNature"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onNature"];
        [natureMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}

- (IBAction)onCreative:(id)sender {
    if([[actSettingsDic objectForKey:@"settings_act_onCreative"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onCreative"];
        if([self checkTypeOptions])
            [creativeMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onCreative"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onCreative"];
        [creativeMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}

- (IBAction)onVoyager:(id)sender {

    if([[actSettingsDic objectForKey:@"settings_act_onVoyager"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onVoyager"];
        if([self checkTypeOptions])
            [voyagerMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onVoyager"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onVoyager"];
        [voyagerMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}

- (IBAction)onSmall:(id)sender {
    if([[actSettingsDic objectForKey:@"settings_act_onSmall"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onSmall"];
        
        if([self checkPriceOptions])
            [smallMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onSmall"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onSmall"];
        [smallMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onMedium:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onMedium"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onMedium"];
        if([self checkPriceOptions])
            [mediumMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onMedium"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onMedium"];
        [mediumMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onHigh:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onHigh"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onHigh"];
        if([self checkPriceOptions])
            [highMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onHigh"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onHigh"];
        [highMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}
- (IBAction)onMuch:(id)sender {
    
    if([[actSettingsDic objectForKey:@"settings_act_onMuch"] intValue]) {
        [actSettingsDic setValue:@"0" forKey:@"settings_act_onMuch"];
        if([self checkPriceOptions])
            [muchMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
        else
            [actSettingsDic setValue:@"1" forKey:@"settings_act_onMuch"];
    }else {
        [actSettingsDic setValue:@"1" forKey:@"settings_act_onMuch"];
        [muchMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
    }
}


- (IBAction)onSave:(id)sender {
//    [appController.vAlert doYesNo:@"Confirm"
//                             body:@"Are you sure you want to delete this photo?"
//                              yes:^(DoAlertView *alertView) {
//                                  NSMutableDictionary *dic = [mainArray objectAtIndex:rowIndex];
//                                  NSMutableDictionary *paramdic = [[NSMutableDictionary alloc] init];
//                                  [paramdic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
//                                  [paramdic setObject:[dic objectForKey:@"photo_id"] forKey:@"photo_id"];
//                                  
//                                  NSLog(@"%@", paramdic);
//                                  
//                                  [commonUtils showActivityIndicatorColored:self.view];
//                                  [NSThread detachNewThreadSelector:@selector(requestDataPhotoDelete:) toTarget:self withObject:paramdic];
//                              }
//                               no:^(DoAlertView *alertView) {
//                                   
//                               }
//     ];
    
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:actSettingsDic forKey:@"user_settings"];
    [self requestAPIPost:paramDic];
}



@end
