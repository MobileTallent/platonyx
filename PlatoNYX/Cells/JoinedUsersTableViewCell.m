//
//  JoinedUsersTableViewCell.m
//  PlatoNYX
//
//  Created by mobilestar on 9/17/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "JoinedUsersTableViewCell.h"

@implementation JoinedUsersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [commonUtils setCircleBorderButton:_userLikeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:_userDislikeBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
