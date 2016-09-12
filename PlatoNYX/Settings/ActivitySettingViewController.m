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
}

@end

@implementation ActivitySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [commonUtils cropCircleButton:saveBtn];
}

- (void)initData {
    
}

- (IBAction)onWeekend:(id)sender {
    [weekendMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [afterworkingMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}
- (IBAction)onAfterWorking:(id)sender {
    [afterworkingMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [natureMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}
- (IBAction)onDuringDay:(id)sender {
    [duringdayMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [natureMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}
- (IBAction)onNoMatter:(id)sender {
    [nomatterMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [natureMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}


- (IBAction)onGourmand:(id)sender {
    [gourmandMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [adrenalinMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}
- (IBAction)onAdrenalin:(id)sender {
    [adrenalinMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [gourmandMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}
- (IBAction)onNature:(id)sender {
    [natureMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [gourmandMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
}
- (IBAction)onCreative:(id)sender {
    [creativeMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [gourmandMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
}
- (IBAction)onVoyager:(id)sender {
    [voyagerMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [gourmandMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
}

- (IBAction)onSmall:(id)sender {
    
    [smallMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [mediumMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    
}
- (IBAction)onMedium:(id)sender {
    
    [mediumMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [smallMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    
}
- (IBAction)onHigh:(id)sender {
    
    [highMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [smallMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];

}
- (IBAction)onMuch:(id)sender {
    
    [muchMarkImg setImage:[UIImage imageNamed:@"check_icon"]];
//    [smallMarkImg setImage:[UIImage imageNamed:@"uncheck_icon"]];
    
}


- (IBAction)onSave:(id)sender {
}

@end
