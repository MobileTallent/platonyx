//
//  NotiListViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 9/6/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "NotiListViewController.h"
#import "NotiTableViewCell.h"

@interface NotiListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *notificationTableView;
    NSMutableArray* notiArray;
    
    NSMutableDictionary *selectedDic;
    NSDictionary *UserDic;
}

@end

@implementation NotiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    UserDic = appController.currentUser;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[UserDic objectForKey:@"user_id"] forKey:@"user_id"];
    [self requestAPIPost:paramDic];
}

#pragma mark - API Request - get Recommended Post
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_GET_NOTI_LIST withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            notiArray = [[NSMutableArray alloc] init];
            notiArray = [result objectForKey:@"noti_list"];
            
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
    [notificationTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [notiArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotiTableViewCell *cell = (NotiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"notiCell"];
    if( [[[notiArray objectAtIndex:indexPath.row] objectForKey:@"noti_status"] intValue] > 0) {
        [cell.statusImg setImage:[UIImage imageNamed:@"message_open"]];
    }else {
        [cell.statusImg setImage:[UIImage imageNamed:@"message_closed"]];
    }
    cell.subjectlbl.text = [[notiArray objectAtIndex:indexPath.row] objectForKey:@"noti_subject"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = [[notiArray objectAtIndex:indexPath.row] objectForKey:@"noti_content"];

    [commonUtils setUserDefault:@"msg_count" withFormat:[NSString stringWithFormat:@"%lu", (unsigned long)[appController.msgs count]]];
    [commonUtils showAlert:@"Notification" withMessage:str];
    
    if( [[[notiArray objectAtIndex:indexPath.row] objectForKey:@"noti_status"] intValue] < 1) {
        [appController.msgs removeObjectAtIndex:indexPath.row];
        UserDic = appController.currentUser;
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[UserDic objectForKey:@"user_id"] forKey:@"user_id"];
        [paramDic setObject:[[notiArray objectAtIndex:indexPath.row] objectForKey:@"noti_id"] forKey:@"noti_id"];
        [self requestAPIPostForRead:paramDic];
    }
}

#pragma mark - API Request - get Recommended Post
- (void)requestAPIPostForRead:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPostForRead:) toTarget:self withObject:dic];
}

- (void)requestDataPostForRead:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_READ_NOTI_LIST withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            notiArray = [[NSMutableArray alloc] init];
            notiArray = [result objectForKey:@"noti_list"];
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
