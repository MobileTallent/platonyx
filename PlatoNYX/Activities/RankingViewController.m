//
//  RankingViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/26/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "RankingViewController.h"
#import "rankingTableViewCell.h"

@interface RankingViewController (){
    NSMutableArray *pastPostArray;
    IBOutlet UITableView *rankingTableView;
//    IBOutlet UITableView *joinedUserTableView;
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
    [rankingTableView reloadData];
}

#pragma UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [pastPostArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height - 190;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rankingTableViewCell *rcell = (rankingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rankingTableViewCell"];
    rcell.activityNamelbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_caption"];
    rcell.placelbl.text = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"post_place"];

/*    else if(tableView == joinedUserTableView) {
        joinedUserTableViewCell *jcell = (joinedUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"joinedUserCell"];
        cell = jcell;
    }
*/  
    //joinedUserArray
    
    rcell.joinedUserArray = [[pastPostArray objectAtIndex:indexPath.row] objectForKey:@"attend"];
    
    [rcell.joinedUserTableView reloadData];
    return rcell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
