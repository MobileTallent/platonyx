//
//  ProfileViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/5/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController (){

    IBOutlet UILabel *namelbl;
    IBOutlet UILabel *agelbl;
    IBOutlet UILabel *genderlbl;
    IBOutlet UILabel *citylbl;
    IBOutlet UILabel *kidslbl;
    IBOutlet UILabel *signlbl;
    IBOutlet UILabel *educationlbl;
    IBOutlet UITextView *aboutlbl;
    
    // Data
    NSArray *genderArray;
    NSArray *cityArray;
    NSArray *educationArray;
    NSArray *incomeArray;
    NSArray *sexOrientationArray;
}
@property (strong, nonatomic) IBOutlet UIImageView *profileImgView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    
}

- (void)initView {
    [commonUtils cropCircleImage:_profileImgView];
    [commonUtils setCircleBorderImage:_profileImgView withBorderWidth:2.0f withBorderColor:[UIColor whiteColor]];
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
    
    int settings_user_gender = [[_itemDic objectForKey:@"settings_user_gender"] intValue];
    int settings_user_city = [[_itemDic objectForKey:@"settings_user_city"] intValue];
    int settings_user_education = [[_itemDic objectForKey:@"settings_user_education"] intValue];
//    int settings_user_income = [[_itemDic objectForKey:@"settings_user_income"] intValue];
//    int settings_user_orientation = [[_itemDic objectForKey:@"settings_user_orientation"] intValue];
    
    // calculate age from birth day in JSON
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startD = [dateFormatter dateFromString:[_itemDic objectForKey:@"settings_user_birth"]];
    NSDate *endD = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
    
    NSInteger year  = [components year];
    NSInteger month  = [components month];
    NSInteger day  = [components day];
    
    NSLog(@"%ld:%ld:%ld", (long)year, (long)month,(long)day);

    educationlbl.text = [[educationArray objectAtIndex:settings_user_education] objectForKey:@"text"];
//    incomelbl.text = [[incomeArray objectAtIndex:settings_user_income] objectForKey:@"text"];
//    sexOrienlbl.text = [[sexOrientationArray objectAtIndex:settings_user_orientation] objectForKey:@"text"];
    
    NSLog(@"%@", _itemDic);
    
    NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [_itemDic objectForKey:@"user_photo_url"]];
    [commonUtils setImageViewAFNetworking:_profileImgView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"placeholder"]];
    
    agelbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)year];
    namelbl.text = [_itemDic objectForKey:@"user_name"];
    genderlbl.text = [[genderArray objectAtIndex:settings_user_gender] objectForKey:@"text"];
    citylbl.text = [[cityArray objectAtIndex:settings_user_city] objectForKey:@"text"];
//    kidslbl.text = [_itemDic objectForKey:@"user_name"];
//    signlbl.text = [_itemDic objectForKey:@"user_name"];
    educationlbl.text = [[educationArray objectAtIndex:settings_user_education] objectForKey:@"text"];
    aboutlbl.text = [_itemDic objectForKey:@"user_about"];
    
    [aboutlbl setTextColor:RGBA(168, 173, 191, 1.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
