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

@interface RankingViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *pastPostArray, *joinedArray;
    IBOutlet UITableView *rankingTableView;
    IBOutlet UITableView *joinedUserTableView;
}

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData {
    pastPostArray = [appController.pastPostArray mutableCopy];
//    joinedArray = [[NSMutableArray alloc] init];
    joinedArray = [[pastPostArray objectAtIndex:0] objectForKey:@"attend"];
    [rankingTableView reloadData];
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
        rcell.viewAttendantsBtn.tag = indexPath.row;
        [rcell.viewAttendantsBtn addTarget:self
                    action:@selector(OnViewAttendants:)
          forControlEvents:UIControlEventTouchUpInside];

        //joinedUserArray
        
    //    rcell.joinedUserArray = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"attend"];
        
        return rcell;
    }else{
        JoinedUsersTableViewCell *jcell = (JoinedUsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"joinedUserCell"];
        jcell.userNamelbl.text = [[joinedArray objectAtIndex:indexPath.row] objectForKey:@"user_name"];

        return jcell;
    }
}

- (void)OnViewAttendants:(UIButton *)sender {
    // now you can known which button
    NSLog(@"%ld", (long)sender.tag);
    
    joinedArray = [[pastPostArray objectAtIndex:sender.tag] objectForKey:@"attend"];
    [joinedUserTableView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = CGRectMake(0, 0, self.attendantsView.frame.size.width, self.attendantsView.frame.size.height);
        self.attendantsView.frame = rect;
    }];
}

@end
