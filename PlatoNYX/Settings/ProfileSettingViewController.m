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
}

- (IBAction)upTab1Btn:(id)sender {
    [tab1Btn setBackgroundColor:RGBA(28, 36, 51, 1.0f)];
    [tab2Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    [tab3Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    activitySettingView.hidden = YES;
    preferenceView.hidden = YES;
    profileSettingView.hidden = NO;
}
- (IBAction)upTab2Btn:(id)sender {
    [tab2Btn setBackgroundColor:RGBA(28, 36, 51, 1.0f)];
    [tab1Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    [tab3Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    activitySettingView.hidden = NO;
    preferenceView.hidden = YES;
    profileSettingView.hidden = YES;
}

- (IBAction)upTab3Btn:(id)sender {
    [tab3Btn setBackgroundColor:RGBA(28, 36, 51, 1.0f)];
    [tab2Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    [tab1Btn setBackgroundColor:RGBA(35, 45, 62, 1.0f)];
    activitySettingView.hidden = YES;
    preferenceView.hidden = NO;
    profileSettingView.hidden = YES;
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
    sexOrientationArray = [[NSMutableArray alloc] init];
    sexOrientationArray = [@[
                     [@{@"tag" : @"1", @"text" : @"Heterosexual"} mutableCopy],
                     [@{@"tag" : @"2", @"text" : @"Gay"} mutableCopy]
                     ] mutableCopy];
}

- (IBAction)onClickBirthBtn:(id)sender {
    
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
    if (actionSheet.tag == 1){
        genderlbl.text = [[genderArray objectAtIndex:buttonIndex] objectForKey:@"text"];
    }else if (actionSheet.tag == 2){
        citylbl.text = [[cityArray objectAtIndex:buttonIndex] objectForKey:@"text"];
    }else if (actionSheet.tag == 3){
        educationlbl.text = [[educationArray objectAtIndex:buttonIndex] objectForKey:@"text"];
    }else if (actionSheet.tag == 4){
        incomelbl.text = [[incomeArray objectAtIndex:buttonIndex] objectForKey:@"text"];
    }else if (actionSheet.tag == 5){
        sexOrienlbl.text = [[sexOrientationArray objectAtIndex:buttonIndex] objectForKey:@"text"];
    }
}

- (IBAction)onSave:(id)sender {
    
}

@end
