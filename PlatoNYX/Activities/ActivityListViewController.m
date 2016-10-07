//
//  ActivityListViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/12/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ProfileViewController.h"

@interface ActivityListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    
    NSUInteger originalIndex, selectedIndex;
    NSArray* mainArray;
    NSMutableDictionary *itemDic;
}
@property (strong, nonatomic) IBOutlet UICollectionView *attendCollectionView;

@property (strong, nonatomic) IBOutlet UILabel *actNamelbl;

@end

@implementation ActivityListViewController

//@synthesize mainCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

- (void)initUI {
    int kCellsPerRow = 2, kCellsPerCol = 6;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*) _attendCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(_attendCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    
    CGFloat availableHeightForCells = CGRectGetHeight(_attendCollectionView.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (kCellsPerCol - 1);
    CGFloat cellHeight = availableHeightForCells / (float)kCellsPerCol;
    
    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _actNamelbl.text = self.postName;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_postId forKey:@"post_id"];
    [self requestAPIPost:paramDic];
}

#pragma mark - API Request - get Recommended Post
- (void)requestAPIPost:(NSMutableDictionary *)dic {
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataPost:) toTarget:self withObject:dic];
}

- (void)requestDataPost:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_POST_ATTEND withJSON:(NSMutableDictionary *) params];
    
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            mainArray = [[NSMutableArray alloc] init];
            mainArray = [result objectForKey:@"attend"];
            
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
    [_attendCollectionView reloadData];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mainArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"attendantCell" forIndexPath:indexPath];
    itemDic = [mainArray objectAtIndex:indexPath.item];
    NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [itemDic objectForKey:@"user_photo_url"]];
    [commonUtils setImageViewAFNetworking:cell.activityPhotoImgView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [commonUtils setCircleBorderImage:cell.activityPhotoImgView withBorderWidth:2.0f withBorderColor:[UIColor whiteColor]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startD = [dateFormatter dateFromString:[itemDic objectForKey:@"settings_user_birth"]];
    NSDate *endD = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:startD toDate:endD options:0];
    
    NSInteger year  = [components year];
    NSInteger month  = [components month];
    NSInteger day  = [components day];
    
    NSLog(@"%ld:%ld:%ld", (long)year, (long)month,(long)day);
    
    cell.activityAgelbl.text = [[NSString alloc] initWithFormat:@"%@ %ld",[itemDic objectForKey:@"user_name"], (long)year];
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    itemDic = [mainArray objectAtIndex:indexPath.item];
    
    ProfileViewController* myController = [self.storyboard instantiateViewControllerWithIdentifier:@"otherProfile"];
    myController.itemDic = [itemDic mutableCopy];
    [self.navigationController pushViewController:myController animated:YES];
}



@end
