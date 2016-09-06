//
//  UpActivityTableViewCell.m
//  PlatoNYX
//
//  Created by mobilestar on 8/23/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "UpActivityTableViewCell.h"

@implementation UpActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commonUtils setCircleBorderButton:_cancelBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    [commonUtils setCircleBorderButton:_attendantsBtn withBorderWidth:1.0f withBorderColor:[appController appMainColor]];
    
    [commonUtils setCircleBorderImage:_activityThumbImg withBorderWidth:1.0f withBorderColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
