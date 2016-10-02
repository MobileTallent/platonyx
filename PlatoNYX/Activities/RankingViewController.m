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
}

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    BackFromAttendantsBtn.layer.cornerRadius = BackFromAttendantsBtn.layer.frame.size.height / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData {
    pastPostArray = [appController.pastPostArray mutableCopy];
    joinedArray = [[NSMutableArray alloc] init];
//    joinedArray = [[pastPostArray objectAtIndex:0] objectForKey:@"attend"];
//    [rankingTableView reloadData];
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
        return 182;
    }else
        return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == rankingTableView) {
        rankingTableViewCell *rcell = (rankingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rankingTableViewCell"];
    
        rcell.activityNamelbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_caption"];
        rcell.placelbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_place"];
        rcell.viewAttendantsBtn.tag = indexPath.row * 8;
        [rcell.viewAttendantsBtn addTarget:self
                    action:@selector(onCellBtn:)
          forControlEvents:UIControlEventTouchUpInside];

        rcell.nameLikeBtn.tag = indexPath.row * 8 + 1;
        [rcell.nameLikeBtn addTarget:self
                                    action:@selector(onCellBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
        rcell.nameDislikeBtn.tag = indexPath.row * 8 + 2;
        [rcell.nameDislikeBtn addTarget:self
                              action:@selector(onCellBtn:)
                    forControlEvents:UIControlEventTouchUpInside];
        rcell.placeLikeBtn.tag = indexPath.row * 8 + 3;
        [rcell.placeLikeBtn addTarget:self
                                 action:@selector(onCellBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
        rcell.placeDislikeBtn.tag = indexPath.row * 8 + 4;
        [rcell.placeDislikeBtn addTarget:self
                                 action:@selector(onCellBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        return rcell;
    }else{
        JoinedUsersTableViewCell *jcell = (JoinedUsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"joinedUserCell"];
        jcell.userNamelbl.text = [[joinedArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];
        
        NSString* profileImageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [[joinedArray objectAtIndex:indexPath.row] objectForKey:@"user_photo_url"]];
        [commonUtils setImageViewAFNetworking:jcell.userProfileImgView withImageUrl:profileImageUrl withPlaceholderImage:[UIImage imageNamed:@"empty_photo"]];
        
        [commonUtils setCircleBorderImage:jcell.userProfileImgView withBorderWidth:1.0f withBorderColor:[UIColor whiteColor]];
        
        jcell.userLikeBtn.tag = indexPath.row * 8 + 5;
        [jcell.userLikeBtn addTarget:self
                               action:@selector(onCellBtn:)
                     forControlEvents:UIControlEventTouchUpInside];
        jcell.userDislikeBtn.tag = indexPath.row * 8 + 6;
        [jcell.userDislikeBtn addTarget:self
                                  action:@selector(onCellBtn:)
                        forControlEvents:UIControlEventTouchUpInside];
        jcell.userImgBtn.tag = indexPath.row * 8 + 7;
        [jcell.userImgBtn addTarget:self
                                 action:@selector(onCellBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
        return jcell;
    }
}

- (void)onCellBtn:(UIButton *)sender {
    int rowIndex = (int)sender.tag / 8;
    NSLog(@"%d", rowIndex);
    
//    NSLog(@"%@", [pastPostArray objectAtIndex:rowIndex]);
    
    switch (sender.tag % 8) {
        case 0: {
            joinedArray = [[pastPostArray objectAtIndex:rowIndex] objectForKey:@"attend"];
            [joinedUserTableView reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect rect = CGRectMake(0, 0, self.attendantsView.frame.size.width, self.attendantsView.frame.size.height);
                self.attendantsView.frame = rect;
            }];
            break;
        }
        case 1: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbUp_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag + 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbDown_pink"] forState:UIControlStateNormal];
            break;
        }
        case 2: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbDown_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbUp_pink"] forState:UIControlStateNormal];
            break;
        }
        case 3: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbUp_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag + 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbDown_pink"] forState:UIControlStateNormal];
            break;
        }
        case 4: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbDown_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbUp_pink"] forState:UIControlStateNormal];
            break;
        }
        case 5: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbUp_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag + 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbDown_pink"] forState:UIControlStateNormal];
            break;
        }
        case 6: {
            [sender setBackgroundColor:[appController appMainColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"thumbDown_white"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[appController appMainColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"thumbUp_pink"] forState:UIControlStateNormal];
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
}

- (IBAction)onBackFromAttendantsView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = CGRectMake(0, self.attendantsView.frame.size.height, self.attendantsView.frame.size.width, self.attendantsView.frame.size.height);
        self.attendantsView.frame = rect;
    }];
}


@end
