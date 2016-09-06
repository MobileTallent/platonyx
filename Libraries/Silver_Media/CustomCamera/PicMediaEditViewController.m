//
//  MediaEditViewController.m
//  VIND
//
//  Created by Vinay Raja on 24/08/14.
//
//

#import "PicMediaEditViewController.h"

@interface PicMediaEditViewController () <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL isPicChanged, isLoading;
}

@property (nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic, strong) IBOutlet UIView *containerView;

@end

@implementation PicMediaEditViewController

@synthesize mediaImage, mediaPath, previewImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isLoading = NO;
    isPicChanged = NO;
    //[AFPhotoEditorController setAPIKey:kAviaryKey secret:kAviarySecret];
    mediaImage = [UIImage imageWithContentsOfFile:mediaPath];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}



#pragma mark - Scroll View Delegate for Image Zoom
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.previewImageView;
}


#pragma mark - Button Events
- (IBAction)onEditPhoto:(id)sender {
    if(isLoading) return;
}
- (IBAction)onBack:(id)sender {
    if(isLoading) return;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Post
- (IBAction)onPost:(id)sender {
    if(isLoading) return;
    [self doPostMedia:mediaPath];
    
}
#pragma mark - Post
- (void)doPostMedia:(NSString *)mPath {
    
    NSLog(@"post photo - %@", mPath);
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:@"add" forKey:@"tag"];
    [paramDic setObject:@"1" forKey:@"bark_type"];
    
    [paramDic setObject:[commonUtils encodeToBase64String:mediaImage byCompressionRatio:0.3] forKey:@"bark_photo"];
    
    [self requestAPI:paramDic];
    
}

- (void)requestAPI:(NSMutableDictionary *)dic {
    isLoading = YES;
    [commonUtils showActivityIndicatorColored:self.containerView];
    [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:dic];
}
/*
- (void) requestData:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_MY_BARKS withJSON:(NSMutableDictionary *) params];
    
    isLoading = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            appController.barks = [result objectForKey:@"barks"];
            appController.myBarks = [result objectForKey:@"my_barks"];
            appController.likedBarks = [result objectForKey:@"liked_barks"];
            appController.favoriteUsers = [result objectForKey:@"favorite_users"];
            
            [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
}
- (void)requestOver {
    [appController.vAlert doAlert:@"Success" body:@"You barked successfully" duration:1.4f done:^(DoAlertView *alertView) {
        appController.isNewBarkUploaded = YES;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}
 */
@end
