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
    IBOutlet UILabel *timelbl;
    
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
    
    [aboutTxt setTextColor:RGBA(168, 173, 191, 1.0)];
    
    cityNamelbl.text = [self.postDic objectForKey:@"post_place"];
    addresslbl.text = [self.postDic objectForKey:@"post_address"];
    
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    location.latitude = [[self.postDic objectForKey:@"post_lati"] doubleValue];
    location.longitude = [[self.postDic objectForKey:@"post_long"] doubleValue];;
    
    region.span = span;
    region.center = location;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location;
    [mapView addAnnotation:annotation];

    
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];
    
    NSString *myString = [self.postDic objectForKey:@"post_date"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"dd MMM yyyy";
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"tr-TR"]];
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    
    NSString *myString2 = [self.postDic objectForKey:@"post_time"];
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"HH:mm:ss";
    NSDate *yourTime = [dateFormatter2 dateFromString:myString2];
    dateFormatter2.dateFormat = @"HH:mm";
    NSLog(@"%@",[dateFormatter2 stringFromDate:yourTime]);
    
    timelbl.text = [[NSString alloc] initWithFormat:@"%@, %@",[dateFormatter2 stringFromDate:yourTime],  [dateFormatter stringFromDate:yourDate]];
    
    
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
