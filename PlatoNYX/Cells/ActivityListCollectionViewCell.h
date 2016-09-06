//
//  ActivityListCollectionViewCell.h
//  PlatoNYX
//
//  Created by mobilestar on 8/12/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *activityPhotoImgView;
@property (strong, nonatomic) IBOutlet UILabel *activityUnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *activityGenderlbl;
@property (strong, nonatomic) IBOutlet UILabel *activityAgelbl;

@end
