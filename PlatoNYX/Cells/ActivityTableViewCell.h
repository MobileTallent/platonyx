//
//  ActivityTableViewCell.h
//  PlatoNYX
//
//  Created by mobilestar on 8/21/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"
@interface ActivityTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NZCircularImageView *activityPhotoImg;
@property (strong, nonatomic) IBOutlet UILabel *activityPlacelbl;
@property (strong, nonatomic) IBOutlet UILabel *activityNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *activityTimelbl;

@end
