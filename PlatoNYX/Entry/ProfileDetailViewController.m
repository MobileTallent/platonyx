//
//  ProfileDetailViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/5/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "ProfileViewController.h"
#import "PhotoGalleryViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityPageViewController.h"

#define _isCameraAvailable [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]

@interface ProfileDetailViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UIButton *onActivityBtn;
    IBOutlet UIImageView *coverPhoto;
    NSUInteger currentBarkerIndex, visibleCellsCount;
    BOOL isCoverPhoto;
    IBOutlet UIView *backLineView;
    IBOutlet UITableView *postTableView;
    NSMutableDictionary *UserDic;
    NSMutableArray* postArray;
    
    NSMutableDictionary *selectedDic;
}
@end

@implementation ProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    visibleCellsCount = 3; //IS_IPHONE_6_OR_ABOVE ? 8 : 6;
    backLineView.hidden = YES;
    [self initView];
}

- (void) initProfile {
    UserDic = appController.currentUser;
    NSString* profileImageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [UserDic objectForKey:@"user_photo_url"]];
    [commonUtils setImageViewAFNetworking:self.profileImgView withImageUrl:profileImageUrl withPlaceholderImage:[UIImage imageNamed:@"empty_photo"]];
    [self.profileNamelbl setText:[UserDic objectForKey:@"user_name"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initProfile];
    [self initData];
}

- (void)initData {
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
    resObj = [commonUtils httpJsonRequest:API_URL_REC_POST withJSON:(NSMutableDictionary *) params];

    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            postArray = [[NSMutableArray alloc] init];
            postArray = [result objectForKey:@"posts"];
            
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
    [postTableView reloadData];
    if([postArray count] > visibleCellsCount)
        backLineView.hidden = NO;
}

- (void) initView {
    [self initProfile];
    [commonUtils cropCircleImage:_profileImgView];
    [commonUtils setCircleBorderImage:_profileImgView withBorderWidth:1.0f withBorderColor:[UIColor whiteColor]];
    
    [commonUtils cropCircleButton:onActivityBtn];
    [commonUtils setCircleBorderButton:onActivityBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toOtherProfile {
    ProfileViewController* myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityPage"];
    [self.navigationController pushViewController:myController animated:YES];
}

- (IBAction)onTakeProfileImg:(id)sender {
    isCoverPhoto = NO;
    [self takePhotoBtn];
}

- (void)takePhotoBtn {
    PhotoGalleryViewController *photoController = [self.storyboard instantiateViewControllerWithIdentifier:@"photoGallery"];
    [self.navigationController pushViewController:photoController animated:YES];
    
    [self.view endEditing:YES];
}

#pragma UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [postArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ([UIScreen mainScreen].bounds.size.height - 305) / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"activityTableCell"];
    
    cell.activityNamelbl.text = [[NSString alloc] initWithFormat:@"%@ Goes Here", [[postArray objectAtIndex:indexPath.row] objectForKey:@"post_caption"]];
    cell.activityPlacelbl.text = [[NSString alloc] initWithFormat:@"%@", [[postArray objectAtIndex:indexPath.row] objectForKey:@"post_place"]];
    cell.activityTimelbl.text = [[NSString alloc] initWithFormat:@"%@", [[postArray objectAtIndex:indexPath.row] objectForKey:@"post_date"]];
    
    [commonUtils setCircleBorderImage:cell.activityPhotoImg withBorderWidth:1.0f withBorderColor:[UIColor whiteColor]];
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    backLineView.hidden = YES;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if([postArray count] > visibleCellsCount)
        backLineView.hidden = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedDic = [postArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"eachActivityPage" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"eachActivityPage"]) {
        ActivityPageViewController *controller = segue.destinationViewController;
        controller.itemDic = [selectedDic mutableCopy];
    }
}
@end
