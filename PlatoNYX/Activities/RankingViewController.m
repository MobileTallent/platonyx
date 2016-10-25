//
//  RankingViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/26/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "RankingViewController.h"
#import "rankingTableViewCell.h"
#import "JoinedUsersTableViewCell.h"
#import "ActivityListViewController.h"
#import "ProfileViewController.h"

@interface RankingViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *pastPostArray, *joinedArray;
    
    IBOutlet UITableView *rankingTableView;
    IBOutlet UITableView *joinedUserTableView;
    IBOutlet UIButton *BackFromAttendantsBtn;
    
    NSString *like_field;
    NSString *isLike;
    NSString *post_id;
    NSString *user_id;
}

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    BackFromAttendantsBtn.layer.cornerRadius = BackFromAttendantsBtn.layer.frame.size.height / 2;
    joinedArray = [[NSMutableArray alloc] init];
    like_field = [[NSString alloc] init];
    isLike = [[NSString alloc] init];
    post_id = [[NSString alloc] init];
    user_id = [[NSString alloc] init];
    user_id = [appController.currentUser objectForKey:@"user_id"];
    
    pastPostArray = [appController.pastPostArray mutableCopy];
    
    
    CGRect rect = CGRectMake(0, self.attendantsView.frame.size.height, self.attendantsView.frame.size.width, self.attendantsView.frame.size.height);
    self.attendantsView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData {
//    joinedArray = [[pastPostArray objectAtIndex:0] objectForKey:@"attend"];
//    [rankingTableView reloadData];
    like_field = @"";
    isLike = @"";
}

#pragma UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == rankingTableView)
        return [pastPostArray count];
    else
        return [joinedArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == rankingTableView) {
        return 205;
    }else
        return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == rankingTableView) {
        rankingTableViewCell *rcell = (rankingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rankingTableViewCell"];
        rcell.activityCaplbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_caption"];
//        rcell.activityNamelbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_caption"];
//        rcell.placelbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_place"];
        rcell.viewAttendantsBtn.tag = indexPath.row * 1000;
        [rcell.viewAttendantsBtn addTarget:self
                    action:@selector(onCellBtn:)
          forControlEvents:UIControlEventTouchUpInside];

        rcell.nameLikeBtn.tag = indexPath.row * 1000 + 1;
        [rcell.nameLikeBtn addTarget:self
                                    action:@selector(onCellBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
        rcell.nameDislikeBtn.tag = indexPath.row * 1000 + 2;
        [rcell.nameDislikeBtn addTarget:self
                              action:@selector(onCellBtn:)
                    forControlEvents:UIControlEventTouchUpInside];
        rcell.placeLikeBtn.tag = indexPath.row * 1000 + 3;
        [rcell.placeLikeBtn addTarget:self
                                 action:@selector(onCellBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
        rcell.placeDislikeBtn.tag = indexPath.row * 1000 + 4;
        [rcell.placeDislikeBtn addTarget:self
                                 action:@selector(onCellBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        return rcell;
    }else{
        JoinedUsersTableViewCell *jcell = (JoinedUsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"joinedUserCell"];
        jcell.userNamelbl.text = [[joinedArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];
        
        NSString* profileImageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [[joinedArray objectAtIndex:indexPath.row] objectForKey:@"user_photo_url"]];
        [commonUtils setImageViewAFNetworking:jcell.userProfileImgView withImageUrl:profileImageUrl withPlaceholderImage:[UIImage imageNamed:@"placeholder"]];
        
        [commonUtils setCircleBorderImage:jcell.userProfileImgView withBorderWidth:1.0f withBorderColor:[UIColor whiteColor]];
        
        jcell.userLikeBtn.tag = indexPath.row * 1000 + 5;
        [jcell.userLikeBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        jcell.userDislikeBtn.tag = indexPath.row * 1000 + 6;
        [jcell.userDislikeBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        jcell.userImgBtn.tag = indexPath.row * 1000 + 7;
        [jcell.userImgBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return jcell;
    }
}

- (void)onCellBtn:(UIButton *)sender {
    int rowIndex = (int)sender.tag / 1000;
    NSLog(@"%d", rowIndex);
    
//    NSLog(@"%@", [pastPostArray objectAtIndex:rowIndex]);
    
    switch (sender.tag % 1000) {
        case 0: {
            post_id = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"post_id"];
            
            joinedArray = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"attend"];
            [joinedUserTableView reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect rect = CGRectMake(0, 0, self.attendantsView.frame.size.width, self.attendantsView.frame.size.height);
                self.attendantsView.frame = rect;
            }];
            break;
        }
        //nameLikeBtn
        case 1: {
            post_id = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"post_id"];
            
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbUp_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag + 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbDown_pink"] forState:UIControlStateNormal];
            
            like_field = @"name";
            isLike = @"1";
            
            break;
        }
        //nameDislikeBtn
        case 2: {
            post_id = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"post_id"];
            
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbDown_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbUp_pink"] forState:UIControlStateNormal];
            
            like_field = @"name";
            isLike = @"0";
            
            break;
        }
        //placeLikeBtn
        case 3: {
            post_id = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"post_id"];
            
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbUp_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag + 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbDown_pink"] forState:UIControlStateNormal];
            
            like_field = @"place";
            isLike = @"1";
            
            break;
        }
        //placeDislikeBtn
        case 4: {
            post_id = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"post_id"];
            
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbDown_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbUp_pink"] forState:UIControlStateNormal];
            
            like_field = @"place";
            isLike = @"0";
            
            break;
        }
        //userLikeBtn
        case 5: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbUp_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag + 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbDown_pink"] forState:UIControlStateNormal];
            
            like_field = @"user";
            isLike = @"1";
            
            break;
        }
        //userDislikeBtn
        case 6: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbDown_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbUp_pink"] forState:UIControlStateNormal];
            
            like_field = @"user";
            isLike = @"0";
            
            break;
        }
        case 7: {
            NSLog(@"%@", [joinedArray objectAtIndex:rowIndex]);
            NSDictionary *itemDic = [joinedArray objectAtIndex:rowIndex];
            
            ProfileViewController* myController = [self.storyboard instantiateViewControllerWithIdentifier:@"otherProfile"];
            myController.itemDic = [itemDic mutableCopy];
            [self.navigationController pushViewController:myController animated:YES];
            
            break;
        }
    }
    
    if(sender.tag % 1000 != 0 && sender.tag % 1000 !=7){
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:user_id forKey:@"user_id"];
        
        [paramDic setObject:post_id forKey:@"post_id"];
        [paramDic setObject:like_field forKey:@"like_field"];
        [paramDic setObject:isLike forKey:@"isLike"];
        
        if ([like_field isEqualToString:@"user"]) {
            NSLog(@"%@", [joinedArray objectAtIndex:rowIndex]);
            [paramDic setObject:[[joinedArray objectAtIndex:rowIndex] objectForKey:@"user_id"] forKey:@"liked_user"];
        }
        NSLog(@"%@", paramDic);
        [self requestAPIPost:paramDic];
    }
}




#pragma mark - API Request - get Latest Settings Dictionary
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_LIKE withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [[result objectForKey:@"current_user"] mutableCopy];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
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
    [self initData];
}

- (IBAction)onBackFromAttendantsView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = CGRectMake(0, self.attendantsView.frame.size.height, self.attendantsView.frame.size.width, self.attendantsView.frame.size.height);
        self.attendantsView.frame = rect;
    }];
}


@end
