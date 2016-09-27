//
//  PhotoGalleryViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/12/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "btSimplePopUP.h"

#define _isCameraAvailable [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]

@interface PhotoGalleryViewController () <UICollectionViewDataSource_Draggable, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout>{
    
    IBOutlet UIView *popupView;
    
    IBOutlet UIView *imageContentView;
    IBOutlet UIScrollView *scrollView;
    
    NSMutableArray* mainArray;
    BOOL isPhotoChanged;
}

@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    NSLog(@"%d", self.isCoverPhoto);
}

- (void) initUI {

    [commonUtils cropCircleButton:self.addBtn];
    popupView.hidden = YES;
    
//    int kCellsPerRow = 3, kCellsPerCol = 2;
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*) _photoCollectionView.collectionViewLayout;
//    CGFloat availableWidthForCells = CGRectGetWidth(_photoCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
//    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
//    
//    CGFloat availableHeightForCells = CGRectGetHeight(_photoCollectionView.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (kCellsPerCol - 1);
//    CGFloat cellHeight = availableHeightForCells / (float)kCellsPerCol;
//    
//    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    [self initData];
    
    imageContentView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initData {
    mainArray = [[NSMutableArray alloc] init];
    mainArray = [[appController.currentUser objectForKey:@"user_photo_array"] mutableCopy];
//    appController.isMyProfileChanged = NO;
}

- (IBAction)onAddPhoto:(id)sender {
    [popupView setAlpha:0.0f];
    popupView.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        [popupView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)takePhoto:(id)sender {
    //take photo code goes here
    NSLog(@"Take Photo");
    if (_isCameraAvailable) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else{
        NSLog(@"Camera Source Not Available ");
        [commonUtils showAlert:@"Warning" withMessage:@"Your device has no camera"];
        return;
    }
}

- (IBAction)takeLibrary:(id)sender {
    //upload photo code goes here
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self savePhoto:image];
    popupView.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)savePhoto :(UIImage *)image {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    NSString *photo = [commonUtils encodeToBase64String:image byCompressionRatio:0.3];
    [dic setObject:photo forKey:@"user_photo_data"];
    
    if(self.isCoverPhoto){
        [dic setObject:@"1" forKey:@"isCoverPhoto"];
    }else{
        [dic setObject:@"0" forKey:@"isCoverPhoto"];
    }

    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataUserPhotoChange:) toTarget:self withObject:dic];
    
}

#pragma mark - request data user profile change
- (void) requestDataUserPhotoChange:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_PHOTO_UPDATE withJSON:params];
    
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];

            [self performSelector:@selector(requestOverUserProfileChange) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (void) requestOverUserProfileChange {
    appController.isMyProfileChanged = YES;
    [commonUtils setUserDefault:@"is_my_profile_changed" withFormat:@"1"];
    
    [self initData];
    [_photoCollectionView reloadData];
}

#pragma mark - request data user profile change
- (void) requestDataPhotoOrderChange:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_PHOTO_ORDER withJSON:params];
    
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
//            [self performSelector:@selector(requestOverUserProfileChange) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Photo transmission Failed!";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 6;//[mainArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    if(indexPath.item < [mainArray count]){
        NSMutableDictionary *dic = [mainArray objectAtIndex:indexPath.item];
        NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [dic objectForKey:@"photo_url"]];
        [commonUtils setImageViewAFNetworking:cell.photoCellImgView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"empty_photo"]];
        cell.del_btn.tag = indexPath.row;
        cell.del_btn.hidden = NO;
        [cell.del_btn addTarget:self action:@selector(delButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [cell.photoCellImgView setImage:[UIImage imageNamed:@"empty_photo"]];
        cell.del_btn.hidden = YES;
    }

    return cell;
}

-(void)delButtonClicked:(UIButton*)sender
{
    NSInteger rowIndex = sender.tag;
    [appController.vAlert doYesNo:@"Confirm"
                             body:@"Are you sure you want to delete this photo?"
                              yes:^(DoAlertView *alertView) {
                                  NSMutableDictionary *dic = [mainArray objectAtIndex:rowIndex];
                                  NSMutableDictionary *paramdic = [[NSMutableDictionary alloc] init];
                                  [paramdic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
                                  [paramdic setObject:[dic objectForKey:@"photo_id"] forKey:@"photo_id"];
                                  
                                  NSLog(@"%@", paramdic);
                                  
                                  [commonUtils showActivityIndicatorColored:self.view];
                                  [NSThread detachNewThreadSelector:@selector(requestDataPhotoDelete:) toTarget:self withObject:paramdic];
                              }
                               no:^(DoAlertView *alertView) {
                                   
                               }
     ];


}
- (IBAction)closeImageContent:(id)sender {
    imageContentView.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item < [mainArray count]){
        for (NSDictionary *imageDic in mainArray) {
            NSInteger index = [mainArray indexOfObject:imageDic];
            NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [imageDic objectForKey:@"photo_url"]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [imageView setContentMode:(UIViewContentMode)UIViewContentModeScaleAspectFit];
            [commonUtils setImageViewAFNetworking:imageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"empty_photo"]];
            [scrollView addSubview:imageView];
        }
        
        scrollView.contentSize = CGSizeMake(mainArray.count * self.view.frame.size.width, scrollView.frame.size.height);
        imageContentView.hidden = NO;
    }
}

- (void) requestDataPhotoDelete:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_PHOTO_DEL withJSON:params];
    
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            [self initData];
            [_photoCollectionView reloadData];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Photo delete Failed!";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item < [mainArray count]){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(toIndexPath.item < [mainArray count]){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item < [mainArray count]){
        return YES;
    }else{
        return NO;
    }
}

- (void)collectionView:(LSCollectionViewHelper *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(fromIndexPath.item < [mainArray count] && toIndexPath.item < [mainArray count]){
        NSMutableDictionary *dic = [mainArray objectAtIndex:fromIndexPath.item];
        [mainArray removeObjectAtIndex:fromIndexPath.item];
        [mainArray insertObject:dic atIndex:toIndexPath.item];
        
        NSMutableDictionary *paramdic = [[NSMutableDictionary alloc] init];
        [paramdic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
        
        if(self.isCoverPhoto){
            [paramdic setObject:@"1" forKey:@"isCoverPhoto"];
        }else{
            [paramdic setObject:@"0" forKey:@"isCoverPhoto"];
        }
        [paramdic setObject:mainArray forKey:@"user_photo_array"];
        
        [commonUtils showActivityIndicatorColored:self.view];
        [NSThread detachNewThreadSelector:@selector(requestDataPhotoOrderChange:) toTarget:self withObject:paramdic];
    }else{
        [commonUtils showVAlertSimple:@"Warning" body:@"You cannot move empty photo." duration:1.4];
    }
}

@end
