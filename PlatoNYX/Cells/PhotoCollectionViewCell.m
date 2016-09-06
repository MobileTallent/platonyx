//
//  PhotoCollectionViewCell.m
//  PlatoNYX
//
//  Created by mobilestar on 8/12/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commonUtils setRoundedRectView:self.photoCellImgView withCornerRadius:4.0f];
    //    [self.mainImageView setContentMode:UIViewContentModeScaleAspectFit];    
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.alpha = 0.5;
    }
    else {
        self.alpha = 1.f;
    }
}
@end
