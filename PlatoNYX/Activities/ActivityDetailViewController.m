//
//  ActivityDetailViewController.m
//  PlatoNYX
//
//  Created by mobilestar on 8/18/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController ()<MKMapViewDelegate>{

    IBOutlet UILabel *activityNamelbl;
    IBOutlet UIImageView *activityPhotoImg;
    IBOutlet UITextView *aboutTxt;
    
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *cityNamelbl;
    IBOutlet UILabel *addresslbl;
    
    CLLocationCoordinate2D location;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
}
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* actImageUrl = [[NSString alloc] initWithFormat:@"%@/%@", SERVER_URL, [self.postDic objectForKey:@"post_photo_url"]];
    [commonUtils setImageViewAFNetworking:activityPhotoImg withImageUrl:actImageUrl withPlaceholderImage:[UIImage imageNamed:@"profile_banner"]];
    
    activityNamelbl.text = [self.postDic objectForKey:@"post_caption"];
    aboutTxt.text = [self.postDic objectForKey:@"post_desc"];
    cityNamelbl.text = [self.postDic objectForKey:@"post_place"];
    addresslbl.text = [self.postDic objectForKey:@"post_address"];
    
    span.latitudeDelta = 0.5;
    span.longitudeDelta = 0.5;
    
    location.latitude = [[self.postDic objectForKey:@"post_lati"] doubleValue];
    location.longitude = [[self.postDic objectForKey:@"post_long"] doubleValue];
    
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
