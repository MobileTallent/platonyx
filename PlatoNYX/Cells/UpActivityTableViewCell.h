//
//  UpActivityTableViewCell.h
//  PlatoNYX
//
//  Created by mobilestar on 8/23/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpActivityTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *activityThumbImg;
@property (strong, nonatomic) IBOutlet UILabel *activityNamelbl;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextView *descTxt;
@property (strong, nonatomic) IBOutlet UIButton *attendantsBtn;

@end
