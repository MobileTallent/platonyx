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
    NSLog(@"%@", _itemDic);
    
    NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [_itemDic objectForKey:@"user_photo_url"]];
    [commonUtils setImageViewAFNetworking:_profileImgView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"empty_photo"]];
    
    namelbl.text = [_itemDic objectForKey:@"user_name"];
    agelbl.text = [_itemDic objectForKey:@"user_name"];
    genderlbl.text = [_itemDic objectForKey:@"user_name"];
    citylbl.text = [_itemDic objectForKey:@"user_name"];
    kidslbl.text = [_itemDic objectForKey:@"user_name"];
    signlbl.text = [_itemDic objectForKey:@"user_name"];
    educationlbl.text = [_itemDic objectForKey:@"user_name"];
    aboutlbl.text = [_itemDic objectForKey:@"user_about"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
