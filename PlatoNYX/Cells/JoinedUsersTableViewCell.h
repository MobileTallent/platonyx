//
//  JoinedUsersTableViewCell.h
//  PlatoNYX
//
//  Created by mobilestar on 9/17/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinedUsersTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userProfileImgView;
@property (strong, nonatomic) IBOutlet UILabel *userNamelbl;

@property (strong, nonatomic) IBOutlet UIButton *userLikeBtn;
@property (strong, nonatomic) IBOutlet UIButton *userDislikeBtn;


@end
