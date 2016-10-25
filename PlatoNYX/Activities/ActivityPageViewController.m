//
//  ActivityPageViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/14/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ActivityPageViewController.h"
#import "ActivityListViewController.h"
#import "ActivityDetailViewController.h"

@interface ActivityPageViewController () {
    

    IBOutlet UIButton *joinActivityBtn;
    IBOutlet UIButton *attendantBtn;
    IBOutlet UIButton *detailActivityBtn;
    
    IBOutlet UIImageView *photoImg;
    IBOutlet UILabel *namelbl;
    IBOutlet UILabel *placelbl;
    IBOutlet UILabel *timelbl;
    IBOutlet UILabel *pricelbl;
    IBOutlet UITextView *aboutlbl;
    
    IBOutlet UIView *bottomBar;
    
}

@end

@implementation ActivityPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void) initUI {
    NSString* actImageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [_itemDic objectForKey:@"post_photo_url"]];
    [commonUtils setImageViewAFNetworking:photoImg withImageUrl:actImageUrl withPlaceholderImage:[UIImage imageNamed:@"profile_banner"]];
    namelbl.text = [_itemDic objectForKey:@"post_caption"];
    aboutlbl.text = [_itemDic objectForKey:@"post_desc"];
    
    [aboutlbl setTextColor:RGBA(168, 173, 191, 1.0)];
    
    placelbl.text = [_itemDic objectForKey:@"post_place"];
    pricelbl.text = [_itemDic objectForKey:@"post_price"];
    
    NSString *myString = [_itemDic objectForKey:@"post_date"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"dd MMM yyyy";
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"tr-TR"]];
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    
    NSString *myString2 = [_itemDic objectForKey:@"post_time"];
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"HH:mm:ss";
    NSDate *yourTime = [dateFormatter2 dateFromString:myString2];
    dateFormatter2.dateFormat = @"HH:mm";
    NSLog(@"%@",[dateFormatter2 stringFromDate:yourTime]);
    
    timelbl.text = [[NSString alloc] initWithFormat:@"%@, %@",[dateFormatter2 stringFromDate:yourTime],  [dateFormatter stringFromDate:yourDate]];
    bottomBar.hidden = YES;
    
    [commonUtils setCircleBorderButton:joinActivityBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:attendantBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:detailActivityBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goActivityList:(id)sender {
    [self performSegueWithIdentifier:@"goAttendants" sender:nil];
}

- (IBAction)goActivityDetail:(id)sender {
    [self performSegueWithIdentifier:@"goActivityDetail" sender:nil];
}

- (IBAction)joinActivity:(id)sender {

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[_itemDic objectForKey:@"post_id"] forKey:@"post_id"];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:@"1" forKey:@"is_join"];
    [self requestAPIPost:paramDic];
}

#pragma mark - API Request - get Recommended Post
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_JOIN_POST withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
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
    bottomBar.hidden = NO;
    joinActivityBtn.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goAttendants"]) {
        ActivityListViewController *controller = segue.destinationViewController;
        controller.postId = [_itemDic objectForKey:@"post_id"];
        controller.postName = [_itemDic objectForKey:@"post_caption"];
    }else {
        ActivityDetailViewController *controller = segue.destinationViewController;
        controller.postDic = [_itemDic mutableCopy];
    }
}

@end
