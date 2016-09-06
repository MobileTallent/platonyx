//
//  rankingTableViewCell.h
//  PlatoNYX
//
//  Created by mobilestar on 8/23/16.
//  Copyright © 2016 marc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChildCellDelegate
-(void)didSelectChildAtIndex:(NSInteger) child;
@end

@interface rankingTableViewCell : UITableViewCell{
    NSMutableArray *mainArray;
}

@property (nonatomic, strong)  id<ChildCellDelegate> cellDelegate;

@property (strong, nonatomic) IBOutlet UILabel *activityNamelbl;
@property (strong, nonatomic) IBOutlet UIButton *nameLikeBtn;
@property (strong, nonatomic) IBOutlet UIButton *nameDislikeBtn;

@property (strong, nonatomic) IBOutlet UILabel *placelbl;
@property (strong, nonatomic) IBOutlet UIButton *placeLikeBtn;
@property (strong, nonatomic) IBOutlet UIButton *placeDislikeBtn;

@property (strong, nonatomic) IBOutlet UITableView *joinedUserTableView;


@property (nonatomic) NSMutableArray *joinedUserArray;

@end
